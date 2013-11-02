//
//  DBPreferencesViewControllerNetwork.m
//  deadbeef
//
//  Created by Carlos Nunes on 10/25/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "DBPreferencesViewControllerNetwork.h"

@implementation DBPreferencesViewControllerNetwork

@synthesize proxyServer;

@synthesize	proxyServerAddress;
@synthesize	proxyServerPort;
@synthesize	proxyServerUsername;
@synthesize	proxyServerPassword;
@synthesize	proxyServerUserAgent;

- (id)init
{
    return [super initWithNibName:@"PreferencesViewNetwork" bundle:nil];
}

- (NSString *) identifier
{
	return @"NetworkPreferences";
}

- (NSImage *)toolbarItemImage
{
    return [NSImage imageNamed:NSImageNameAdvanced];
}

- (NSString *)toolbarItemLabel
{
    return NSLocalizedString(@"Network", @"Toolbar item name for the Network preference pane");
}

@end
