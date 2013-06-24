//
//  DBTrackPropertiesPanelController.h
//  deadbeef
//
//  Created by Carlos Nunes on 6/10/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DBAppDelegate.h"


@interface DBTrackPropertiesPanelController : NSWindowController <NSWindowDelegate> {
	
	NSMutableDictionary * knownKeys; // list to match keys with more apropriate descriptors
	NSMutableDictionary * trackProperties;
	NSMutableDictionary * trackMetadata;
	
	IBOutlet NSDictionaryController * trackPropertiesController;
	IBOutlet NSDictionaryController * trackMetadataController;
	
	IBOutlet NSTableView * metadataList;
	IBOutlet NSTableView * propertyList;
	
	IBOutlet NSTextField * labelWhere;
	IBOutlet NSTextField * labelDuration;
	IBOutlet NSTextField * labelSubtrackIndex;
	IBOutlet NSTextField * labelTags;
	IBOutlet NSTextField * labelCodec;
	IBOutlet NSTextField * labelEmbeddedCuesheet;
	
}

@property (retain) NSMutableDictionary * trackProperties;
@property (retain) NSMutableDictionary * trackMetadata;

- (IBAction) updateProperties : sender;

- (void) fillProperties;

@end
