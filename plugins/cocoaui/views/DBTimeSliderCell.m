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

#import "DBTimeSliderCell.h"


@implementation DBTimeSliderCell


#define SLIDER_WIDTH 8


- (void)drawKnob:(NSRect)knobRect {

	// only draw knob if playing
//	if ([aDelegate isPlaying) {
		[super drawKnob: knobRect];
//	}
	
}

/*
- (void)drawBarInside:(NSRect)cellFrame flipped:(BOOL)flipped
{   
    NSRect slideRect = cellFrame;
    NSColor *backColor = [NSColor scrollBarColor];
    if ([(NSSlider*) [self controlView] isVertical] == YES)
    {
        slideRect.size.width = SLIDER_WIDTH;
        slideRect.origin.x += (cellFrame.size.width - SLIDER_WIDTH) * 0.5;
    } else {
        slideRect.size.height = SLIDER_WIDTH;
        slideRect.origin.y += (cellFrame.size.height - SLIDER_WIDTH) * 0.5;
    }
	
    NSBezierPath *bezierPath = [NSBezierPath bezierPathWithRoundedRect:slideRect xRadius:SLIDER_WIDTH * 0.5 yRadius:SLIDER_WIDTH * 0.5];  
    [backColor setStroke];
    [bezierPath stroke];
	
} */

- (NSRect)knobRectFlipped:(BOOL)flipped{
	
    return [super knobRectFlipped:flipped];
}

@end
