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

// change default behaviour of calling a menu, so that it also selects the row
- (NSMenu *) menuForEvent:(NSEvent *)event {

	NSInteger row = [self rowAtPoint: [self convertPoint: [event locationInWindow] fromView: nil]];
	NSIndexSet * selectedRows = nil;
	if (row != -1)
	{
        if (![self isRowSelected: row]) {
			// preserve behaviour of selection validation
			selectedRows = [_delegate tableView:self selectionIndexesForProposedSelection: [NSIndexSet indexSetWithIndex: row]];  
            [self selectRowIndexes: selectedRows byExtendingSelection: NO];
		}
		return [super menu];
	}

	return nil;
}

@end
