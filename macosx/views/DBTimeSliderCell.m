//
//  DBTimeSliderCell.m
//  deadbeef
//
//  Created by Carlos Nunes on 8/22/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

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
