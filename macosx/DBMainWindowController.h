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
- (IBAction) addMusic: (id)sender;

@end
