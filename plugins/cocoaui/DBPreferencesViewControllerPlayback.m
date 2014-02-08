//
//  DBPreferencesViewControllerPlayback.m
//  deadbeef
//
//  Created by Carlos Nunes on 10/25/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "DBPreferencesViewControllerPlayback.h"


@implementation DBPreferencesViewControllerPlayback

@synthesize replaygainScale;
@synthesize resumePreviousSession;
@synthesize ignoreArchivesOnAddFolder;
@synthesize autoResetStopAfterCurrent;

@synthesize cliAddPlaylist;

@synthesize replaygainPreamp;
@synthesize globalPreamp;

- (id)init
{
    return [super initWithNibName:@"PreferencesViewPlayback" bundle:nil];
}

- (void) awakeFromNib {

    replaygainScale = [DBAppDelegate intConfiguration:@"pref_replaygain_scale" num:1];
    resumePreviousSession = [DBAppDelegate intConfiguration:@"resume_last_session" num:0];
    ignoreArchivesOnAddFolder = [DBAppDelegate intConfiguration:@"ignore_archives" num:1];
    autoResetStopAfterCurrent = [DBAppDelegate intConfiguration:@"playlist.stop_after_current_reset" num:0];
    
    replaygainPreamp = [DBAppDelegate intConfiguration:@"replaygain_preamp" num:0];
    globalPreamp = [DBAppDelegate intConfiguration:@"global_preamp" num:0];
    
    cliAddPlaylist = [DBAppDelegate stringConfiguration:@"cli_add_playlist_name" str:@"Default"];
    
}

- (NSString *) identifier
{
	return @"PlaybackPreferences";
}

- (NSImage *)toolbarItemImage
{
    return [NSImage imageNamed:NSImageNameAdvanced];
}

- (NSString *)toolbarItemLabel
{
    return NSLocalizedString(@"Playback", @"Toolbar item name for the Playback preference pane");
}

@end
