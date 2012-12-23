//
//  DBTableView.m
//  deadbeef
//
//  Created by Carlos Nunes on 5/1/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "DBTableView.h"


@implementation DBTableView


- (void)setEnterAction:(SEL)aSelector
{
	enterAction = aSelector;
}

- (void)setDeleteAction:(SEL)aSelector
{
	deleteAction = aSelector;
}

- (void)setReloadAction:(SEL)aSelector
{
	reloadAction = aSelector;
}

- (void) reloadData
{
	[_target performSelector:reloadAction];
	[super reloadData];
}


- (void)keyDown:(NSEvent *)event
{
	unichar  u = [[event charactersIgnoringModifiers]
				  characterAtIndex: 0];
	
	if ( u == NSEnterCharacter || u == NSCarriageReturnCharacter )
	{
		[_target performSelector:enterAction];
		return;
	}
	
	if ( u == NSDeleteCharacter )
	{
		[_target performSelector:deleteAction];
		return;
	}
	
	[super keyDown:event];
}

- (void)highlightSelectionInClipRect:(NSRect)clipRect
{
	// harcoded...
	NSColor *evenColor
	= [NSColor colorWithCalibratedRed:0.929
								green:0.953 blue:0.996 alpha:1.0];
	NSColor *oddColor  = [NSColor whiteColor];
	
	float rowHeight
	= [self rowHeight] + [self intercellSpacing].height;
	NSRect visibleRect = [self visibleRect];
	NSRect highlightRect;
	
	highlightRect.origin = NSMakePoint(
									   NSMinX(visibleRect),
									   (int)(NSMinY(clipRect)/rowHeight)*rowHeight);
	highlightRect.size = NSMakeSize(
									NSWidth(visibleRect),
									rowHeight - [self intercellSpacing].height);
	
	while (NSMinY(highlightRect) < NSMaxY(clipRect))
	{
		NSRect clippedHighlightRect
		= NSIntersectionRect(highlightRect, clipRect);
		int row = (int)
		((NSMinY(highlightRect)+rowHeight/2.0)/rowHeight);
		NSColor *rowColor
		= (0 == row % 2) ? evenColor : oddColor;
		[rowColor set];
		NSRectFill(clippedHighlightRect);
		highlightRect.origin.y += rowHeight;
	}
	
	[super highlightSelectionInClipRect: clipRect];
}


@end
