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

    return [super initWithNibName:@"PreferencesViewPlayback" bundle:nil];
}

- (void) awakeFromNib {
    
    NSUInteger replaygainMode = [DBAppDelegate intConfiguration:@"replay_gain_mode" num:0];
    
    replaygainModeList = [DBAppDelegate replaygainModeList];
    [replaygainModeListController setContent: replaygainModeList];
    [replaygainModeListController setSelectionIndex: replaygainMode];
}


- (BOOL) replaygainScale {
    
	return [DBAppDelegate intConfiguration:@"pref_replaygain_scale" num:1];
}

- (void) setReplaygainScale:(BOOL)replaygainScale {
    
    return [DBAppDelegate setIntConfiguration:@"pref_replaygain_scale" value:replaygainScale];
}

- (BOOL) resumePreviousSession {
    
    return [DBAppDelegate intConfiguration:@"resume_last_session" num:0];
}

- (void) setResumePreviousSession:(BOOL)resumePreviousSession {
    
    return [DBAppDelegate setIntConfiguration:@"resume_last_session" value:resumePreviousSession];
}

- (BOOL) ignoreArchivesOnAddFolder {
    
	return [DBAppDelegate intConfiguration:@"ignore_archives" num:1];
}

- (void) setIgnoreArchivesOnAddFolder:(BOOL)ignoreArchivesOnAddFolder {
    
    return [DBAppDelegate setIntConfiguration:@"ignore_archives" value:ignoreArchivesOnAddFolder];
}

- (BOOL) autoResetStopAfterCurrent {

    return [DBAppDelegate intConfiguration:@"playlist.stop_after_current_reset" num:0];
}

- (void) setAutoResetStopAfterCurrent:(BOOL)autoResetStopAfterCurrent {
    
    return [DBAppDelegate setIntConfiguration:@"playlist.stop_after_current_reset" value: autoResetStopAfterCurrent];
}

- (NSString *) cliAddPlaylist {

    return [DBAppDelegate stringConfiguration:@"cli_add_playlist_name" str:@"Default"];
	
}

- (void) setCliAddPlaylist:(NSString *)cliAddPlaylist {
    
    return [DBAppDelegate setStringConfiguration:@"cli_add_playlist_name" value:cliAddPlaylist];
}

- (NSInteger) replaygainPreamp {
    
    return [DBAppDelegate intConfiguration:@"replaygain_preamp" num:0];
}

- (void) setReplaygainPreamp:(NSInteger)replaygainPreamp {
    
    return [DBAppDelegate setIntConfiguration:@"replaygain_preamp" value:replaygainPreamp];
}

- (NSInteger) globalPreamp {

    return [DBAppDelegate intConfiguration:@"global_preamp" num:0];
}

- (void) setGlobalPreamp:(NSInteger)globalPreamp {
    
    return [DBAppDelegate setIntConfiguration:@"global_preamp" value:globalPreamp];
}

- (NSInteger) minReplaygainPreamp {
	
    return -12;
}

- (NSInteger) maxReplaygainPreamp {
    
    return 12;
}

- (NSInteger) minGlobalPreamp {
    
    return -12;
}

- (NSInteger) maxGlobalPreamp {
    
    return 12;
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
