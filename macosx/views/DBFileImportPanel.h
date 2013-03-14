//
//  DBFileImportPanel.h
//  deadbeef
//
//  Created by Carlos Nunes on 1/18/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface DBFileImportPanel : NSPanel {

	IBOutlet NSTextField * currentFileTextField;
	IBOutlet NSButton * buttonAbort;
	
	BOOL abortPressedFlag;
}


- (void) setCurrentFile: (NSString *) currentFile;

// this method checks if the abort button was pressed. After it is called (assuming
// the button was pressed) until the button is pressed one more time, the method will return NO.
- (BOOL) abortPressed;

- (IBAction) abortPressed: (id) sender;


@end
