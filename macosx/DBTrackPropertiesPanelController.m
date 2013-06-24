//
//  DBTrackPropertiesPanelController.m
//  deadbeef
//
//  Created by Carlos Nunes on 6/10/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "DBTrackPropertiesPanelController.h"


@implementation DBTrackPropertiesPanelController

@synthesize trackProperties;
@synthesize trackMetadata;

- (void) awakeFromNib {
	
	knownKeys = [DBAppDelegate knownMetadataKeys];
}


- (void) fillProperties {

	trackProperties = [DBAppDelegate keyList:1];
	trackMetadata = [DBAppDelegate keyList:0];

	// fill default properties
	[labelWhere setStringValue: [trackProperties valueForKey:@":URI"]];
	[labelDuration setStringValue: [trackProperties valueForKey:@":DURATION"] ];
	[labelSubtrackIndex setStringValue:[trackProperties valueForKey:@":TRACKNUM"] ];
	[labelTags setStringValue:[trackProperties valueForKey:@":TAGS"]];
	[labelCodec setStringValue:[trackProperties valueForKey:@":DECODER"]];
	[labelEmbeddedCuesheet setStringValue:[trackProperties valueForKey:@":HAS_EMBEDDED_CUESHEET"]];
	
	// remove default properties from list
	[trackProperties removeObjectForKey:@":URI"];
	[trackProperties removeObjectForKey:@":DURATION"];
	[trackProperties removeObjectForKey:@":TRACKNUM"];
	[trackProperties removeObjectForKey:@":TAGS"];
	[trackProperties removeObjectForKey:@":DECODER"];
	[trackProperties removeObjectForKey:@":HAS_EMBEDDED_CUESHEET"];

	[trackPropertiesController bind:NSContentDictionaryBinding toObject:self withKeyPath:@"trackProperties" options:nil];
	[trackMetadataController bind:NSContentDictionaryBinding toObject:self withKeyPath:@"trackMetadata" options:nil];	
}


-(void) dealloc {

	[trackProperties release];
	[trackMetadata release];
	
	[super dealloc];
}


- (IBAction) updateProperties : sender {

	[self close];
}

@end
