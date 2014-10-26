/*
    DeaDBeeF Cocoa GUI
    Copyright (C) 2014 Carlos Nunes <carloslnunes@gmail.com>

    This software is provided 'as-is', without any express or implied
    warranty. In no event will the authors be held liable for any damages
    arising from the use of this software.

    Permission is granted to anyone to use this software for any purpose,
    including commercial applications, and to alter it and redistribute it
    freely, subject to the following restrictions:

    1. The origin of this software must not be misrepresented; you must not
       claim that you wrote the original software. If you use this software
       in a product, an acknowledgment in the product documentation would be
       appreciated but is not required.
    2. Altered source versions must be plainly marked as such, and must not be
       misrepresented as being the original software.
    3. This notice may not be removed or altered from any source distribution.

*/

#include "../../deadbeef.h"

#define trace(...) { fprintf(stderr, __VA_ARGS__); }
//#define trace(fmt,...)

typedef struct {
    DB_gui_t gui;

} ddb_cocoaui_t;

static ddb_cocoaui_t plugin;
DB_functions_t *deadbeef;

static int
cocoaui_start (void) {

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

    NSNotificationCenter * notificationCenter = [NSNotificationCenter defaultCenter];
    
    switch (id) {
    case DB_EV_ACTIVATED:
        [notificationCenter postNotificationName:@"DB_EventActivated" object:nil];
        break;
    case DB_EV_SONGCHANGED:
        [notificationCenter postNotificationName:@"DB_EventSongChanged" object:nil];
        break;
    case DB_EV_TRACKINFOCHANGED:
        [notificationCenter postNotificationName:@"DB_EventTrackInfoChanged" object:nil];
        break;
    case DB_EV_PAUSED:
        [notificationCenter postNotificationName:@"DB_EventPaused" object:nil];
        break;
    case DB_EV_PLAYLISTCHANGED:
       [notificationCenter postNotificationName:@"DB_EventPlaylistChanged" object:nil];
        break;
    case DB_EV_VOLUMECHANGED:
        [notificationCenter postNotificationName:@"DB_EventVolumeChanged" object:nil];
        break;
    case DB_EV_CONFIGCHANGED:
        [notificationCenter postNotificationName:@"DB_EventConfigChanged" object:nil];
        break;
    case DB_EV_OUTPUTCHANGED:
        [notificationCenter postNotificationName:@"DB_EventOutputChanged" object:nil];
        break;
    case DB_EV_PLAYLISTSWITCHED:
        [notificationCenter postNotificationName:@"DB_EventPlaylistSwitched" object:nil];
        break;
    case DB_EV_ACTIONSCHANGED:
        [notificationCenter postNotificationName:@"DB_EventActionChanged" object:nil];
        break;
    case DB_EV_DSPCHAINCHANGED:
        [notificationCenter postNotificationName:@"DB_EventDSPChainChanged" object:nil];
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
    "Copyright (C) 2013-2014 Carlos Nunes <carloslnunes@gmail.com>"
    "\n"
    "This software is provided 'as-is', without any express or implied"
    "warranty. In no event will the authors be held liable for any damages"
    "arising from the use of this software."
    "\n"
    "Permission is granted to anyone to use this software for any purpose,"
    "including commercial applications, and to alter it and redistribute it"
    "freely, subject to the following restrictions:"
    "\n"
    "1. The origin of this software must not be misrepresented; you must not"
    "   claim that you wrote the original software. If you use this software"
    "   in a product, an acknowledgment in the product documentation would be"
    "   appreciated but is not required."
    "2. Altered source versions must be plainly marked as such, and must not be"
    "   misrepresented as being the original software."
    "3. This notice may not be removed or altered from any source distribution."
    ,
    .gui.plugin.website = "",
    .gui.plugin.start = cocoaui_start,
    .gui.plugin.stop = cocoaui_stop,
    .gui.plugin.connect = cocoaui_connect,
    .gui.plugin.disconnect = cocoaui_disconnect,
    .gui.plugin.configdialog = settings_dlg,
    .gui.plugin.message = cocoaui_message,
};
