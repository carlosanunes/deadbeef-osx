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

@synthesize minReplaygainPreamp;
@synthesize minGlobalPreamp;
@synthesize maxReplaygainPreamp;
@synthesize maxGlobalPreamp;

- (id)init
{

    replaygainScale = [DBAppDelegate intConfiguration:@"pref_replaygain_scale" num:1];
    resumePreviousSession = [DBAppDelegate intConfiguration:@"resume_last_session" num:0];
    ignoreArchivesOnAddFolder = [DBAppDelegate intConfiguration:@"ignore_archives" num:1];
    autoResetStopAfterCurrent = [DBAppDelegate intConfiguration:@"playlist.stop_after_current_reset" num:0];
    
    replaygainPreamp = [DBAppDelegate intConfiguration:@"replaygain_preamp" num:0];
    globalPreamp = [DBAppDelegate intConfiguration:@"global_preamp" num:0];

    minReplaygainPreamp = -12;
    maxReplaygainPreamp = 12;
    minGlobalPreamp = -12;
    maxGlobalPreamp = 12;
    
    cliAddPlaylist = [DBAppDelegate stringConfiguration:@"cli_add_playlist_name" str:@"Default"];

    return [super initWithNibName:@"PreferencesViewPlayback" bundle:nil];
}

- (void) awakeFromNib {
    
    NSUInteger replaygainMode = [DBAppDelegate intConfiguration:@"replay_gain_mode" num:0];
    
    replaygainModeList = [DBAppDelegate replaygainModeList];
    [replaygainModeListController setContent: replaygainModeList];
    [replaygainModeListController setSelectionIndex: replaygainMode];
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
