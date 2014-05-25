//
//  DBPreferencesViewControllerSound.h
//  deadbeef
//
//  Created by Carlos Nunes on 10/15/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MASPreferencesViewController.h"
#import "DBAppDelegate.h"

@interface DBPreferencesViewControllerSound : NSViewController <MASPreferencesViewController> {

    NSArray * outputPluginList;
    
    IBOutlet NSArrayController * outputPluginListController;
}

@property (retain) NSArray * outputPluginList;
@property BOOL eightToSixteen;
@property BOOL sixteenToTwentyFour;

@end
