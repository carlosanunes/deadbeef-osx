//
//  MainController.h
//  deadbeef
//
//  Created by Carlos Nunes on 4/4/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "DBAppDelegate.h"
#import "DBPlayListController.h"

@interface DBMainWindowController : NSObject <NSWindowDelegate> {
		
	IBOutlet id timeSlider;
	IBOutlet id btnTogglePlay;

	IBOutlet NSSlider * volumeSlider;
	IBOutlet DBTableView * playlistTable;
	
	NSImage * playImage;
	NSImage * playAlternateImage;
	NSImage * pauseImage;
	NSImage * pauseAlternateImage;
	
	NSTimer * windowUpdateTimer;
	
	BOOL shouldUpdate;
	
	// order menu items
	IBOutlet NSMenuItem * orderLinearMenuItem;
	IBOutlet NSMenuItem * orderShuffleTracksMenuItem;
	IBOutlet NSMenuItem * orderShuffleAlbumsMenuItem;
	IBOutlet NSMenuItem * orderRandomMenuItem;
	
	// loop menu items
	IBOutlet NSMenuItem * loopAllMenuItem;
	IBOutlet NSMenuItem * loopNoMenuItem;
	IBOutlet NSMenuItem * loopSingleMenuItem;
	
	NSMenuItem * currentSelectedOrderMenuItem;
	NSMenuItem * currentSelectedLoopMenuItem;
	
	NSRect currentStatusCell;
	NSRect oldStatusCell;
}


// helper functions
- (BOOL) doFileImport : (BOOL) clearPlaylist;

// update functions

- (void) updateSeekBar;
- (void) updateWindow;
- (void) updateButtons;
- (void) updateStatusColumn;

// sliders

- (IBAction) volumeSliderChanged: (id)sender;
- (IBAction) seekBarAction: (id)sender;

// playback commands

- (IBAction) togglePlay: (id)sender; 

- (IBAction) loopAll: (id) sender;
- (IBAction) loopSingle: (id) sender;
- (IBAction) loopNo: (id) sender;

- (IBAction) loopMenuItemCheck: (id) sender; // to check and uncheck the correct loop menu items

- (IBAction) orderLinear: (id) sender;
- (IBAction) orderRandom: (id) sender;
- (IBAction) orderShuffleTracks: (id) sender;
- (IBAction) orderShuffleAlbum: (id) sender;

- (IBAction) orderMenuItemCheck: (id) sender; // to check and uncheck the correct order menu items

// file

- (IBAction) openFiles: (id)sender;
- (IBAction) addFiles: (id)sender;
- (IBAction) addDirectory: (id)sender;


@end
