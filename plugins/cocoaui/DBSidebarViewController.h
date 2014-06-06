//
//  DBSidebarViewController.h
//  deadbeef
//
//  Created by Carlos Nunes on 24/12/13.
//
//

#import <Foundation/Foundation.h>
#import <DBAppDelegate.h>
#import "DBSideBarItem.h"

@interface DBSidebarViewController : NSViewController <NSOutlineViewDelegate> {
 
    IBOutlet NSTreeController * sidebarTreeController;
    IBOutlet NSOutlineView * sidebarView;
    
    NSMutableArray * sidebarItems;
    
}

@property (retain) NSMutableArray * sidebarItems;


- (void) updateItems;

@end
