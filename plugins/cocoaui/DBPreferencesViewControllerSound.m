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

#import "DBPreferencesViewControllerSound.h"


@implementation DBPreferencesViewControllerSound

@synthesize outputPluginList;


- (id)init
{
    return [super initWithNibName:@"PreferencesViewSound" bundle:nil];
}

- (void) awakeFromNib {
	
    NSString * currentPlugin = [DBAppDelegate stringConfiguration:@"output_plugin" str:@""];
    NSUInteger i;
    
	outputPluginList = [DBAppDelegate outputPluginList];
	[outputPluginListController setContent: outputPluginList];
    
    i = [outputPluginList indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        if ([currentPlugin isEqualToString: obj])
            return YES;
        return NO;
    }];
    
    [outputPluginListController setSelectionIndex:i];
}

- (NSString *) identifier
{
	return @"SoundPreferences";
}

- (NSImage *)toolbarItemImage
{
    NSImage * img = [[NSWorkspace sharedWorkspace] iconForFileType:NSFileTypeForHFSTypeCode(kToolbarMusicFolderIcon)];
    
    return img;
}

- (NSString *)toolbarItemLabel
{
    return NSLocalizedString(@"Sound", @"Toolbar item name for the Sound preference pane");
}

- (BOOL) eightToSixteen {
    
    return [DBAppDelegate intConfiguration:@"streamer.8_to_16" num:1];
}

- (void) setEightToSixteen:(BOOL)eightToSixteen {
    
    [DBAppDelegate setIntConfiguration:@"streamer.8_to_16" value:eightToSixteen];
    
    return;
}

- (BOOL) sixteenToTwentyFour {
    
     return [DBAppDelegate intConfiguration:@"streamer.16_to_24" num:0];
}

- (void) setSixteenToTwentyFour:(BOOL)sixteenToTwentyFour {
    
    return [DBAppDelegate setIntConfiguration:@"streamer.16_to_24" value:sixteenToTwentyFour];
}

-(void) dealloc {
	
	[outputPluginList release];
	[super dealloc];
}

@end
