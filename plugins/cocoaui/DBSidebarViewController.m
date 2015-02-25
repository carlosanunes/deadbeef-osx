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
    
    DBGroupSideBarItem * playlistItem = [DBGroupSideBarItem itemWithName:@"PLAYLISTS"  identifier:GROUP_PLAYLIST];
    NSUInteger count = [DBAppDelegate playlistCount];
    NSMutableArray * playlists = [[NSMutableArray arrayWithCapacity: count] retain];
    for (NSInteger i = 0; i < count; ++i) {
        [playlists addObject: [DBPlaylistSideBarItem playlistAtIndex:i parent: playlistItem ] ];
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
    DBGroupSideBarItem * playlistsGroup = [sidebarItems objectAtIndex: GROUP_PLAYLIST_INDEX];
    BOOL reload = NO;
    
    // add proxy objects if needed
    while ([playlistsGroup numChildren] < count) {
        [playlistsGroup addChild: [DBPlaylistSideBarItem playlistAtIndex: [playlistsGroup numChildren]  parent: playlistsGroup ]];
        reload = YES;
    }

    // remove proxy objects if needed
    while ([playlistsGroup numChildren] > count) {
        [playlistsGroup removeLastChild];
        reload = YES;
    }

    if (reload) {
        [sidebarView reloadData];
    }

}

- (IBAction) deleteSelectedItems: sender {
    
    if ([sidebarView selectedRow] != -1) {
        DBSideBarItem *item = [sidebarView itemAtRow:[sidebarView selectedRow]];
        if ([item isHeader] == NO) {
            // Only change things for non header items
            if ( [[item identifier] isEqualToString: @"playlist"] ) {
                [DBAppDelegate removePlaylist: [ ((DBPlaylistSideBarItem *) item) idx] ];
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
                [DBAppDelegate setCurrentPlaylist: [ ((DBPlaylistSideBarItem *) item) idx]];
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
    
    return [(DBSideBarItem *) item numChildren];
        
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item
{

    // root
    if (item == nil) {
        return [sidebarItems objectAtIndex:index];
    }
    
    return [(DBSideBarItem *) item childAtIndex:index];
    
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item {
    
    // root
    if (item == nil) {
        return [sidebarItems count] > 0;
    }

    return [(DBSideBarItem *) item numChildren ] > 0;
    
}




@end
