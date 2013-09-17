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
#import "DBPreferencesPanelController.h"

@class DBFileImportPanelController; // needed for the addPathsToPlaylistAt method

@interface DBAppDelegate : NSObject <NSApplicationDelegate> {
    
	NSWindow *mainWindow;
	DBTableView *mainPlaylist;
	DBFileImportPanel *fileImportPanel;

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

+ (NSString *) totalPlaytimeAndSongCount;

+ (void) movePlayListItems : (NSIndexSet*) rowIndexes row:(NSInteger) rowBefore;
+ (void) setCursor : (NSInteger) cursor;
+ (void) clearPlayList;

+ (void) setVolumeDB : (float) value;
+ (float) volumeDB;
+ (float) minVolumeDB;

+ (int) intConfiguration : (NSString *) key num:(NSInteger) def;

+ (void) setIntConfiguration : (NSString *) key value:(NSInteger) def;

+ (BOOL) addPathsToPlaylistAt : (NSArray *) list row:(NSInteger)rowIndex progressPanel : (DBFileImportPanel *) panel mainList : (DBTableView *) playlist;

+ (BOOL) addPathToPlaylistAtEnd : (NSString *) path;

+ (NSMutableDictionary *) keyList : (NSInteger) propertiesNumber;

+ (void) setItemSelected : (NSInteger) index value:(BOOL) def;

+ (void) updateTrackMetadata : (NSMutableDictionary *) metadata;

@end