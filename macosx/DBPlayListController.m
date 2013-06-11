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
	[playlistTable setReloadAction: @selector(updatePlaylistInfo:)];

	[playlistTable registerForDraggedTypes: [NSArray arrayWithObjects: DB_TABLE_VIEW_TYPE, (NSString*)kUTTypeFileURL, nil]];

	[self updatePlaylistInfo: self];
	
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
		BOOL inserted = [DBAppDelegate addPathsToPlaylistAt:files row: row progressPanel: fileImportPanel  mainList: playlistTable ];

		[playlistTable reloadData];
		return inserted;
    }
	
	// row
    NSData* rowData = [pboard dataForType:DB_TABLE_VIEW_TYPE];
	if (rowData == 0)
		return NO;
	
    NSIndexSet* rowIndexes = [NSKeyedUnarchiver unarchiveObjectWithData:rowData];
//    NSInteger dragRow = [rowIndexes firstIndex];
	[DBAppDelegate movePlayListItems:rowIndexes row:row]; 
	[playlistTable reloadData];
	
	return YES;
}


// datasource methods //

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
	
	return (NSInteger) pl_getcount(PL_MAIN);
}


- (id) tableView:(NSTableView *)aTableView
			objectValueForTableColumn:(NSTableColumn *)aTableColumn
			row:(NSInteger)rowIndex {
	
	DB_playItem_t * it = pl_get_first(PL_MAIN);
	int index = 0;
    while (it) {
		if (rowIndex == index)
			break;
        DB_playItem_t *next = pl_get_next (it, PL_MAIN);
        pl_item_unref (it);
        it = next;
		++index;
    }
	
	const char * meta = NULL;
	NSString * ident = [aTableColumn identifier];
	
	if ( [ident isEqualToString:@"playing"] )
	{
		DB_playItem_t * playing_track = streamer_get_playing_track();
		if (playing_track == it) {
			
			int paused = plug_get_output()->state () == OUTPUT_STATE_PAUSED;
			int buffering = !streamer_ok_to_read (-1);
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
			
			pl_item_unref(it);
			pl_item_unref(playing_track);
			
			return image;
		}
	}
	
	pl_lock();
	if ( [ident isEqualToString: @"title"] )
	{
		meta = pl_find_meta_raw(it, "title");
		if (meta == NULL) {
			const char *f = pl_find_meta_raw (it, ":URI");
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
		meta = pl_find_meta_raw(it, ":DURATION");
	else if ( [ident isEqualToString: @"track"] )
		meta = pl_find_meta_raw(it, "track");
		if (meta && meta[0] == 0) {
			meta = NULL;
		}	
	else if ( [ident isEqualToString: @"artist"] )
		meta = pl_find_meta_raw(it, "artist");
	else if ( [ident isEqualToString: @"album"] )
		meta = pl_find_meta_raw(it, "album");
	
	pl_unlock();
	pl_item_unref(it);
		
	if (meta == NULL)
		return NULL;
	return [NSString stringWithUTF8String: meta];
}


- (IBAction) playSelectedItem: sender
{
	DB_output_t *output = plug_get_output();
	NSInteger rowIndex = [playlistTable selectedRow];
	[DBAppDelegate setCursor:rowIndex];
		
    if (output->state () == OUTPUT_STATE_PAUSED) {
        ddb_playlist_t *plt = plt_get_curr ();
        int cur = plt_get_cursor (plt, PL_MAIN);
        if (cur != -1) {
            ddb_playItem_t *it = plt_get_item_for_idx (plt, cur, PL_MAIN);
            ddb_playItem_t *it_playing = streamer_get_playing_track ();
            if (it) {
                pl_item_unref (it);
            }
            if (it_playing) {
                pl_item_unref (it_playing);
            }
            if (it != it_playing) {
                messagepump_push (DB_EV_PLAY_NUM, 0, cur, 0);
            }
            else {
                messagepump_push (DB_EV_PLAY_CURRENT, 0, 0, 0);
            }
        }
        else {
            messagepump_push (DB_EV_PLAY_CURRENT, 0, 0, 0);
        }
        plt_unref (plt);
    }
    else {
        messagepump_push (DB_EV_PLAY_CURRENT, 0, 0, 0);
    }
}

- (IBAction) deleteSelectedItems: sender
{
	NSIndexSet * indexSet = [playlistTable selectedRowIndexes];
	__block int i = 0;

	pl_lock();
	ddb_playlist_t * plt = plt_get_curr ();
	[indexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
		plt_remove_item(plt, pl_get_for_idx (( (int) idx) - i) );
		++i;
	}];
	pl_save_all();	
	pl_unlock();

	[playlistTable deselectAll: self];
	[playlistTable reloadData];
}

- (IBAction) playlistClear: sender
{

	[DBAppDelegate clearPlayList];
	
	[playlistTable deselectAll: self];
	[playlistTable reloadData];

}

- (IBAction) invertSelection: sender
{
	NSIndexSet * indexSet = [playlistTable selectedRowIndexes];
	[playlistTable selectAll:sender];
	[indexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
		[playlistTable deselectRow:idx];
	}];
	
}

- (IBAction) updatePlaylistInfo: sender
{		
	[playListInfoTable setStringValue: [DBAppDelegate totalPlaytimeAndSongCount] ];
}


- (IBAction) showTrackInfo: sender
{
	[trackPropertiesPanel makeKeyAndOrderFront:nil];
}


@end
