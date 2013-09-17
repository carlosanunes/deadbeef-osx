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
	NSString * text = nil;
	text = [trackProperties valueForKey:@":URI"];	
	if (text != nil)
		[labelWhere setStringValue: text];
	
	text = [trackProperties valueForKey:@":DURATION"];	
	if (text != nil)
		[labelDuration setStringValue: text ];
	
	text = [trackProperties valueForKey:@":TRACKNUM"];	
	if (text != nil)
		[labelSubtrackIndex setStringValue:text ];
	
	text = [trackProperties valueForKey:@":TAGS"];	
	if (text != nil)
		[labelTags setStringValue:text];
	
	text = [trackProperties valueForKey:@":DECODER"];	
	if (text != nil)
		[labelCodec setStringValue: text];
	
	text = [trackProperties valueForKey:@":HAS_EMBEDDED_CUESHEET"];	
	if (text != nil)
		[labelEmbeddedCuesheet setStringValue:text];
	
	// remove default properties from list
	[trackProperties removeObjectForKey:@":URI"];
	[trackProperties removeObjectForKey:@":DURATION"];
	[trackProperties removeObjectForKey:@":TRACKNUM"];
	[trackProperties removeObjectForKey:@":TAGS"];
	[trackProperties removeObjectForKey:@":DECODER"];
	[trackProperties removeObjectForKey:@":HAS_EMBEDDED_CUESHEET"];

	[trackMetadataController setContent: trackMetadata];
	[trackPropertiesController setContent:trackProperties];
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
