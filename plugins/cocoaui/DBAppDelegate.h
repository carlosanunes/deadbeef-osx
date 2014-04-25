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

#import <Cocoa/Cocoa.h>

#import "views/DBTableView.h"
#import "views/DBFileImportPanel.h"
#import "DBPlayListController.h"
#import "MASPreferencesWindowController.h"
#import "DBPreferencesViewControllerSound.h"
#import "DBPreferencesViewControllerPlugins.h"
#import "DBPreferencesViewControllerNetwork.h"
#import "DBPreferencesViewControllerPlayback.h"

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

+ (NSInteger) mainPlayListCount;

+ (int) intConfiguration : (NSString *) key num:(NSInteger) def;
+ (void) setIntConfiguration : (NSString *) key value:(NSInteger) def;

+ (NSString *) stringConfiguration : (NSString *) key str:(NSString *) def;
+ (void) setStringConfiguration : (NSString *) key value:(NSString *) def;

+ (BOOL) addPathsToPlaylistAt : (NSArray *) list row:(NSInteger)rowIndex progressPanel : (DBFileImportPanel *) panel mainList : (DBTableView *) playlist;

+ (BOOL) addPathToPlaylistAtEnd : (NSString *) path;

+ (NSMutableDictionary *) keyList : (NSInteger) propertiesNumber;

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

+ (NSDictionary *) availablePlaylists;

+ (NSInteger) currentPlaylistIndex;

+ (BOOL) saveCurrentPlaylist: (NSURL *) fname;

+ (void) loadPlaylist: (NSURL *) url;

+ (BOOL) newPlaylist;

@end