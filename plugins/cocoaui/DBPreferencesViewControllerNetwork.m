//
//  DBPreferencesViewControllerNetwork.m
//  deadbeef
//
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
