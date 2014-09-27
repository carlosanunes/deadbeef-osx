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

@synthesize sidebarItems;

- (void) awakeFromNib {
    
    sidebarItems = [[NSMutableArray array] retain];
    
    DBSideBarItem * playlistItem = [DBSideBarItem itemWithName:@"PLAYLISTS" isHeader:YES identifier:@"playlistGroup"];
    NSMutableArray * playlists = [NSMutableArray arrayWithCapacity:1];
    
    for (NSDictionary * object in [DBAppDelegate availablePlaylists]) {
        
        [playlists addObject:[DBSideBarItem itemWithName:[object valueForKey:@"name"] isHeader:NO identifier:@"playlist" ] ];
    }
    
    [playlistItem setChildren:playlists];
    
    [sidebarItems addObject: playlistItem];
    [sidebarTreeController setContent: sidebarItems];
    
    [sidebarView reloadData];
    [sidebarView expandItem:nil expandChildren:YES];
    
    [sidebarView selectRowIndexes: [NSIndexSet indexSetWithIndex: [DBAppDelegate intConfiguration:@"playlist.current" num:0] + 1 ] byExtendingSelection:NO ];

    
    
    NSNotificationCenter * notificationCenter = [NSNotificationCenter defaultCenter];
    
    [notificationCenter addObserver: self
                           selector: @selector(updateItems)
                               name: @"DB_EventPlaylistSwitched"
                             object: nil];
    
    [notificationCenter addObserver: self
                           selector: @selector(updateItems)
                               name: @"DB_EventPlaylistChanged"
                             object: nil];
    
}

- (void) updateItems {

// TODO
    
    
}

#pragma mark - Helpers

- (BOOL) isItemHeader:(id)item{
    
    if([item isKindOfClass:[NSTreeNode class]]){
        if ([((NSTreeNode *)item).representedObject respondsToSelector:@selector(isHeader)]) {
            return [((NSTreeNode *)item).representedObject performSelector:@selector(isHeader)];
        }
    }
    
    return NO;
}


#pragma mark - NSOutlineViewDelegate

- (void) outlineViewSelectionDidChange:(NSNotification *)notification {
    
    NSOutlineView * mOutlineView = [notification object];
    NSInteger rowNumber = [mOutlineView selectedRow];
    NSTreeNode * item = (NSTreeNode *) [mOutlineView itemAtRow: rowNumber];
    DBSideBarItem * sidebarItem = (DBSideBarItem *) item.representedObject;
    
    if ( [[sidebarItem identifier] isEqualToString:@"playlist"] ) {
        // figuring out the correct index
        NSTreeNode * parentNode = [item parentNode];
        NSInteger parentRowNumber = [mOutlineView rowForItem: parentNode];
        parentRowNumber++;
        
        [DBAppDelegate setCurrentPlaylist: rowNumber - parentRowNumber ];
    }
    
}


- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item{
    
    return ![self isItemHeader:item];
}

- (NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item {
    
    if ([self isItemHeader:item]) {
        return [outlineView makeViewWithIdentifier:@"HeaderCell" owner:self];
    } else {
        return [outlineView makeViewWithIdentifier:@"DataCell" owner:self];
    }
    
    return nil;
}


- (BOOL)outlineView:(NSOutlineView *)outlineView isGroupItem:(id)item{
    // This converts a group to a header which influences its style

    return [self isItemHeader:item];
}


@end
