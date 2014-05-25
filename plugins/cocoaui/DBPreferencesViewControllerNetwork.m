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

@synthesize proxyServerAddress;
@synthesize proxyServerPort;
@synthesize proxyServerUsername;
@synthesize proxyServerPassword;
@synthesize proxyServerUserAgent;

- (id)init
{

    return [super initWithNibName:@"PreferencesViewNetwork" bundle:nil];
}

- (void) awakeFromNib {
 
    NSUInteger index;
    NSString * currentProxyType = [DBAppDelegate stringConfiguration:@"network.proxy.type" str:@"HTTP"];
    proxyTypeList = [DBAppDelegate proxyTypeList];
    [proxyTypeListController setContent: proxyTypeList];
    
    index = [proxyTypeList indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        
        if ([currentProxyType isEqualToString: obj])
            return YES;
        return NO;
    }];
    
    [proxyTypeListController setSelectionIndex: index];
    
}

- (NSString *) proxyServerAddress {
    
    return [DBAppDelegate stringConfiguration:@"network.proxy.address" str:@""];
}

- (void) setProxyServerAddress:(NSString *)proxyServerAddress {
    
   return [DBAppDelegate setStringConfiguration:@"network.proxy.address" value:proxyServerAddress];
}

- (NSString *) proxyServerPort {
	
    return [DBAppDelegate stringConfiguration:@"network.proxy.port" str:@"8080"];
}

- (void) setProxyServerPort:(NSString *)proxyServerPort {
    
    return [DBAppDelegate setStringConfiguration:@"network.proxy.port" value:proxyServerPort];
}

- (NSString *) proxyServerUsername {
	
    return [DBAppDelegate stringConfiguration:@"network.proxy.username" str:@""];
}

- (void) setProxyServerUsername:(NSString *)proxyServerUsername {
    
    return [DBAppDelegate setStringConfiguration:@"network.proxy.username" value:proxyServerUsername];
}

- (NSString *) proxyServerPassword {
	
    return [DBAppDelegate stringConfiguration:@"network.proxy.password" str:@""];
}

- (void) setProxyServerPassword:(NSString *)proxyServerPassword {
    
    return [DBAppDelegate setStringConfiguration:@"network.proxy.password" value:proxyServerPassword];
}

- (NSString *) proxyServerUserAgent {
	
    return [DBAppDelegate stringConfiguration:@"network.http_user_agent" str:@"deadbeef"];
}

- (void) setProxyServerUserAgent:(NSString *)proxyServerUserAgent {
    
    return [DBAppDelegate setStringConfiguration:@"network.http_user_agent" value:proxyServerUserAgent];
}

- (BOOL) proxyServer {
	
    return [DBAppDelegate intConfiguration:@"proxy.server" num:0];
}

- (void) setProxyServer:(BOOL)proxyServer {
    
    return [DBAppDelegate setIntConfiguration:@"proxy.server" value:proxyServer];
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
