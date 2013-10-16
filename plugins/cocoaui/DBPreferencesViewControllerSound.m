//
//  DBPreferencesViewControllerSound.m
//  deadbeef
//
//  Created by Carlos Nunes on 10/15/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "DBPreferencesViewControllerSound.h"


@implementation DBPreferencesViewControllerSound

- (id)init
{
    return [super initWithNibName:@"PreferencesViewSound" bundle:nil];
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


@end
