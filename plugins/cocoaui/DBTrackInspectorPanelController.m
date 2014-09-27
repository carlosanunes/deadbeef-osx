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
