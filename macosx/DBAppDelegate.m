//
//  DBAppDelegate.m
//  deadbeef
//
//  Created by Carlos Nunes on 4/28/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "DBAppDelegate.h"
#import "DBMainWindowController.h"

#include "../playlist.h"
#include "../plugins.h"
#include "../streamer.h"
#include "../conf.h"
#include "../volume.h"
#include "../messagepump.h"


@implementation DBAppDelegate

@synthesize mainWindow;
@synthesize mainPlaylist;


- (BOOL)application:(NSApplication *)theApplication openFile:(NSString *)filename {
		
	return [DBAppDelegate addFilesToPlaylist: [NSArray arrayWithObject:filename] ];
}

- (void)application:(NSApplication *)sender openFiles:(NSArray *)filenames {

	printf("Opening: %s\n", [[filenames objectAtIndex:0] UTF8String]);
	
	[DBAppDelegate addFilesToPlaylist:filenames];

	[mainPlaylist reloadData];
}


- (NSMenu *) applicationDockMenu:(NSApplication *)sender {

	NSMenu * menu = [[NSMenu alloc] init];
		
	NSString * playToggleString = NULL;
	if([self isPlaying]) {
		playToggleString = NSLocalizedString(@"Pause", "Dock item");
		[menu addItemWithTitle:NSLocalizedString(@"Now playing", "Dock item") action:nil keyEquivalent:@""];
		NSString * trackName = [self playingTrackName];		
		[menu addItemWithTitle:[NSString stringWithFormat:@"%@%@", @"   ", trackName] action:nil keyEquivalent:@""];
		[menu addItem:[NSMenuItem separatorItem]];
	} else {
		playToggleString = NSLocalizedString(@"Play", "Dock item");
	}

	[menu addItemWithTitle: playToggleString action:@selector(togglePlay:) keyEquivalent:@""];
	[menu addItemWithTitle: NSLocalizedString(@"Next", "Dock item") action:@selector(nextAction:) keyEquivalent:@""];
	[menu addItemWithTitle: NSLocalizedString(@"Previous", "Dock item") action:@selector(previousAction:) keyEquivalent:@""];
	
	return [menu autorelease];
}


- (BOOL)applicationShouldHandleReopen:(NSApplication*)theApplication
					hasVisibleWindows:(BOOL)flag{
	[mainWindow orderFront:nil];
	[mainWindow makeKeyWindow];
	return TRUE;
}

/* = deadbeef core functionality
 */

- (BOOL) isPlaying {

	DB_output_t * output = plug_get_output();
	
	if (output-> state() == OUTPUT_STATE_PLAYING) 
		return YES;
	
	return NO;
}

- (NSString*) playingTrackName {

	pl_lock();
	
	const char * meta = NULL;
	DB_playItem_t * it = streamer_get_playing_track();
	
	
	meta = pl_find_meta_raw(it, "title");
	if (meta == NULL) {
		const char *f = pl_find_meta_raw (it, ":URI");
		meta = strrchr (f, '/');
		if (meta) {
			meta++;
		}
		else {
			meta = f;
		}
	}
	
	pl_unlock();
	pl_item_unref(it);
	
	return [NSString stringWithUTF8String: meta];
}

- (IBAction) stopAction : sender {
	
    messagepump_push (DB_EV_STOP, 0, 0, 0);		
}


- (IBAction) previousAction : sender {
	
    messagepump_push (DB_EV_PREV, 0, 0, 0);    
}

- (IBAction) nextAction : sender {
	
    messagepump_push (DB_EV_NEXT, 0, 0, 0);
}


- (IBAction) togglePlay: sender 
{
	DB_output_t * output = plug_get_output();
	
	if (output-> state() == OUTPUT_STATE_STOPPED) 
	{
		messagepump_push(DB_EV_PLAY_CURRENT, 0, 0, 0);
		return;
	}	
	
	messagepump_push (DB_EV_TOGGLE_PAUSE, 0, 0, 0);
	
}


/* = deadbeef core helper functions 
 */

+ (NSString *) totalPlaytimeAndSongCount {

	float pl_totaltime = pl_get_totaltime ();
    int daystotal = (int)pl_totaltime / (3600*24);
    int hourtotal = ((int)pl_totaltime / 3600) % 24;
    int mintotal = ((int)pl_totaltime/60) % 60;
    int sectotal = ((int)pl_totaltime) % 60;
	
	char totaltime_str[512] = "";
	if (daystotal > 1) {
        snprintf (totaltime_str, sizeof (totaltime_str), ", %d days", daystotal);		
	} else if (daystotal == 1) {
        snprintf (totaltime_str, sizeof (totaltime_str), ", 1 day");			
	}
	
	if(hourtotal) {
        snprintf (totaltime_str, sizeof (totaltime_str), "%s, %d hours", totaltime_str, hourtotal);				
	}
	
	if(mintotal) {
        snprintf (totaltime_str, sizeof (totaltime_str), "%s, %d minutes", totaltime_str, mintotal);				
	}
	
	if(sectotal) {
        snprintf (totaltime_str, sizeof (totaltime_str), "%s, %d seconds", totaltime_str, sectotal);				
	}	
	
	return [NSString stringWithFormat:@"%d song(s)%s", pl_getcount(PL_MAIN), totaltime_str];
}

/*
 - (void) updateSongInfo {
 
 DB_output_t *output = plug_get_output ();
 
 char sbtext_new[512] = "-";
 float songpos = last_songpos;
 
 float pl_totaltime = pl_get_totaltime ();
 int daystotal = (int)pl_totaltime / (3600*24);
 int hourtotal = ((int)pl_totaltime / 3600) % 24;
 int mintotal = ((int)pl_totaltime/60) % 60;
 int sectotal = ((int)pl_totaltime) % 60;
 
 char totaltime_str[512] = "";
 if (daystotal == 0) {
 snprintf (totaltime_str, sizeof (totaltime_str), "%d:%02d:%02d", hourtotal, mintotal, sectotal);
 }
 else if (daystotal == 1) {
 snprintf (totaltime_str, sizeof (totaltime_str), _("1 day %d:%02d:%02d"), hourtotal, mintotal, sectotal);
 }
 else {
 snprintf (totaltime_str, sizeof (totaltime_str), _("%d days %d:%02d:%02d"), daystotal, hourtotal, mintotal, sectotal);
 }
 
 DB_playItem_t *track = streamer_get_playing_track ();
 DB_fileinfo_t *c = streamer_get_current_fileinfo (); // FIXME: might crash streamer
 
 float duration = track ? pl_get_item_duration (track) : -1;
 
 if (!output || (output->state () == OUTPUT_STATE_STOPPED || !track || !c)) {
 snprintf (sbtext_new, sizeof (sbtext_new), _("Stopped | %d tracks | %s total playtime"), pl_getcount (PL_MAIN), totaltime_str);
 songpos = 0;
 }
 else {
 float playpos = streamer_get_playpos ();
 int minpos = playpos / 60;
 int secpos = playpos - minpos * 60;
 int mindur = duration / 60;
 int secdur = duration - mindur * 60;
 
 const char *mode;
 char temp[20];
 if (c->fmt.channels <= 2) {
 mode = c->fmt.channels == 1 ? _("Mono") : _("Stereo");
 }
 else {
 snprintf (temp, sizeof (temp), "%dch Multichannel", c->fmt.channels);
 mode = temp;
 }
 int samplerate = c->fmt.samplerate;
 int bitspersample = c->fmt.bps;
 songpos = playpos;
 //        codec_unlock ();
 
 char t[100];
 if (duration >= 0) {
 snprintf (t, sizeof (t), "%d:%02d", mindur, secdur);
 }
 else {
 strcpy (t, "-:--");
 }
 
 struct timeval tm;
 gettimeofday (&tm, NULL);
 if (tm.tv_sec - last_br_update.tv_sec + (tm.tv_usec - last_br_update.tv_usec) / 1000000.0 >= 0.3) {
 memcpy (&last_br_update, &tm, sizeof (tm));
 int bitrate = streamer_get_apx_bitrate ();
 if (bitrate > 0) {
 snprintf (sbitrate, sizeof (sbitrate), _("| %4d kbps "), bitrate);
 }
 else {
 sbitrate[0] = 0;
 }
 }
 const char *spaused = plug_get_output ()->state () == OUTPUT_STATE_PAUSED ? _("Paused | ") : "";
 const char *filetype = pl_find_meta (track, ":FILETYPE");
 if (!filetype) {
 filetype = "-";
 }
 snprintf (sbtext_new, sizeof (sbtext_new), _("%s%s %s| %dHz | %d bit | %s | %d:%02d / %s | %d tracks | %s total playtime"), spaused, filetype, sbitrate, samplerate, bitspersample, mode, minpos, secpos, t, deadbeef->pl_getcount (PL_MAIN), totaltime_str);
 }
 
 if (strcmp (sbtext_new, sb_text)) {
 strcpy (sb_text, sbtext_new);
 
 // form statusline
 // FIXME: don't update if window is not visible
 GtkStatusbar *sb = GTK_STATUSBAR (lookup_widget (mainwin, "statusbar"));
 if (sb_context_id == -1) {
 sb_context_id = gtk_statusbar_get_context_id (sb, "msg");
 }
 
 gtk_statusbar_pop (sb, sb_context_id);
 gtk_statusbar_push (sb, sb_context_id, sb_text);
 }
 
 if (mainwin) {
 GtkWidget *widget = lookup_widget (mainwin, "seekbar");
 // translate volume to seekbar pixels
 songpos /= duration;
 GtkAllocation a;
 gtk_widget_get_allocation (widget, &a);
 songpos *= a.width;
 if (fabs (songpos - last_songpos) > 0.01) {
 gtk_widget_queue_draw (widget);
 last_songpos = songpos;
 }
 }
 if (track) {
 pl_item_unref (track);
 }
 }
 */



+ (NSArray *) supportedFormatsExtensions {
    
    NSMutableArray * array = [NSMutableArray arrayWithObjects: nil];
	
	DB_decoder_t **codecs = plug_get_decoder_list ();
    for (int i = 0; codecs[i]; ++i) {
        if (codecs[i]->exts && codecs[i]->insert) {
            const char **exts = codecs[i]->exts;
            for (int e = 0; exts[e]; e++) {
                [array addObject: [NSString stringWithCString:exts[e] encoding:NSUTF8StringEncoding] ];
            }
        }
	}

	DB_vfs_t **vfsplugs = deadbeef->plug_get_vfs_list ();
    for (int i = 0; vfsplugs[i]; i++) {
        if (vfsplugs[i]->is_container) {
			const char **scheme_list = vfsplugs[i] -> get_schemes();			
			for(int e = 0; scheme_list[e]; ++e) {
				NSString * ext = [NSString stringWithCString:scheme_list[e] encoding:NSUTF8StringEncoding];
				// adds to the list removing the trailling "://"
				[array addObject: [ext substringToIndex: [ext rangeOfString:@":"].location] ];
			}
        }
    }
	
	return array;
}

/*
	accepts both a NSURL list as well as a NSSring list
*/
+ (BOOL) addFilesToPlaylist : (NSArray *) list {
	
    ddb_playlist_t * plt = plt_get_curr ();
    if ( pl_add_files_begin (plt) < 0) {
        plt_unref (plt);
        return NO;
    }
	
    NSString * file;
    const char * filename;
    for (int i=0; i<[list count]; ++i) {
		// check for arg type
		if([[list objectAtIndex:i] isKindOfClass:[NSURL class]]) { 
			file = [[list objectAtIndex:i] path];
		} else {
			file = [list objectAtIndex:i];
		}

		filename = [file cStringUsingEncoding:NSUTF8StringEncoding];

		// TODO: progress bar or similar
		printf("%s\n",filename);
        plt_add_file (plt, filename, NULL, NULL);
    }
	
    pl_add_files_end ();
    plt_unref (plt);
    pl_save_all ();
    conf_save ();
	
	return YES;
}


+ (BOOL) insertFilesToPlaylist :  (NSArray*) list  row:(NSInteger)rowIndex{

	ddb_playlist_t *plt = plt_get_curr ();
	if (pl_add_files_begin (plt) < 0) {
        plt_unref (plt);
        return NO;
    }
	
	playItem_t * after = NULL;
	playItem_t * inserted = NULL;
	int abort = 0;
    NSString * file;
    const char * filename;
	
	after = pl_get_for_idx(rowIndex - 1);
	
    for (int i=0; i<[list count]; ++i) {
		// check for arg type
		if([[list objectAtIndex:i] isKindOfClass:[NSURL class]]) { 
			file = [[list objectAtIndex:i] path];
		} else {
			file = [list objectAtIndex:i];
		}
		filename = [file cStringUsingEncoding:NSUTF8StringEncoding];
		
		// inserting file
		// TODO: import dialog
		inserted = plt_insert_file (plt, after, filename, &abort, NULL, NULL);
		if (inserted) {
			if (after) {
				pl_item_unref (after);
			}
			after = inserted;
			pl_item_ref (after);
		}
		
	}
	
	if (after)
        deadbeef->pl_item_unref (after);
	
	pl_add_files_end ();
    plt_unref (plt);
    pl_save_all ();	
		
	return YES;
}

+ (BOOL) insertDirectory : (NSArray*) list {

	ddb_playlist_t *plt = plt_get_curr ();
	if (pl_add_files_begin (plt) < 0) {
        plt_unref (plt);
        return NO;
    }

	playItem_t * after = pl_get_last (PL_MAIN);
	playItem_t * inserted = NULL;
	int abort = 0;
    NSString * file;
    const char * filename;	
	
	for (int i=0; i<[list count]; ++i) {
		// check for arg type
		if([[list objectAtIndex:i] isKindOfClass:[NSURL class]]) { 
			file = [[list objectAtIndex:i] path];
		} else {
			file = [list objectAtIndex:i];
		}
		filename = [file cStringUsingEncoding:NSUTF8StringEncoding];
		
		// inserting directory
		// TODO: import dialog
		inserted = plt_insert_dir (plt, after, filename, &abort, NULL, NULL);
		if (inserted) {
			if (after) {
				pl_item_unref (after);
			}
			after = inserted;
			pl_item_ref (after);
		}
		
	}
	
	
	if (after)
        deadbeef->pl_item_unref (after);
	
	pl_add_files_end ();
    plt_unref (plt);
    pl_save_all ();	
	
	return YES;	
	
}


+ (void) movePlayListItems : (NSIndexSet*) rowIndexes row:(NSInteger) rowBefore {

	pl_lock();
	ddb_playlist_t *plt = deadbeef->plt_get_curr ();
	
	int count = 0;
	playItem_t * dropBefore = NULL;
	uint32_t indexes[count];
	int n = 0;
	
	count = [rowIndexes count];
	dropBefore = pl_get_for_idx(rowBefore);
	
	NSUInteger index = [rowIndexes firstIndex];
	while (index != NSNotFound) {
		indexes[n] = index;
		++n;
		index = [rowIndexes indexGreaterThanIndex:index ];
	}

	plt_move_items( (playlist_t *)plt, PL_MAIN, (playlist_t *)plt, dropBefore, indexes, count);
	
	plt_unref(plt);
	pl_unlock();
	pl_save_all();
}



+ (void) setCursor : (NSInteger) cursor {

    char conf[100];
    snprintf (conf, sizeof (conf), "playlist.cursor.%d", deadbeef->plt_get_curr_idx ());
    conf_set_int (conf, (int) cursor);
    return pl_set_cursor (PL_MAIN, (int) cursor);
}

+ (void) clearPlayList {

	pl_clear();
	pl_save_all();
}


+ (void) setVolumeDB:(float)value {

	volume_set_db(value);
}

+ (float) volumeDB {
	
	return volume_get_db();

}

+ (float) minVolumeDB {

	return volume_get_min_db();
}

+ (int) intConfiguration : (NSString *) key num:(NSInteger) def {

	return conf_get_int([key UTF8String], def);
}

+ (void) setIntConfiguration : (NSString *) key value:(NSInteger) def {

	return conf_set_int([key UTF8String], def);
}


@end
