//
//  DBTrackPropertiesPanelController.h
//  deadbeef
//
//  Created by Carlos Nunes on 6/10/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DBAppDelegate.h"


@interface DBTrackInspectorPanelController : NSWindowController <NSWindowDelegate> {
	
    IBOutlet NSDictionaryController * trackPropertiesDictionaryController;
    IBOutlet NSDictionaryController * trackMetadataDictionaryController;

    @private

	NSMutableDictionary * knownKeys; // list to match keys with more apropriate descriptors
	NSMutableDictionary * trackProperties;
	NSMutableDictionary * trackMetadata;
    
    
	NSString * textWhere;
	NSString * textDuration;
	NSString * textSubtrackIndex;
	NSString * textTags;
	NSString * textCodec;
	NSString * textEmbeddedCuesheet;
	
}

@property (retain) NSMutableDictionary * trackProperties;
@property (retain) NSMutableDictionary * trackMetadata;

@property (retain) NSString * textWhere;
@property (retain) NSString * textDuration;
@property (retain) NSString * textSubtrackIndex;
@property (retain) NSString * textTags;
@property (retain) NSString * textCodec;
@property (retain) NSString * textEmbeddedCuesheet;

+ (DBTrackInspectorPanelController *) sharedController;

- (IBAction) updateProperties : sender;

- (void) fillProperties;

@end
