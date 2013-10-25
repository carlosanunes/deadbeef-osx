//
//  DBPreferencesViewControllerPlugins.h
//  deadbeef
//
//  Created by Carlos Nunes on 10/15/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MASPreferencesViewController.h"
#import "DBAppDelegate.h"
#import "DBScrollableTextPanelController.h"

@interface DBPreferencesViewControllerPlugins : NSViewController <MASPreferencesViewController> {

	NSDictionary * pluginList;
	
	IBOutlet NSDictionaryController * pluginListController;
}

- (IBAction) showCopyright: (id)sender;
- (IBAction) openWebsite : (id)sender;

@property (retain) NSDictionary * pluginList;


@end
