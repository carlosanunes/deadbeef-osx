//
//  DBPreferencesViewControllerPlayback.h
//  deadbeef
//
//  Created by Carlos Nunes on 10/25/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MASPreferencesViewController.h"
#import "DBAppDelegate.h"

@interface DBPreferencesViewControllerPlayback : NSViewController <MASPreferencesViewController> {

    BOOL replaygainScale;
    BOOL resumePreviousSession;
    BOOL ignoreArchivesOnAddFolder;
    BOOL autoResetStopAfterCurrent;

    NSInteger replaygainPreamp;
    NSInteger minReplaygainPreamp;
    NSInteger maxReplaygainPreamp;

    NSInteger globalPreamp;
    NSInteger minGlobalPreamp;
    NSInteger maxGlobalPreamp;
    
    NSString * cliAddPlaylist; // name of default playlist on which to add file added through the cli
    
    NSArray * replaygainModeList;
    
    IBOutlet NSArrayController * replaygainModeListController;
}

@property BOOL replaygainScale;
@property BOOL resumePreviousSession;
@property BOOL ignoreArchivesOnAddFolder;
@property BOOL autoResetStopAfterCurrent;

@property (retain) NSString * cliAddPlaylist;

@property NSInteger replaygainPreamp;
@property NSInteger globalPreamp;

@property NSInteger minReplaygainPreamp;
@property NSInteger maxReplaygainPreamp;

@property NSInteger minGlobalPreamp;
@property NSInteger maxGlobalPreamp;

@end
