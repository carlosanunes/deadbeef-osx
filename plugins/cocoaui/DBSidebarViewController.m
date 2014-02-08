//
//  DBSidebarViewController.m
//  deadbeef
//
//  Created by Carlos Nunes on 24/12/13.
//
//

#import "DBSidebarViewController.h"

@implementation DBSidebarViewController 

@synthesize sidebarItems;

- (id) init {
    
    self = [super init];
    if (self) {
 
        sidebarItems = [[NSMutableArray array] retain];

        [sidebarItems addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithBool:YES], @"isSourceGroup",
                                 @"Library", @"name",
                                 [NSArray arrayWithObjects:
                                  [NSDictionary dictionaryWithObjectsAndKeys:
                                   @"Music", @"name",
                                   nil],
                                  [NSDictionary dictionaryWithObjectsAndKeys:
                                   @"Movies", @"name",
                                   nil],
                                  [NSDictionary dictionaryWithObjectsAndKeys:
                                   @"TV Shows", @"name",
                                   nil],
                                  [NSDictionary dictionaryWithObjectsAndKeys:
                                   @"Podcasts", @"name",
                                   nil],
                                  [NSDictionary dictionaryWithObjectsAndKeys:
                                   @"Radio", @"name",
                                   [NSArray arrayWithObjects:
                                    [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"CBC Vancouver", @"name",
                                     nil],
                                    [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"CBC Victoria", @"name",
                                     nil],
                                    nil], @"children",
                                   nil],
                                  nil], @"children",
                                 nil]];

    }
    
    return self;
}




@end
