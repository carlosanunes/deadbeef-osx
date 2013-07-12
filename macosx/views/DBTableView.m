/*
    DeaDBeeF Cocoa GUI
    Copyright (C) 2012 Carlos Nunes <carloslnunes@gmail.com>

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
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
