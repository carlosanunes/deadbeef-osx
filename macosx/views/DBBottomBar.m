#import "DBBottomBar.h"

@implementation DBBottomBar


- (void)awakeFromNib
{
	[[self window] setContentBorderThickness:24	forEdge:NSMinYEdge];
}


- (NSRect)bounds
{
	return NSMakeRect(-10000,-10000,0, 0);
}


@end
