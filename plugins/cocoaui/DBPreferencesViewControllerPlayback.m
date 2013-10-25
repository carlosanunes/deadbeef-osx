//
//  DBPreferencesViewControllerPlayback.m
//  deadbeef
//
//  Created by Carlos Nunes on 10/25/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "DBPreferencesViewControllerPlayback.h"


@implementation DBPreferencesViewControllerPlayback

- (id)init
{
    return [super initWithNibName:@"PreferencesViewPlayback" bundle:nil];
}

- (NSString *) identifier
{
	return @"PlaybackPreferences";
}

- (NSImage *)toolbarItemImage
{
    return [NSImage imageNamed:NSImageNameAdvanced];
}

- (NSString *)toolbarItemLabel
{
    return NSLocalizedString(@"Playback", @"Toolbar item name for the Playback preference pane");
}

@end
