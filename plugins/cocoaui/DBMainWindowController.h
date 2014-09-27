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

#import "DBAppDelegate.h"
#import "DBPlayListController.h"
#import "DBTextInputPanelController.h"


@interface DBMainWindowController : NSObject <NSWindowDelegate> {
		
	IBOutlet id timeSlider;
	IBOutlet id btnTogglePlay;

	IBOutlet NSSlider * volumeSlider;
	IBOutlet DBFileImportPanel *fileImportPanel;
    
    // status bar label
    IBOutlet NSTextField * statusTextField;
    
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
    
    @private
    
	NSImage * playImage;
	NSImage * playAlternateImage;
	NSImage * pauseImage;
	NSImage * pauseAlternateImage;
	
	NSTimer * windowUpdateTimer;
	   
}


// helper functions
- (BOOL) doFileImport : (BOOL) clearPlaylist;

// update functions

- (void) updateSeekBar;
- (void) updateVolumeSlider;
- (void) updateButtons;
- (void) updateStatusTextField;


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

// file or stream

- (IBAction) openFiles: (id)sender;
- (IBAction) addMusic: (id)sender;
- (IBAction) openStream: (id)sender;

// playlist management

- (IBAction) newPlaylist: (id) sender;
- (IBAction) loadPlaylist: (id) sender;
- (IBAction) savePlaylist: (id) sender;


@end
