//
//  DBTableView.h
//  deadbeef
//
//  Created by Carlos Nunes on 5/1/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface DBTableView : NSTableView {

	SEL enterAction;
	SEL deleteAction;
	SEL reloadAction;
	
}

- (void)setEnterAction:(SEL)aSelector;

- (void)setDeleteAction:(SEL)aSelector;

- (void) setReloadAction:(SEL)aSelector;

@end
