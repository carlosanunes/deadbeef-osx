/*
    DeaDBeeF Cocoa GUI
    Copyright (C) 2012 Carlos Nunes <carloslnunes@gmail.com>

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/


//  Based on main.c of the deadbeef main code.

#import <Cocoa/Cocoa.h>

#ifdef HAVE_CONFIG_H
#  include <config.h>
#endif
#include <sys/stat.h>

#include "playlist.h"
#include "threading.h"
#include "messagepump.h"
#include "streamer.h"
#include "conf.h"
#include "volume.h"
#include "plugins.h"
#include "common.h"

#define trace(...) { fprintf(stderr, __VA_ARGS__); }
//#define trace(fmt,...)


// some common global variables
char confdir[PATH_MAX]; // $HOME/.config
char dbconfdir[PATH_MAX]; // $HOME/.config/deadbeef
char dbinstalldir[PATH_MAX]; // see deadbeef->get_prefix
char dbdocdir[PATH_MAX]; // see deadbeef->get_doc_dir
char dbplugindir[PATH_MAX]; // see deadbeef->get_plugin_dir
char dbpixmapdir[PATH_MAX]; // see deadbeef->get_pixmap_dir


void
restore_resume_state (void) {
    DB_output_t *output = plug_get_output ();
    if (conf_get_int ("resume_last_session", 0) && output->state () == OUTPUT_STATE_STOPPED) {
        int plt = conf_get_int ("resume.playlist", -1);
        int track = conf_get_int ("resume.track", -1);
        float pos = conf_get_float ("resume.position", -1);
        int paused = conf_get_int ("resume.paused", 0);
        trace ("resume: track %d pos %f playlist %d\n", track, pos, plt);
        if (plt >= 0 && track >= 0 && pos >= 0) {
            streamer_lock (); // need to hold streamer thread to make the resume operation atomic
            streamer_set_current_playlist (plt);
            streamer_set_nextsong (track, paused ? 2 : 3);
            streamer_set_seek (pos);
            streamer_unlock ();
        }
    }
}

void
save_resume_state (void) {
    playItem_t *trk = streamer_get_playing_track ();
    DB_output_t *output = plug_get_output ();
    float playpos = -1;
    int playtrack = -1;
    int playlist = streamer_get_current_playlist ();
    int paused = (output->state () == OUTPUT_STATE_PAUSED);
    if (trk && playlist >= 0) {
        playtrack = str_get_idx_of (trk);
        playpos = streamer_get_playpos ();
        pl_item_unref (trk);
    }

    conf_set_float ("resume.position", playpos);
    conf_set_int ("resume.track", playtrack);
    conf_set_int ("resume.playlist", playlist);
    conf_set_int ("resume.paused", paused);
}


static int player_terminate;
static uintptr_t message_thread_tid;

// based on the player_mainloop function of main.c 
void
message_loop (void *ctx) {
    while (!player_terminate) {
        uint32_t msg;
        uintptr_t ctx;
        uint32_t p1;
        uint32_t p2;
        int term = 0;
        while (messagepump_pop(&msg, &ctx, &p1, &p2) != -1) {
            // broadcast to all plugins
            DB_plugin_t **plugs = plug_get_list ();
            for (int n = 0; plugs[n]; n++) {
                if (plugs[n]->message) {
                    plugs[n]->message (msg, ctx, p1, p2);
                }
            }
            DB_output_t *output = plug_get_output ();
            switch (msg) {
            case DB_EV_REINIT_SOUND:
                plug_reinit_sound ();
                streamer_reset (1);
                conf_save ();
                break;
            case DB_EV_TERMINATE:
                {
                    save_resume_state ();

                    pl_playqueue_clear ();

                    // stop streaming and playback before unloading plugins
                    DB_output_t *output = plug_get_output ();
                    output->stop ();
                    streamer_free ();
                    output->free ();
                    term = 1;
                }
                break;
            case DB_EV_PLAY_CURRENT:
                if (p1) {
                    output->stop ();
                    pl_playqueue_clear ();
                    streamer_set_nextsong (0, 1);
                }
                else {
                    streamer_play_current_track ();
                }
                break;
            case DB_EV_PLAY_NUM:
                output->stop ();
                pl_playqueue_clear ();
                streamer_set_nextsong (p1, 1);
                if (pl_get_order () == PLAYBACK_ORDER_SHUFFLE_ALBUMS) {
                    int pl = streamer_get_current_playlist ();
                    playlist_t *plt = plt_get_for_idx (pl);
                    plt_init_shuffle_albums (plt, p1);
                    plt_unref (plt);
                }
                break;
            case DB_EV_STOP:
                streamer_set_nextsong (-2, 0);
                break;
            case DB_EV_NEXT:
                output->stop ();
                streamer_move_to_nextsong (1);
                break;
            case DB_EV_PREV:
                output->stop ();
                streamer_move_to_prevsong ();
                break;
            case DB_EV_PAUSE:
                if (output->state () != OUTPUT_STATE_PAUSED) {
                    output->pause ();
                    messagepump_push (DB_EV_PAUSED, 0, 1, 0);
                }
                break;
            case DB_EV_TOGGLE_PAUSE:
                if (output->state () == OUTPUT_STATE_PAUSED) {
                    output->unpause ();
                    messagepump_push (DB_EV_PAUSED, 0, 0, 0);
                }
                else {
                    output->pause ();
                    messagepump_push (DB_EV_PAUSED, 0, 1, 0);
                }
                break;
            case DB_EV_PLAY_RANDOM:
                output->stop ();
                streamer_move_to_randomsong ();
                break;
            case DB_EV_PLAYLIST_REFRESH:
                pl_save_current ();
                messagepump_push (DB_EV_PLAYLISTCHANGED, 0, 0, 0);
                break;
            case DB_EV_CONFIGCHANGED:
                conf_save ();
                streamer_configchanged ();
                break;
            case DB_EV_SEEK:
                streamer_set_seek (p1 / 1000.f);
                break;
            }
            if (msg >= DB_EV_FIRST && ctx) {
                messagepump_event_free ((ddb_event_t *)ctx);
            }
        }
        if (term) {
            return;
        }
        messagepump_wait ();
    }
}

// player cleanup for proper exit
void
player_exit(void) {

	save_resume_state ();
	pl_playqueue_clear ();
	// stop streaming and playback before unloading plugins
	DB_output_t *output = plug_get_output ();
	output->stop ();
	streamer_free ();
	output->free ();
	
    // terminate message loop
    if(message_thread_tid) {
        player_terminate = 1;
		// send message to unblock loop
		messagepump_push (DB_EV_TERMINATE, 0, 0, 0);
		thread_join(message_thread_tid);
        message_thread_tid = 0;
    }
	
    // save config
    pl_save_all ();
    conf_save ();

    // plugins might still hood references to playitems,
    // and query configuration in background
    // so unload everything 1st before final cleanup
    plug_disconnect_all ();
    plug_unload_all ();

    fprintf (stderr, "hej-hej!\n");
}

int
main (int argc, char * argv[]) {

    strcpy (dbinstalldir, argv[0]);
    char *e = dbinstalldir + strlen (dbinstalldir);
    while (e >= dbinstalldir && *e != '/') {
        e--;
    }
    *e = 0;

    setlocale (LC_ALL, "");
    setlocale (LC_NUMERIC, "C");

    char *homedir = getenv ("HOME");
    if (!homedir) {
        fprintf (stderr, "unable to find home directory. stopping.\n");
        return -1;
    }

    if (snprintf (confdir, sizeof (confdir), "%s/.config", homedir) > sizeof (confdir)) {
        fprintf (stderr, "fatal: HOME value is too long: %s\n", homedir);
        return -1;
    }

    if (snprintf (dbconfdir, sizeof (dbconfdir), "%s/deadbeef", confdir) > sizeof (dbconfdir)) {
        fprintf (stderr, "fatal: out of memory while configuring\n");
        return -1;
    }
    mkdir (confdir, 0755);

    if (snprintf (dbdocdir, sizeof (dbdocdir), "%s/doc", dbinstalldir) > sizeof (dbdocdir)) {
        fprintf (stderr, "fatal: too long install path %s\n", dbinstalldir);
        return -1;
    }
    if (snprintf (dbplugindir, sizeof (dbplugindir), "%s/plugins", dbinstalldir) > sizeof (dbplugindir)) {
        fprintf (stderr, "fatal: too long install path %s\n", dbinstalldir);
        return -1;
    }
    mkdir (dbplugindir, 0755);

    if (snprintf (dbpixmapdir, sizeof (dbpixmapdir), "%s/pixmaps", dbinstalldir) > sizeof (dbpixmapdir)) {
        fprintf (stderr, "fatal: too long install path %s\n", dbinstalldir);
        return -1;
    }

    trace ("installdir: %s\n", dbinstalldir);
    trace ("confdir: %s\n", confdir);
    trace ("docdir: %s\n", dbdocdir);
    trace ("plugindir: %s\n", dbplugindir);
    trace ("pixmapdir: %s\n", dbpixmapdir);

    // end of global setting code

    pl_init ();
    conf_init ();
    conf_load (); // required by some plugins at startup

    conf_set_str ("deadbeef_version", VERSION);

    volume_set_db (conf_get_float ("playback.volume", 0)); // volume need to be initialized before plugins start
    messagepump_init ();    

	// start all subsystems
    messagepump_push (DB_EV_PLAYLISTCHANGED, 0, 0, 0);
    if (plug_load_all ()) { 
        exit (-1);
    }	
	
    pl_load_all ();
    plt_set_curr_idx (conf_get_int ("playlist.current", 0));

    streamer_init ();
    plug_connect_all ();

    message_thread_tid = thread_start (message_loop, NULL);

	// call clean up on exit()
	atexit(player_exit);
	
    for (int i = 0; i < argc; ++i)
    {
        trace("argv: %s", argv[i]);
    }
    // Call cocoa ui (main loop)
    // this function never returns, instead it calls exit()
	NSApplicationMain(argc, (const char**) argv);
	
}