//
//  DBAppDelegate.h
//  deadbeef
//
//  Created by Carlos Nunes on 4/28/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "views/DBTableView.h"


@interface DBAppDelegate : NSObject <NSApplicationDelegate> {
    
	NSWindow *mainWindow;
	DBTableView *mainPlaylist;
}

- (BOOL) isPlaying;
- (NSString*) playingTrackName;

- (IBAction) stopAction: (id)sender;
- (IBAction) nextAction: (id)sender;
- (IBAction) previousAction: (id)sender;
- (IBAction) togglePlay: sender;


@property (assign) IBOutlet NSWindow *mainWindow;
@property (assign) IBOutlet DBTableView *mainPlaylist;


// deadbeef core wrapper functions

+ (NSArray *) supportedFormatsExtensions;

+ (NSString *) totalPlaytimeAndSongCount;

+ (BOOL) addFilesToPlaylist : (NSArray*) list;
+ (BOOL) insertFilesToPlaylist : (NSArray*) list row:(NSInteger)rowIndex;
+ (BOOL) insertDirectory : (NSArray*) list;

+ (void) movePlayListItems : (NSIndexSet*) rowIndexes row:(NSInteger) rowBefore;
+ (void) setCursor : (NSInteger) cursor;
+ (void) clearPlayList;

+ (void) setVolumeDB : (float) value;
+ (float) volumeDB;
+ (float) minVolumeDB;

+ (int) intConfiguration : (NSString *) key num:(NSInteger) def;

+ (void) setIntConfiguration : (NSString *) key value:(NSInteger) def;

@end