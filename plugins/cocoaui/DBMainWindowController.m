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

#import "DBMainWindowController.h"

#include "../playlist.h"
#include "../messagepump.h"
#include "../streamer.h"
#include "../conf.h"
#include "../volume.h"
#include "../plugins.h"
#include "../common.h"

#include <sys/time.h>


@implementation DBMainWindowController


- (void) awakeFromNib {

	// volume bar
	[volumeSlider setMinValue: (double) [DBAppDelegate minVolumeDB] ];
	[volumeSlider setFloatValue: [DBAppDelegate volumeDB] ];
	
	
	// global update timer
	windowUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:0.3
														  target: self
                                                       selector: @selector(updateSeekBar)
														userInfo:nil
														 repeats:YES];
	
	playImage = [btnTogglePlay image];
	playAlternateImage = [btnTogglePlay alternateImage];
	pauseImage = [NSImage imageNamed:@"pause"];	
	pauseAlternateImage = [NSImage imageNamed: @"pause-pressed"];
	
	// set state of loop and order menu items
	int orderState = [DBAppDelegate intConfiguration:@"playback.order" num:0];
	int loopState = [DBAppDelegate intConfiguration:@"playback.loop" num:0];
	
	switch (orderState) {
		case PLAYBACK_ORDER_LINEAR:
			currentSelectedOrderMenuItem = orderLinearMenuItem;
			break;
		case PLAYBACK_ORDER_SHUFFLE_TRACKS:
			currentSelectedOrderMenuItem = orderShuffleTracksMenuItem;
			break;
		case PLAYBACK_ORDER_SHUFFLE_ALBUMS:
			currentSelectedOrderMenuItem = orderShuffleAlbumsMenuItem;
			break;
		case PLAYBACK_ORDER_RANDOM:
			currentSelectedOrderMenuItem = orderRandomMenuItem;
			break;
		default:
			break;
	}
	
	switch (loopState) {
		case 0: // loop all
			currentSelectedLoopMenuItem = loopAllMenuItem;
			break;
		case 1: // no loop
			currentSelectedLoopMenuItem = loopNoMenuItem;
			break;
		case 2: // loop single
			currentSelectedLoopMenuItem = loopSingleMenuItem;
			break;			
		default:
			break;
	}
	
	[currentSelectedOrderMenuItem setState: NSOnState];
	[currentSelectedLoopMenuItem setState: NSOnState];
    

    [self updateStatusTextField];
    
    NSNotificationCenter * notificationCenter = [NSNotificationCenter defaultCenter];
    
    [notificationCenter addObserver: self
                           selector: @selector(updateButtons)
                               name: @"DB_EventPaused"
                             object: nil];

    [notificationCenter addObserver: self
                           selector: @selector(updateButtons)
                               name: @"DB_EventSongChanged"
                             object: nil];
    
    [notificationCenter addObserver:self
                           selector:@selector(updateVolumeSlider)
                               name:@"DB_EventVolumeChanged"
                             object:nil];
    
    [notificationCenter addObserver: self
                           selector: @selector(updateStatusTextField)
                               name: @"DB_EventPlaylistSwitched"
                             object: nil];
    
    [notificationCenter addObserver: self
                           selector: @selector(updateStatusTextField)
                               name: @"DB_EventPlaylistChanged"
                             object: nil];
    
}

- (void) updateSeekBar  {
	
	float duration = [DBAppDelegate playingItemDuration];
	if (duration < 0) {
		[timeSlider setFloatValue:[timeSlider minValue]];
		return;
	}
	
	float pos = 0;
	int minpos = 0;
	int secpos = 0;
	if (duration > 0) {
		pos = [DBAppDelegate playingItemPosition];
		minpos = pos / 60;
		secpos = pos - minpos * 60;
		pos = pos / duration;
	}
	
	float range = [timeSlider maxValue];
	pos = pos * range;
	[timeSlider setFloatValue: pos];	
	[timeSlider setToolTip: [NSString stringWithFormat:@"%d:%02d", minpos, secpos] ]; 
		
}


- (void) updateButtons {
	
	int state = [DBAppDelegate outputState];
	
	if (state == OUTPUT_STATE_STOPPED || state == OUTPUT_STATE_PAUSED) {
		[btnTogglePlay setImage: playImage];
		[btnTogglePlay setAlternateImage: playAlternateImage];	
	} else {
		[btnTogglePlay setImage: pauseImage];
		[btnTogglePlay setAlternateImage: pauseAlternateImage];
	}
}

- (void) updateStatusTextField
{
	[statusTextField setStringValue: [DBAppDelegate totalPlaytimeAndSongCount] ];
}


- (IBAction) seekBarAction: (id)sender {

	float value;
	
	switch( [[NSApp currentEvent] type] )
    {
        case NSLeftMouseUp:
        case NSLeftMouseDown:
        case NSLeftMouseDragged:
            value = [sender floatValue];
            break;
			
        default:
            return;
    }
	
	float duration = [DBAppDelegate playingItemDuration];
	if (duration > 0) {
		float range = [sender maxValue];
		float time = (duration * value) / range;
		[DBAppDelegate seekToPosition: time * 1000];
	}
	
}

- (IBAction) volumeSliderChanged: (id)sender {
	
	float volume = [volumeSlider floatValue];
	[DBAppDelegate setVolumeDB:volume];
}


- (void) updateVolumeSlider {
    
    [volumeSlider setFloatValue: [DBAppDelegate volumeDB] ];
}

// playback commands


- (IBAction) loopAll: sender {

	[DBAppDelegate setIntConfiguration: @"playback.loop" value:0];
	[self loopMenuItemCheck: sender];

}

- (IBAction) loopSingle:  sender {

	[DBAppDelegate setIntConfiguration: @"playback.loop" value:2];
	[self loopMenuItemCheck: sender];

}

- (IBAction) loopNo: sender {

	[DBAppDelegate setIntConfiguration: @"playback.loop" value:1];
	[self loopMenuItemCheck: sender];
}

- (IBAction) loopMenuItemCheck: (id) sender {

	[currentSelectedLoopMenuItem setState: NSOffState];
	[sender setState:NSOnState];
	currentSelectedLoopMenuItem = sender;
	
}

- (IBAction) orderLinear:  sender {

	[DBAppDelegate setIntConfiguration: @"playback.order" value:PLAYBACK_ORDER_LINEAR];
	
	[self orderMenuItemCheck: sender];

}

- (IBAction) orderRandom:  sender {

	[DBAppDelegate setIntConfiguration: @"playback.order" value:PLAYBACK_ORDER_RANDOM];
	
	[self orderMenuItemCheck: sender];
	
}

- (IBAction) orderShuffleTracks: sender {

	[DBAppDelegate setIntConfiguration: @"playback.order" value:PLAYBACK_ORDER_SHUFFLE_TRACKS];	
	
	[self orderMenuItemCheck: sender];

}
- (IBAction) orderShuffleAlbum: sender {
	
	[DBAppDelegate setIntConfiguration: @"playback.order" value:PLAYBACK_ORDER_SHUFFLE_ALBUMS];	
	
	[self orderMenuItemCheck: sender];
}

- (IBAction) orderMenuItemCheck: (id) sender {

	[currentSelectedOrderMenuItem setState: NSOffState];
	[sender setState:NSOnState];
	currentSelectedOrderMenuItem = sender;
	
}

// file


- (IBAction) openFiles : sender {

    if ([self doFileImport:YES]) {
// TODO
//		DBPlayListController * controller = (DBPlayListController *) [playlistTable delegate];
//		[controller playSelectedItem: sender];
	}
}

- (IBAction) addMusic: sender {
	
	[self doFileImport:NO];
	
}

- (IBAction) addFolder:(id)sender {

    [self doFolderImport];

}


-(IBAction) openStream: sender {

    DBTextInputPanelController * controller = [DBTextInputPanelController initPanelWithTitle:NSLocalizedString(@"Open Stream...", "Open stream")];
    
	if ([controller runModal] == NSOKButton)
	{
		if (![DBAppDelegate addPathToPlaylistAtEnd: [controller textInput] ])
		{
        }
	}
    
    [controller release];
}

// opens a file import dialog and adds the selected
// files to the playlist (clearing it if clearPlayList is true)
// returns true if the user chose to open the files
- (BOOL) doFileImport : (BOOL) clearPlaylist {
	
	NSOpenPanel * openPanel = [NSOpenPanel openPanel];
    [openPanel setCanChooseDirectories:NO];
	[openPanel setAllowsMultipleSelection:YES];
	NSArray * extensions = [DBAppDelegate supportedFormatsExtensions];
	
	if ( [extensions count] == 0 )
		return NO; // TODO: Launch Error Message
	[openPanel setAllowedFileTypes: extensions ];
	
    if ( [openPanel runModal] == NSOKButton )
    {
		if(clearPlaylist)
			[DBAppDelegate clearPlayList];
		
		NSArray * files = [openPanel URLs];
		[DBAppDelegate  addPathsToPlaylistAt:files row: -1 progressPanel: fileImportPanel ];
		return YES;
    }
	return NO;
}

- (BOOL) doFolderImport {
    
    NSOpenPanel * openPanel = [NSOpenPanel openPanel];
    [openPanel setCanChooseDirectories: YES];
    [openPanel setCanChooseFiles: NO];
    
    if ([openPanel runModal] == NSOKButton)
    {
        NSArray * folders = [openPanel URLs];
        [DBAppDelegate  addPathsToPlaylistAt:folders row: -1 progressPanel: fileImportPanel ];
        
        return YES; 
    }
    
    
    return NO;
}

// playlist


- (IBAction) newPlaylist: (id) sender {
    
    [DBAppDelegate newPlaylist];
    
}

- (IBAction) loadPlaylist: (id) sender {

    NSOpenPanel * openPanel = [NSOpenPanel openPanel];
    NSURL * currentPath = [NSURL URLWithString: [DBAppDelegate stringConfiguration:@"filechooser.playlist.lastdir" str:@""] ];
    
    [openPanel setAllowedFileTypes: [DBAppDelegate supportedSavePlaylistExtensions] ];
    [openPanel setDirectoryURL:currentPath];
    
    if ([openPanel runModal] == NSOKButton)
    {
        [DBAppDelegate loadPlaylist: [openPanel URL] ];
        
    }
    

    
}

- (IBAction) savePlaylist: (id) sender {
    
    NSSavePanel * savePanel = [NSSavePanel savePanel];
    NSURL * currentPath = [NSURL URLWithString: [DBAppDelegate stringConfiguration:@"filechooser.playlist.lastdir" str:@""] ];
    
    [savePanel setAllowedFileTypes: [DBAppDelegate supportedSavePlaylistExtensions] ];
    [savePanel setDirectoryURL:currentPath];
    [savePanel setCanSelectHiddenExtension: YES];
    
    if ([savePanel runModal] == NSOKButton)
    {
        [DBAppDelegate saveCurrentPlaylist: [savePanel URL] ];
    }
    
}


@end
