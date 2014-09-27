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

#import "DBPreferencesViewControllerPlugins.h"


@implementation DBPreferencesViewControllerPlugins

@synthesize pluginList;

- (void) awakeFromNib {
	
	pluginList = [DBAppDelegate pluginList];
	[pluginListController setContent: pluginList];
}

- (id)init
{
    return [super initWithNibName:@"PreferencesViewPlugins" bundle:nil];
}

- (NSString *) identifier
{
	return @"PluginsPreferences";
}

- (NSImage *)toolbarItemImage
{
    return [NSImage imageNamed:NSImageNameAdvanced];
}

- (NSString *)toolbarItemLabel
{
    return NSLocalizedString(@"Plugins", @"Toolbar item name for the Plugins preference pane");
}


- (IBAction) showCopyright: (id)sender {

	DBScrollableTextPanelController * controller = [[DBScrollableTextPanelController alloc] initWithWindowNibName:@"ScrollableTextPanel" ];
	[controller setPanelTitle: NSLocalizedString(@"Copyright", "Copyright panel title")];

	NSArray * array = [pluginListController valueForKeyPath:@"selection.value"];
	[controller setText: [array objectAtIndex: PLUGIN_DATA_COPYRIGHT_POS ]  ];
	
	[controller runModal];
    [controller release];
}

- (IBAction) openWebsite : (id)sender {

	NSArray * array = [pluginListController valueForKeyPath:@"selection.value"];
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:[array objectAtIndex: PLUGIN_DATA_WEBSITE_POS]]];
}


-(void) dealloc {
	
	[pluginList release];
	[super dealloc];
}


@end
