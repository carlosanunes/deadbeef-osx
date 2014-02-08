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

@synthesize eightToSixteen;
@synthesize sixteentToTwentyFour;

- (id)init
{
    return [super initWithNibName:@"PreferencesViewSound" bundle:nil];
}

- (void) awakeFromNib {
	
	outputPluginList = [DBAppDelegate outputPluginList];
    eightToSixteen = [DBAppDelegate intConfiguration:@"streamer.8_to_16" num:1];
    sixteentToTwentyFour = [DBAppDelegate intConfiguration:@"streamer.16_to_24" num:0];
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


-(void) dealloc {
	
	[outputPluginList release];
	[super dealloc];
}

@end
