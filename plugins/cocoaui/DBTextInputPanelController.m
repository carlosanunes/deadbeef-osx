//
//  DBTextInputPanelController.m
//  deadbeef
//
//  Created by Carlos Nunes on 8/20/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "DBTextInputPanelController.h"


@implementation DBTextInputPanelController

- (void) setPanelTitle : (NSString *) title {

	[[self window] setTitle: title];
	
}

// to enable/disable the ok button
- (void)controlTextDidChange:(NSNotification *)aNotification {

	if ([[textInput stringValue] length] == 0)
		[btnOk setEnabled:NO];
	else
		[btnOk setEnabled: YES];
}

- (NSInteger) runModal {

	return [NSApp runModalForWindow: [self window] ];	
}

- (IBAction) ok: (id)sender {
	
	[NSApp stopModalWithCode:NSOKButton];
	[self close];
}

- (BOOL) windowShouldClose:(id)sender {

	[NSApp stopModalWithCode:NSCancelButton];	
	return YES;
}


- (NSString *) textInput {

	return [textInput stringValue];
}

@end
