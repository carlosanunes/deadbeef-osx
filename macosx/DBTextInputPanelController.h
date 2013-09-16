//
//  DBTextInputPanelController.h
//  deadbeef
//
//  Created by Carlos Nunes on 8/20/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface DBTextInputPanelController : NSWindowController <NSWindowDelegate, NSTextDelegate> {

	IBOutlet id btnOk;
	IBOutlet id btnCancel;
	
	IBOutlet id textInput;
}

- (void) setPanelTitle : (NSString *) title;

- (NSInteger) runModal;

- (NSString *) textInput;

- (IBAction) ok: (id)sender;

@end
