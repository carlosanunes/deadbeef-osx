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

    
#import "DBPreferencesViewControllerPlayback.h"


@implementation DBPreferencesViewControllerPlayback

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
    return [NSImage imageNamed:NSImageNamePreferencesGeneral];
}

- (NSString *)toolbarItemLabel
{
    return NSLocalizedString(@"Playback", @"Toolbar item name for the Playback preference pane");
}

@end
