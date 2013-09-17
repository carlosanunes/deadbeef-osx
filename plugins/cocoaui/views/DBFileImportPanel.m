//
//  DBFileImportPanel.m
//  deadbeef
//
//  Created by Carlos Nunes on 1/18/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "DBFileImportPanel.h"

@implementation DBFileImportPanel

- (void) setCurrentFile: (NSString *) currentFile {

	[currentFileTextField setStringValue: currentFile];
}

- (BOOL) abortPressed {

	if (abortPressedFlag) {
		abortPressedFlag = NO;
		return YES;
	}
	
	return NO;
}

- (IBAction) abortPressed: (id) sender {

	abortPressedFlag = YES;
}

@end
