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

#import "DBSidebarViewController.h"

@implementation DBSidebarViewController 

- (void) awakeFromNib {
    
    [sidebarView setTarget:self];
    [sidebarView setDeleteAction: @selector(deleteSelectedItems:)];
    
    sidebarItems = [[NSMutableArray array] retain];
    
    DBSideBarItem * playlistItem = [DBSideBarItem itemWithName:@"PLAYLISTS" isHeader:YES identifier:GROUP_PLAYLIST];
    NSUInteger count = [DBAppDelegate playlistCount];
    NSMutableArray * playlists = [NSMutableArray arrayWithCapacity: count];
    for (NSInteger i = 0; i < count; ++i) {
        [playlists addObject: [DBSideBarItem itemWithName:[DBAppDelegate playlistName:i] isHeader: NO identifier:@"playlist"] ];
    }
    [playlistItem setChildren: playlists];
    
    [sidebarItems addObject: playlistItem];

    [sidebarView reloadData];

    // Expand all the root items; disable the expansion animation that normally happens
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:0];
    [sidebarView expandItem:nil expandChildren:YES];
    [NSAnimationContext endGrouping];
    
    [sidebarView selectRowIndexes: [NSIndexSet indexSetWithIndex: [DBAppDelegate intConfiguration:@"playlist.current" num:0] + 1 ] byExtendingSelection:NO ];
    

    NSNotificationCenter * notificationCenter = [NSNotificationCenter defaultCenter];
    
    [notificationCenter addObserver: self
                           selector: @selector(updatePlaylistItems)
                               name: @"DB_EventPlaylistSwitched"
                             object: nil];

}




- (void) updatePlaylistItems {

    NSUInteger count = [DBAppDelegate playlistCount];
    NSMutableArray * playlists = [NSMutableArray arrayWithCapacity: count];
    for (NSInteger i = 0; i < count; ++i) {
        [playlists addObject: [DBSideBarItem itemWithName:[DBAppDelegate playlistName:i] isHeader: NO identifier:@"playlist"] ];
    }
    [[sidebarItems objectAtIndex: GROUP_PLAYLIST_INDEX] setChildren: playlists];
    
//    [sidebarView reloadItem: [sidebarItems objectAtIndex:0] reloadChildren: YES ];
 //   [sidebarView reloadData];
    
}

- (IBAction) deleteSelectedItems: sender {
    
    if ([sidebarView selectedRow] != -1) {
        DBSideBarItem *item = [sidebarView itemAtRow:[sidebarView selectedRow]];
        if ([item isHeader] == NO) {
            // Only change things for non header items
            if ( [[item identifier] isEqualToString: @"playlist"] ) {
                [DBAppDelegate removePlaylist: [[[sidebarItems objectAtIndex:GROUP_PLAYLIST_INDEX] children] indexOfObject: item] ];
            }
        }
    }
    
}



#pragma mark - Helpers

- (BOOL) isItemHeader:(id)item{
    
    if([item isKindOfClass:[DBSideBarItem class]]){
            return [((DBSideBarItem *)item) performSelector:@selector(isHeader)];
    }
    
    return NO;
}


#pragma mark - NSOutlineViewDelegate

- (void) outlineViewSelectionDidChange:(NSNotification *)notification {
    
    if ([sidebarView selectedRow] != -1) {
        DBSideBarItem *item = [sidebarView itemAtRow:[sidebarView selectedRow]];
        if ([item isHeader] == NO) {
            // Only change things for non header items
            if ( [[item identifier] isEqualToString: @"playlist"] ) {
                [DBAppDelegate setCurrentPlaylist: [[[sidebarItems objectAtIndex:GROUP_PLAYLIST_INDEX] children] indexOfObject: item] ];
            }
        }
    }
    
}


- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item{
    
    return ![self isItemHeader:item];
}

- (NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item {
    
    if ([self isItemHeader:item]) {
        NSTableCellView * result = [outlineView makeViewWithIdentifier:@"HeaderCell" owner:self];
        [result setObjectValue: item];
        return result;
    }
    
    NSTableCellView * result =  [outlineView makeViewWithIdentifier:@"DataCell" owner:self];
    [result setObjectValue: item];
    return result;
}


- (BOOL)outlineView:(NSOutlineView *)outlineView isGroupItem:(id)item{
    // This converts a group to a header which influences its style

    return [self isItemHeader:item];
}


/* datasource methods */

#pragma mark - NSOutlineViewDataSource

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
    // root
    if (item == nil) {
        return [sidebarItems count];
    }
    
    return [[(DBSideBarItem *) item children] count];
        
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item
{

    // root
    if (item == nil) {
        return [sidebarItems objectAtIndex:index];
    }
    
    return [[(DBSideBarItem *) item children ] objectAtIndex:index];
    
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item {
    
    // root
    if (item == nil) {
        return [sidebarItems count] > 0;
    }

    return [[(DBSideBarItem *) item children ] count ] > 0;
    
}


@end
