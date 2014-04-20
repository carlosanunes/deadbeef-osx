//
//  DBPreferencesViewControllerNetwork.h
//  deadbeef
//
//  Created by Carlos Nunes on 10/25/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MASPreferencesViewController.h"
#import "DBAppDelegate.h"

@interface DBPreferencesViewControllerNetwork : NSViewController <MASPreferencesViewController> {

    BOOL proxyServer;
    
    NSString * proxyServerAddress;
    NSString * proxyServerPort;
    NSString * proxyServerUsername;
    NSString * proxyServerPassword;
    NSString * proxyServerUserAgent;
    
    NSArray * proxyTypeList;
    
    IBOutlet NSArrayController * proxyTypeListController;
    

}

@property BOOL proxyServer;

@property (retain) NSString * proxyServerAddress;
@property (retain) NSString * proxyServerPort;
@property (retain) NSString * proxyServerUsername;
@property (retain) NSString * proxyServerPassword;
@property (retain) NSString * proxyServerUserAgent;


@end
