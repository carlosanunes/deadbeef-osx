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
    
#import <Cocoa/Cocoa.h>
#import "MASPreferencesViewController.h"
#import "DBAppDelegate.h"

@interface DBPreferencesViewControllerPlayback : NSViewController <MASPreferencesViewController> {

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

@property (nonatomic) NSInteger minReplaygainPreamp;
@property (nonatomic) NSInteger maxReplaygainPreamp;

@property (nonatomic) NSInteger minGlobalPreamp;
@property (nonatomic) NSInteger maxGlobalPreamp;

@end
