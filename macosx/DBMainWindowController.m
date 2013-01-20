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
	
	shouldUpdate = YES;
	
	// global update timer
	windowUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:0.3 
														  target: self
														selector: @selector(updateWindow)
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
	
}

- (void)windowDidDeminiaturize:(NSNotification *)notification {
	shouldUpdate = YES;
}

- (void)windowDidMiniaturize:(NSNotification *)notification {
	shouldUpdate = NO;
}


- (void) updateWindow {
	
	if (shouldUpdate)
	{
		[self updateSeekBar];
		[self updateButtons];
		// reload the status column (playing/loading/stopped) 
//		[playlistTable reloadDataForRowIndexes:[NSIndexSet indexSetWithIndexesInRange: NSMakeRange(0, [playlistTable numberOfRows]) ] columnIndexes: [NSIndexSet indexSetWithIndex: 0]];
		[self updateStatusColumn];
	}
	
}


- (void) updateSeekBar {
	
	DB_playItem_t *trk = deadbeef->streamer_get_playing_track ();
	if (!trk || deadbeef->pl_get_item_duration (trk) < 0) {
		[timeSlider setFloatValue:[timeSlider minValue]];
		if(trk)
			pl_item_unref(trk);
		return;
	}
		
	float duration = pl_get_item_duration(trk);
	float pos = 0;
	int minpos = 0;
	int secpos = 0;
	if (duration > 0) {
		pos = streamer_get_playpos();
		minpos = pos / 60;
		secpos = pos - minpos * 60;
		pos = pos / duration;
	}
	
	float range = [timeSlider maxValue];
	pos = pos * range;
	[timeSlider setFloatValue: pos];	
	[timeSlider setToolTip: [NSString stringWithFormat:@"%d:%02d", minpos, secpos] ]; 
		
	pl_item_unref(trk);
		
}


- (void) updateButtons {

	DB_output_t * output = plug_get_output();
	
	if (output-> state() == OUTPUT_STATE_STOPPED || output->state() == OUTPUT_STATE_PAUSED) {
		[btnTogglePlay setImage: playImage];
		[btnTogglePlay setAlternateImage: playAlternateImage];	
	} else {
		[btnTogglePlay setImage: pauseImage];
		[btnTogglePlay setAlternateImage: pauseAlternateImage];
	}
}

// updates the status indicator column of the playlist widget (playing/loading/stopped)
- (void) updateStatusColumn {
	
	[playlistTable setNeedsDisplayInRect:currentStatusCell];
		
	playItem_t * streamingTrack = streamer_get_streaming_track();
	if (streamingTrack <= 0) {
		return;
	}
	
	NSInteger rowOfTrack = pl_get_idx_of(streamingTrack);
	NSRect cellRect = [playlistTable frameOfCellAtColumn:0 row: rowOfTrack];

	if(!NSContainsRect(currentStatusCell, cellRect)) {
		oldStatusCell = currentStatusCell;
		currentStatusCell = cellRect;
	}

	[playlistTable setNeedsDisplayInRect:currentStatusCell];
	[playlistTable setNeedsDisplayInRect:oldStatusCell];

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
	
	DB_playItem_t *trk = deadbeef->streamer_get_playing_track ();
	if (trk) {
		float range = [sender maxValue];
		float time = (pl_get_item_duration(trk) * value) / range;
		
		messagepump_push (DB_EV_SEEK, 0, time * 1000, 0);
        pl_item_unref (trk);
	}
	
}

- (IBAction) volumeSliderChanged: (id)sender {
	
	float volume = [volumeSlider floatValue];
	[DBAppDelegate setVolumeDB:volume];
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

	conf_set_int ("playback.order", PLAYBACK_ORDER_LINEAR);
    messagepump_push (DB_EV_CONFIGCHANGED, 0, 0, 0);
	
	[self orderMenuItemCheck: sender];

}

- (IBAction) orderRandom:  sender {

	conf_set_int ("playback.order", PLAYBACK_ORDER_RANDOM);
    messagepump_push (DB_EV_CONFIGCHANGED, 0, 0, 0);
	
	[self orderMenuItemCheck: sender];
	
}

- (IBAction) orderShuffleTracks: sender {

	conf_set_int ("playback.order", PLAYBACK_ORDER_SHUFFLE_TRACKS);
    messagepump_push (DB_EV_CONFIGCHANGED, 0, 0, 0);
	
	[self orderMenuItemCheck: sender];

}
- (IBAction) orderShuffleAlbum: sender {
	
    conf_set_int ("playback.order", PLAYBACK_ORDER_SHUFFLE_ALBUMS);
    messagepump_push (DB_EV_CONFIGCHANGED, 0, 0, 0);	
	
	[self orderMenuItemCheck: sender];
}

- (IBAction) orderMenuItemCheck: (id) sender {

	[currentSelectedOrderMenuItem setState: NSOffState];
	[sender setState:NSOnState];
	currentSelectedOrderMenuItem = sender;
	
}

// file


- (IBAction) openFiles : sender {

    if ([self doFileImport:TRUE]) {
		DBPlayListController * controller = (DBPlayListController *) [playlistTable delegate];
		[controller playSelectedItem: sender];
	}
}

- (IBAction) addMusic: sender {
	
	NSOpenPanel * openPanel = [NSOpenPanel openPanel];
    [openPanel setCanChooseDirectories:YES];
	[openPanel setAllowsMultipleSelection:YES];
	
	NSArray * extensionList = [DBAppDelegate supportedFormatsExtensions];
	if ( [extensionList count] == 0 )
		return; // TODO: Launch Error Message
	[openPanel setAllowedFileTypes: extensionList ];
	
	if ( [openPanel runModal] == NSOKButton )
    {
		NSArray * files = [openPanel URLs];
		[DBAppDelegate addPathsToPlaylistAt:files row: -1 progressPanel: fileImportPanel ];
		[playlistTable reloadData];
	}
	
}

// opens a file import dialog and adds the selected
// files to the playlist (clearing it if clearPlayList is true)
// returns true if the user chose to open the files
- (BOOL) doFileImport : (BOOL) clearPlaylist {
	
	NSOpenPanel * openPanel = [NSOpenPanel openPanel];
    [openPanel setCanChooseDirectories:NO];
	[openPanel setAllowsMultipleSelection:YES];
	
	NSArray * extensionList = [DBAppDelegate supportedFormatsExtensions];
	if ( [extensionList count] == 0 )
		return FALSE; // TODO: Launch Error Message
	[openPanel setAllowedFileTypes: extensionList ];
	
    if ( [openPanel runModal] == NSOKButton )
    {
		if(clearPlaylist)
			pl_clear();
		
		NSArray * files = [openPanel URLs];
		[DBAppDelegate  addPathsToPlaylistAt:files row: -1 progressPanel: fileImportPanel ];
		[playlistTable reloadData];
		return YES;
    }
	
	return NO;
}


@end
