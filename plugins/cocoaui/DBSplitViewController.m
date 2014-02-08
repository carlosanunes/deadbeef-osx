//
//  DBSplitViewController.m
//  deadbeef
//
//  Created by Carlos Nunes on 23/12/13.
//
//

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
