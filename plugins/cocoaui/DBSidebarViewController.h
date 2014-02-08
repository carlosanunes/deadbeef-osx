//
//  DBSidebarViewController.h
//  deadbeef
//
//  Created by Carlos Nunes on 24/12/13.
//
//

#import <Foundation/Foundation.h>
#import <DBSideBarItem.h>

@interface DBSidebarViewController : NSViewController <NSOutlineViewDelegate> {

	IBOutlet NSTreeController * itemListController;
    
    NSMutableArray * sidebarItems;

}

@property (retain) NSMutableArray * sidebarItems;


@end
