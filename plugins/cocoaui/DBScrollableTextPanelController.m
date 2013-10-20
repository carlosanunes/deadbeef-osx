//
//  DBScrollableTextPanel.m
//  deadbeef
//
//  Created by Carlos Nunes on 10/19/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "DBScrollableTextPanelController.h"


@implementation DBScrollableTextPanelController


- (NSInteger) runModal {
	
	return [NSApp runModalForWindow: [self window] ];	
}

- (void) setPanelTitle : (NSString *) title {
	
	[[self window] setTitle: title];
	
}

- (void) setText : (NSString *) text {

	[textContainer setString: text];
}

- (BOOL) windowShouldClose:(id)sender {
	
	[NSApp stopModalWithCode:NSOKButton];	
	return YES;
}


@end
