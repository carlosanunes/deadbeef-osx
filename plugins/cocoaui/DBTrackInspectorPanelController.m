//
//  DBTrackPropertiesPanelController.m
//  deadbeef
//
//  Created by Carlos Nunes on 6/10/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "DBTrackInspectorPanelController.h"

static DBTrackInspectorPanelController * gController;

@implementation DBTrackInspectorPanelController

@synthesize trackProperties;
@synthesize trackMetadata;

@synthesize textCodec;
@synthesize textEmbeddedCuesheet;
@synthesize textDuration;
@synthesize textSubtrackIndex;
@synthesize textTags;
@synthesize textWhere;

+ (DBTrackInspectorPanelController *) sharedController {
    
    if (gController == nil) {
        
        gController = [[DBTrackInspectorPanelController alloc] initWithWindowNibName:@"TrackInspectorPanel"];
        
    }
    
    return gController;
    
}

- (void) awakeFromNib {
	
	knownKeys = [DBAppDelegate knownMetadataKeys];
    [self fillProperties];
}


- (void) fillProperties {

	trackProperties = [DBAppDelegate keyList:1];
	trackMetadata = [DBAppDelegate keyList:0];

	// fill default properties
	textWhere = [trackProperties valueForKey:@":URI"];
	textDuration = [trackProperties valueForKey:@":DURATION"];
	textSubtrackIndex = [trackProperties valueForKey:@":TRACKNUM"];
	textTags = [trackProperties valueForKey:@":TAGS"];
	textCodec = [trackProperties valueForKey:@":DECODER"];
	textEmbeddedCuesheet = [trackProperties valueForKey:@":HAS_EMBEDDED_CUESHEET"];
	
	// remove default properties from list
	[trackProperties removeObjectForKey:@":URI"];
	[trackProperties removeObjectForKey:@":DURATION"];
	[trackProperties removeObjectForKey:@":TRACKNUM"];
	[trackProperties removeObjectForKey:@":TAGS"];
	[trackProperties removeObjectForKey:@":DECODER"];
	[trackProperties removeObjectForKey:@":HAS_EMBEDDED_CUESHEET"];

    [trackMetadataDictionaryController setContent: trackMetadata];
    [trackPropertiesDictionaryController setContent:trackProperties];
    
}


-(void) dealloc {

	[trackProperties release];
	[trackMetadata release];
    [knownKeys release];
	
	[super dealloc];
}


- (IBAction) updateProperties : sender {

	[DBAppDelegate updateSelectedTracksMetadata: trackMetadata ];
	
	[self close];
	
}

@end
