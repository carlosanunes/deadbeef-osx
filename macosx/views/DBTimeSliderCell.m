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
