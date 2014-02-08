//
//  DBPreferencesViewControllerPlugins.m
//  deadbeef
//
//  Created by Carlos Nunes on 10/15/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

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
