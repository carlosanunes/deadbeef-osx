//
//  DBSideBarItem.m
//  deadbeef
//
//  Created by Carlos Nunes on 25/12/13.
//
//

#import "DBSideBarItem.h"

@implementation DBSideBarItem

@synthesize isHeader;
@synthesize name;
@synthesize children;
@synthesize identifier;

+ (DBSideBarItem *) itemWithName:(NSString *)name  isHeader:(BOOL) header {

    DBSideBarItem * item = [[[DBSideBarItem alloc] init] autorelease];
    
    [item setName:name];
    item -> _flagHeader = header;

    return item;
}

+ (DBSideBarItem *) itemWithName:(NSString *)name isHeader:(BOOL) header identifier:(NSString *) aIdentifier {
    DBSideBarItem * item = [[[DBSideBarItem alloc] init] autorelease];
    
    [item setName:name];
    [item setIdentifier:aIdentifier];
    item -> _flagHeader = header;
    
    return item;
    
}


- (BOOL) isLeaf{
    
    if ([self isHeader])
        return NO;
    
    return [children count] == 0;
}

- (BOOL) isHeader {

    return _flagHeader;
}

- (void)dealloc
{
    [name release];
    [children release];
    
    [super dealloc];
}

- (void)finalize
{
    name = nil;
    children = nil;
    
    [super finalize];
}


@end