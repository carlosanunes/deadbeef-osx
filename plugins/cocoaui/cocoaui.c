#include "../../deadbeef.h"
#include "cocoaui_api.h"

#define trace(...) { fprintf(stderr, __VA_ARGS__); }
//#define trace(fmt,...)

static ddb_cocoaui_t plugin;
DB_functions_t *deadbeef;

static int
cocoaui_start (void) {
//    fprintf (stderr, "cocoaui plugin compiled for : %d.%d.%d\n", GTK_MAJOR_VERSION, GTK_MINOR_VERSION, GTK_MICRO_VERSION);

    // Call cocoa ui (main loop)
    // this function never returns, instead it calls exit()
    int argc = 0;
    char** argv = NULL;
	
    NSApplicationMain(argc, (const char**) argv);

    return 0;
}

static int
cocoaui_stop (void) {
    return 0;
}

static int
cocoaui_connect (void) {
    return 0;
}

static int
cocoaui_disconnect (void) {
    return 0;
}

int
cocoaui_message (uint32_t id, uintptr_t ctx, uint32_t p1, uint32_t p2) {

    switch (id) {
    case DB_EV_ACTIVATED:
        break;
    case DB_EV_SONGCHANGED:
        break;
    case DB_EV_TRACKINFOCHANGED:
        break;
    case DB_EV_PAUSED:
        break;
    case DB_EV_PLAYLISTCHANGED:
        break;
    case DB_EV_VOLUMECHANGED:
        break;
    case DB_EV_CONFIGCHANGED:
        break;
    case DB_EV_OUTPUTCHANGED:
        break;
    case DB_EV_PLAYLISTSWITCHED:
        break;
    case DB_EV_ACTIONSCHANGED:
        break;
    case DB_EV_DSPCHAINCHANGED:
        break;
    }

    return 0;
}

static const char settings_dlg [] = "";

DB_plugin_t *
ddb_gui_cocoa_load(DB_functions_t * api) {
	deadbeef = api;
	return DB_PLUGIN (&plugin);
}

// define plugin interface
static ddb_cocoaui_t plugin = {
    .gui.plugin.api_vmajor = 1,
    .gui.plugin.api_vminor = 5,
    .gui.plugin.version_major = 1,
    .gui.plugin.version_minor = 0,
    .gui.plugin.type = DB_PLUGIN_GUI,
    .gui.plugin.id = "cocoaui",
    .gui.plugin.name = "Cocoa user interface",
    .gui.plugin.descr = "User interface using the Cocoa framework",
    .gui.plugin.copyright = 
        "Copyright (C) 2013 Carlos Nunes <carloslnunes@gmail.com>\n"
	 	"\n"
		"This plugin is free software; you can redistribute it and/or"
		"modify it under the terms of the GNU Lesser General Public"
		"License as published by the Free Software Foundation; either"
		"version 2 of the License, or (at your option) any later version."
	 	"\n"
		"This plugin is distributed in the hope that it will be useful,"
		"but WITHOUT ANY WARRANTY; without even the implied warranty of"
		"MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU"
		"Lesser General Public License for more details."
	 	"\n"
		"You should have received a copy of the GNU Lesser General Public"
		"License along with this library; if not, write to the Free Software"
		"Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA"
    ,
    .gui.plugin.website = "",
    .gui.plugin.start = cocoaui_start,
    .gui.plugin.stop = cocoaui_stop,
    .gui.plugin.connect = cocoaui_connect,
    .gui.plugin.disconnect = cocoaui_disconnect,
    .gui.plugin.configdialog = settings_dlg,
    .gui.plugin.message = cocoaui_message,
};
