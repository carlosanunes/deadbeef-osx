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

    
#import "DBSplitViewController.h"

#define kSnapToDelta			8.0
#define	kMinSourceListWidth		110.0
#define kSnapSourceListWidth	250.0
#define kMinContentWidth		150.0

@implementation DBSplitViewController

- (void) splitView:(NSSplitView*) splitView resizeSubviewsWithOldSize:(NSSize) oldSize
{

		CGFloat dividerPos = NSWidth([[[splitView subviews] objectAtIndex:0] frame]);
		CGFloat width = NSWidth([splitView frame]);
        
		if (dividerPos < kMinSourceListWidth)
			dividerPos = kMinSourceListWidth;
		if (width - dividerPos < kMinContentWidth + [splitView dividerThickness])
			dividerPos = width - (kMinContentWidth + [splitView dividerThickness]);
		
		[splitView adjustSubviews];
		[splitView setPosition:dividerPos ofDividerAtIndex:0];

}

- (CGFloat) splitView:(NSSplitView*) splitView constrainSplitPosition:(CGFloat) proposedPosition ofSubviewAt:(NSInteger) dividerIndex
{

		CGFloat width = NSWidth([splitView frame]);
		
		if (ABS(kSnapSourceListWidth - proposedPosition) <= kSnapToDelta)
			proposedPosition = kSnapSourceListWidth;
		if (proposedPosition < kMinSourceListWidth)
			proposedPosition = kMinSourceListWidth;
		if (width - proposedPosition < kMinContentWidth + [splitView dividerThickness])
			proposedPosition = width - (kMinContentWidth + [splitView dividerThickness]);
	
	return proposedPosition;
}

@end
