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

#import <Cocoa/Cocoa.h>

#import "DBAppDelegate.h"
#import "views/DBTableView.h"
#import "views/DBFileImportPanel.h"
#import "DBTrackInspectorPanelController.h"


@interface DBPlayListController : NSViewController <NSTableViewDelegate, NSTableViewDataSource> {
	
	IBOutlet DBTableView * playlistTable;
	IBOutlet DBFileImportPanel * fileImportPanel;
	
    @private
	NSMutableDictionary * metadataTypes;
    
    NSRect currentStatusCell;
	NSRect oldStatusCell;
}

- (void) reloadPlaylist;
- (void) updateStatusColumn;
- (IBAction) playSelectedItem: sender;
- (IBAction) deleteSelectedItems: sender;
- (IBAction) playlistClear: sender;
- (IBAction) invertSelection: sender;
- (IBAction) showTrackInfo: sender;

@end

