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

    
#import "DBTextInputPanelController.h"


@implementation DBTextInputPanelController

+ (DBTextInputPanelController *) initPanelWithTitle: (NSString *) title {
    
    DBTextInputPanelController * controller = [[DBTextInputPanelController alloc] initWithWindowNibName:@"TextInputPanel" ];
	[controller setPanelTitle: NSLocalizedString(title, "Panel title")];
    
    return controller;
}


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
