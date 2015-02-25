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
    
#import <Cocoa/Cocoa.h>

#import "views/DBTableView.h"
#import "views/DBFileImportPanel.h"
#import "DBPlayListController.h"
#import "MASPreferencesWindowController.h"
#import "DBPreferencesViewControllerSound.h"
#import "DBPreferencesViewControllerPlugins.h"
#import "DBPreferencesViewControllerNetwork.h"
#import "DBPreferencesViewControllerPlayback.h"
#import "DBSideBarItem.h"

#define PLUGIN_DATA_NAME_POS 0
#define PLUGIN_DATA_COPYRIGHT_POS 1
#define PLUGIN_DATA_WEBSITE_POS 2
#define PLUGIN_DATA_WEBSITE_VERSION 3

@class DBFileImportPanelController; // needed for the addPathsToPlaylistAt method

@interface DBAppDelegate : NSObject <NSApplicationDelegate> {
    
	NSWindow *mainWindow;
	DBTableView *mainPlaylist;
	DBFileImportPanel *fileImportPanel;
    
    MASPreferencesWindowController *preferencesWindowController;
    
}

- (IBAction) openPreferences: (id) sender;

- (BOOL) isPlaying;
- (NSString*) playingTrackName;

- (IBAction) stopAction: (id)sender;
- (IBAction) nextAction: (id)sender;
- (IBAction) previousAction: (id)sender;
- (IBAction) togglePlay: sender;

@property (assign) IBOutlet NSWindow *mainWindow;
@property (assign) IBOutlet DBTableView *mainPlaylist;
@property (assign) IBOutlet DBFileImportPanel *fileImportPanel;


// deadbeef core wrapper functions

+ (NSMutableDictionary *) knownMetadataKeys;

+ (NSArray *) supportedFormatsExtensions;
+ (NSArray *) supportedSavePlaylistExtensions;

+ (NSString *) totalPlaytimeAndSongCount;

+ (void) movePlayListItems : (NSIndexSet*) rowIndexes row:(NSInteger) rowBefore;
+ (void) setCursor : (NSInteger) cursor;
+ (void) clearPlayList;

+ (void) setVolumeDB : (float) value;
+ (float) volumeDB;
+ (float) minVolumeDB;

+ (NSInteger) currentPlaylistItemCount;

+ (int) intConfiguration : (NSString *) key num:(NSInteger) def;
+ (void) setIntConfiguration : (NSString *) key value:(NSInteger) def;

+ (NSString *) stringConfiguration : (NSString *) key str:(NSString *) def;
+ (void) setStringConfiguration : (NSString *) key value:(NSString *) def;

+ (void) removeConfiguration : (NSString *) key;

+ (BOOL) addPathsToPlaylistAt : (NSArray *) list row:(NSInteger)rowIndex progressPanel : (DBFileImportPanel *) panel;

+ (BOOL) addPathToPlaylistAtEnd : (NSString *) path;

+ (NSMutableDictionary *) keyList : (NSInteger) propertiesNumber;

+ (void) setPlaylistItemsSelected : (NSIndexSet *) indexSet;

+ (void) setPlaylistItemSelected : (NSInteger) index value:(BOOL) def;

+ (void) setCurrentPlaylist : (NSInteger) index;

+ (float) playingItemDuration;

+ (float) playingItemPosition;

+ (int) outputState;

+ (void) seekToPosition : (float) pos;

+ (void) updateSelectedTracksMetadata:(NSMutableDictionary *)metadata;

+ (NSDictionary *) pluginList;

+ (NSArray *) outputPluginList;

+ (NSArray *) replaygainModeList;

+ (NSArray *) proxyTypeList;

+ (NSString *) playlistName: (NSInteger) index;

+ (NSInteger) currentPlaylistIndex;

+ (NSInteger) streamingTrackIndex;

+ (BOOL) saveCurrentPlaylist: (NSURL *) fname;

+ (void) loadPlaylist: (NSURL *) url;

+ (BOOL) newPlaylist;

+ (void) removePlaylist: (NSInteger) num;

+ (void) setPlaylistName: (NSString *) name atIndex: (NSUInteger) idx;

+ (BOOL) streamerOkToRead;

+ (NSInteger) playlistCount;

+ (NSArray *) menuPluginActions;

@end