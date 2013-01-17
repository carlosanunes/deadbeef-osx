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

#import <Cocoa/Cocoa.h>

#import "DBAppDelegate.h"
#import "views/DBTableView.h"


@interface DBPlayListController : NSViewController <NSTableViewDelegate, NSTableViewDataSource> {
	
@private
	IBOutlet DBTableView * playlistTable;
	IBOutlet NSWindow * mainWindow;
	IBOutlet id playListInfoTable;
	IBOutlet DBFileImportPanelController * fileImportPanelController;
}

- (IBAction) updatePlaylistInfo: sender;
- (IBAction) playSelectedItem: sender;
- (IBAction) deleteSelectedItems: sender;
- (IBAction) playlistClear: sender;
- (IBAction) invertSelection: sender;

@end

