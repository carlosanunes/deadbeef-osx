//
//  DBPreferencesViewControllerNetwork.h
//  deadbeef
//
//  Created by Carlos Nunes on 10/25/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MASPreferencesViewController.h"

@interface DBPreferencesViewControllerNetwork : NSViewController <MASPreferencesViewController> {

	IBOutlet id checkBoxProxyEnabled;
	IBOutlet id textInputServerAddress;
	IBOutlet id textInputServerPort;
	IBOutlet id textInputProxyType;
	IBOutlet id textInputProxyUsername;
	IBOutlet id textInputProxyPassword;
	IBOutlet id textInputProxyUserAgent;
	
	BOOL		proxyServer;
	NSString *	proxyServerAddress;
	NSString *	proxyServerPort;
	NSString *	proxyServerUsername;
	NSString *	proxyServerPassword;
	NSString *	proxyServerUserAgent;
}

@property BOOL proxyServer;

@property (retain) NSString * proxyServerAddress;
@property (retain) NSString * proxyServerPort;
@property (retain) NSString * proxyServerUsername;
@property (retain) NSString * proxyServerPassword;
@property (retain) NSString * proxyServerUserAgent;


@end
