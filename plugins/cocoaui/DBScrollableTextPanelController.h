//
//  DBScrollableTextPanel.h
//  deadbeef
//
//  Created by Carlos Nunes on 10/19/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface DBScrollableTextPanelController : NSWindowController <NSWindowDelegate> {

	IBOutlet id textContainer;
	
}

- (NSInteger) runModal;

- (void) setPanelTitle : (NSString *) title;
- (void) setText : (NSString *) text;

@end
