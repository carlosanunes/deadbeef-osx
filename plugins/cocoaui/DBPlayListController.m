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
    
#import "DBPlayListController.h"

#include "../deadbeef.h"
#include "../playlist.h"
#include "../conf.h"
#include "../plugins.h"
#include "../streamer.h"
#include "../messagepump.h"

#define DB_TABLE_VIEW_TYPE @"DBTableView"

@implementation DBPlayListController

// init
- (void) awakeFromNib {

	[playlistTable setTarget: self]; // connect
	[playlistTable setDoubleAction: @selector(playSelectedItem:)]; // row double click
	[playlistTable setEnterAction: @selector(playSelectedItem:)]; // row + enter
	[playlistTable setDeleteAction: @selector(deleteSelectedItems:)]; // delete

	[playlistTable registerForDraggedTypes: [NSArray arrayWithObjects: DB_TABLE_VIEW_TYPE, (NSString*)kUTTypeFileURL, nil]];
	
	// default metadata
	metadataTypes = [NSDictionary dictionaryWithObjectsAndKeys:
		@"artist"	,	@"Artist",
		@"title"	,	@"Track Title",
		@"album"	,	@"Album",
		@"year"		,	@"Date",
		@"track"	,	@"Track Number",
		@"numtracks",	@"Total Tracks",
		@"genre"	,	@"Genre",
		@"composer" ,	@"Composer",
		@"disc"		,	@"Disc Number",
		@"comment"	,	@"Comment",
	nil];
	
	NSTableColumn * column;
//    if (!col) {
        // create default set of columns	
		column = [[NSTableColumn alloc] initWithIdentifier:@"title"];
		[[column headerCell] setStringValue:@"Title"];
		[column setEditable:false];
		[playlistTable addTableColumn:column];
	
		column = [[NSTableColumn alloc] initWithIdentifier:@"artist"];
		[[column headerCell] setStringValue:@"Artist"];
		[column setEditable:false];
		[playlistTable addTableColumn:column];

		column = [[NSTableColumn alloc] initWithIdentifier:@"album"];
		[[column headerCell] setStringValue:@"Album"];
		[column setEditable:false];
		[playlistTable addTableColumn:column];
	
		column = [[NSTableColumn alloc] initWithIdentifier:@"track"];
		[[column headerCell] setStringValue:@"Track"];
		[column setEditable:false];
		[playlistTable addTableColumn:column];

		column = [[NSTableColumn alloc] initWithIdentifier:@"duration"];
		[[column headerCell] setStringValue:@"Duration"];
		[column setEditable:false];
		[playlistTable addTableColumn:column];	
/*    }
    else {
        while (col) {
            append_column_from_textdef (listview, col->value);
            col = conf_find ("playlist.column.", col);
        }
    }
*/
    
    NSNotificationCenter * notificationCenter = [NSNotificationCenter defaultCenter];

    [notificationCenter addObserver: self
                           selector: @selector(reloadPlaylist:)
                               name: @"DB_EventPlaylistSwitched"
                             object: nil];

    [notificationCenter addObserver: self
                           selector: @selector(reloadPlaylist:)
                               name: @"DB_EventPlaylistChanged"
                             object: nil];

    [notificationCenter addObserver: self
                           selector: @selector(updateStatusColumn:)
                               name: @"DB_EventPaused"
                             object: nil];

    [notificationCenter addObserver: self
                           selector: @selector(updateStatusColumn:)
                               name: @"DB_EventSongChanged"
                             object: nil];
    
    [notificationCenter addObserver: self
                           selector: @selector(updateStatusColumn:)
                               name: @"DB_EventTrackInfoChanged"
                             object: nil];


}

- (IBAction) reloadPlaylist : sender {
    
	[playlistTable reloadData];
}


- (void) dealloc {

	[super dealloc];
}

// drag'n'drop //

- (BOOL)tableView:(NSTableView *)tv writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard*)pboard
{
    // Copy the row numbers to the pasteboard.
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:rowIndexes];
    [pboard declareTypes:[NSArray arrayWithObject:DB_TABLE_VIEW_TYPE] owner:self];
    [pboard setData:data forType:DB_TABLE_VIEW_TYPE];
    return YES;
	
}


- (NSDragOperation)tableView:(NSTableView*)tv validateDrop:(id <NSDraggingInfo>)info proposedRow:(NSInteger)row proposedDropOperation:(NSTableViewDropOperation)op
{
    // Need validation code ?
 
	return NSDragOperationEvery;
}

- (BOOL)tableView:(NSTableView *)aTableView acceptDrop:(id <NSDraggingInfo>)info
			  row:(NSInteger)row dropOperation:(NSTableViewDropOperation)operation
{
	// get the dropped object info
    NSPasteboard* pboard = [info draggingPasteboard];
		
	// check for file paths
	if ( [[pboard types] containsObject:NSFilenamesPboardType] ) {
        NSArray *files = [pboard propertyListForType:NSFilenamesPboardType];
		BOOL inserted = [DBAppDelegate addPathsToPlaylistAt:files row: row progressPanel: fileImportPanel ];

		return inserted;
    }
	
	// row
    NSData* rowData = [pboard dataForType:DB_TABLE_VIEW_TYPE];
	if (rowData == 0)
		return NO;
	
    NSIndexSet* rowIndexes = [NSKeyedUnarchiver unarchiveObjectWithData:rowData];
//    NSInteger dragRow = [rowIndexes firstIndex];
	[DBAppDelegate movePlayListItems:rowIndexes row:row];
	
	return YES;
}

// we use the selection validation method to retrieve the proposed new selected indexes while maintaining the former
- (NSIndexSet *)tableView:(NSTableView *)tableView selectionIndexesForProposedSelection:(NSIndexSet *)proposedSelectionIndexes {

	NSIndexSet * indexesToDeselect = [tableView selectedRowIndexes];
	
	// deselect old
	[indexesToDeselect enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
		[DBAppDelegate setPlaylistItemSelected:idx value:NO];
	}];
	
	// select new
	[proposedSelectionIndexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
		[DBAppDelegate setPlaylistItemSelected:idx value:YES];
	}];
	
	
	return proposedSelectionIndexes; // we do not want to change the selection
}


// datasource methods //

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
	
	return [DBAppDelegate currentPlaylistItemCount];
}


- (id) tableView:(NSTableView *)aTableView
			objectValueForTableColumn:(NSTableColumn *)aTableColumn
			row:(NSInteger)rowIndex {
	
	const char * meta = NULL;
	NSString * ident = [aTableColumn identifier];
	
	if ( [ident isEqualToString:@"playing"] )
	{
		if ([DBAppDelegate streamingTrackIndex] == rowIndex) {
			
			int paused = [DBAppDelegate outputState] == OUTPUT_STATE_PAUSED;
			BOOL buffering = ! [DBAppDelegate streamerOkToRead];
			NSImage * image = NULL;
			//TODO
			if (paused) {
				image = [NSImage imageNamed:@"paused"];
				[image setTemplate:YES];
			} else if (buffering) {
				image = [NSImage imageNamed:@"buffering"];
				[image setTemplate:YES];
			} else {
				image = [NSImage imageNamed:@"NSRightFacingTriangleTemplate"];			
			}
					
			return image;
		}
	}
	
    ddb_playlist_t *plt = deadbeef->plt_get_curr ();
    ddb_playItem_t *it = deadbeef->plt_get_item_for_idx (plt, (int) rowIndex, PL_MAIN);

    if (it == NULL)
        return NULL;
    
	deadbeef->pl_lock();
	if ( [ident isEqualToString: @"title"] )
	{
		meta = deadbeef->pl_find_meta_raw(it, "title");
		if (meta == NULL) {
			const char *f = deadbeef->pl_find_meta_raw (it, ":URI");
			meta = strrchr (f, '/');
			if (meta) {
				meta++;
			}
			else {
				meta = f;
			}
		}
	}
	else if ( [ident isEqualToString: @"duration"] )
		meta = deadbeef->pl_find_meta_raw(it, ":DURATION");
	else if ( [ident isEqualToString: @"track"] )
		meta = deadbeef->pl_find_meta_raw(it, "track");
		if (meta && meta[0] == 0) {
			meta = NULL;
		}	
	else if ( [ident isEqualToString: @"artist"] )
		meta = deadbeef->pl_find_meta_raw(it, "artist");
	else if ( [ident isEqualToString: @"album"] )
		meta = deadbeef->pl_find_meta_raw(it, "album");
	
	deadbeef->pl_unlock();
    
    if (it)
        deadbeef->pl_item_unref(it);
	if (plt)
        deadbeef->plt_unref(plt);
	
	if (meta == NULL)
		return NULL;
    
	return [NSString stringWithUTF8String: meta];
}

// selection change

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification {

    [DBAppDelegate setPlaylistItemsSelected: [playlistTable selectedRowIndexes] ];
    
}



- (IBAction) playSelectedItem: sender
{
	NSInteger rowIndex = [playlistTable selectedRow];
	[DBAppDelegate setCursor:rowIndex];
		
    if ([DBAppDelegate outputState] == OUTPUT_STATE_PAUSED) {
        ddb_playlist_t *plt = deadbeef->plt_get_curr ();
        int cur = deadbeef->plt_get_cursor (plt, PL_MAIN);
        if (cur != -1) {
            ddb_playItem_t *it = deadbeef->plt_get_item_for_idx (plt, cur, PL_MAIN);
            ddb_playItem_t *it_playing = deadbeef->streamer_get_playing_track ();
            if (it) {
                deadbeef->pl_item_unref (it);
            }
            if (it_playing) {
                deadbeef->pl_item_unref (it_playing);
            }
            if (it != it_playing) {
                deadbeef->sendmessage (DB_EV_PLAY_NUM, 0, cur, 0);
            }
            else {
                deadbeef->sendmessage (DB_EV_PLAY_CURRENT, 0, 0, 0);
            }
        }
        else {
            deadbeef->sendmessage (DB_EV_PLAY_CURRENT, 0, 0, 0);
        }
        deadbeef->plt_unref (plt);
    }
    else {
        deadbeef->sendmessage (DB_EV_PLAY_CURRENT, 0, 0, 0);
    }
}

- (IBAction) deleteSelectedItems: sender
{
	NSIndexSet * indexSet = [playlistTable selectedRowIndexes];
	__block int i = 0;
    [playlistTable deselectAll: self];
    
	deadbeef->pl_lock();
	ddb_playlist_t * plt = deadbeef->plt_get_curr ();
	[indexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
		deadbeef->plt_remove_item(plt, deadbeef->pl_get_for_idx (( (int) idx) - i) );
		++i;
	}];
	deadbeef->pl_save_all();	
	deadbeef->pl_unlock();

}

- (IBAction) playlistClear: sender
{

	[DBAppDelegate clearPlayList];
	[playlistTable deselectAll: self];
}

- (IBAction) invertSelection: sender
{
	NSIndexSet * indexSet = [playlistTable selectedRowIndexes];
	[playlistTable selectAll:sender];
	[indexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
		[playlistTable deselectRow:idx];
	}];
	
}

- (IBAction) updateStatusColumn : sender {
	
	[playlistTable setNeedsDisplayInRect:currentStatusCell];
    
    NSInteger rowOfTrack = [DBAppDelegate streamingTrackIndex];
    
	NSRect cellRect = [playlistTable frameOfCellAtColumn:0 row: rowOfTrack];
    
	if(!NSContainsRect(currentStatusCell, cellRect)) {
		oldStatusCell = currentStatusCell;
		currentStatusCell = cellRect;
	}
    
	[playlistTable setNeedsDisplayInRect:currentStatusCell];
	[playlistTable setNeedsDisplayInRect:oldStatusCell];
            
}

- (IBAction) showTrackInfo: sender
{
    DBTrackInspectorPanelController * controller = [DBTrackInspectorPanelController sharedController];
    [controller showWindow: self];

}


@end
