//
//  DBSidebarViewController.m
//  deadbeef
//
//  Created by Carlos Nunes on 24/12/13.
//
//

#import "DBSidebarViewController.h"

@implementation DBSidebarViewController 


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
    NSInteger row = [mOutlineView selectedRow];
    NSTreeNode * item = (NSTreeNode *) [mOutlineView itemAtRow: row];
    DBSideBarItem * sidebarItem = (DBSideBarItem *) item.representedObject;
    
    if ( [[sidebarItem identifier] isEqualToString:@"playlist"] ) {
        // figuring out the correct index
        NSTreeNode * parentNode = [item parentNode];
        NSInteger parentRow = [mOutlineView rowForItem: parentNode];
        parentRow++;
        
        [DBAppDelegate setCurrentPlaylist: row - parentRow ];
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
