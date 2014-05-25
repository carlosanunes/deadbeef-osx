//
//  DBPreferencesViewControllerSound.m
//  deadbeef
//
//  Created by Carlos Nunes on 10/15/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "DBPreferencesViewControllerSound.h"


@implementation DBPreferencesViewControllerSound

@synthesize outputPluginList;


- (id)init
{
    return [super initWithNibName:@"PreferencesViewSound" bundle:nil];
}

- (void) awakeFromNib {
	
    NSString * currentPlugin = [DBAppDelegate stringConfiguration:@"output_plugin" str:@""];
    NSUInteger i;
    
	outputPluginList = [DBAppDelegate outputPluginList];
	[outputPluginListController setContent: outputPluginList];
    
    i = [outputPluginList indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        if ([currentPlugin isEqualToString: obj])
            return YES;
        return NO;
    }];
    
    [outputPluginListController setSelectionIndex:i];
}

- (NSString *) identifier
{
	return @"SoundPreferences";
}

- (NSImage *)toolbarItemImage
{
    return [NSImage imageNamed:NSImageNameAdvanced];
}

- (NSString *)toolbarItemLabel
{
    return NSLocalizedString(@"Sound", @"Toolbar item name for the Sound preference pane");
}

- (BOOL) eightToSixteen {
    
    return [DBAppDelegate intConfiguration:@"streamer.8_to_16" num:1];
}

- (void) setEightToSixteen:(BOOL)eightToSixteen {
    
    [DBAppDelegate setIntConfiguration:@"streamer.8_to_16" value:eightToSixteen];
    
    return;
}

- (BOOL) sixteenToTwentyFour {
    
     return [DBAppDelegate intConfiguration:@"streamer.16_to_24" num:0];
}

- (void) setSixteenToTwentyFour:(BOOL)sixteenToTwentyFour {
    
    return [DBAppDelegate setIntConfiguration:@"streamer.16_to_24" value:sixteenToTwentyFour];
}

-(void) dealloc {
	
	[outputPluginList release];
	[super dealloc];
}

@end
