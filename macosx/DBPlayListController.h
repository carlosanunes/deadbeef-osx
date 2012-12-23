//
//  PlayListController.h
//  deadbeef
//
//  Created by Carlos Nunes on 4/5/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "DBAppDelegate.h"
#import "views/DBTableView.h"


@interface DBPlayListController : NSViewController <NSTableViewDelegate, NSTableViewDataSource> {
	
@private
	IBOutlet DBTableView * playlistTable;
	IBOutlet id playListInfoTable;
}

- (IBAction) updatePlaylistInfo: sender;
- (IBAction) playSelectedItem: sender;
- (IBAction) deleteSelectedItems: sender;
- (IBAction) playlistClear: sender;
- (IBAction) invertSelection: sender;

@end

