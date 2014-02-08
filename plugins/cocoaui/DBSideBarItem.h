//
//  DBSideBarItem.h
//  deadbeef
//
//  Created by Carlos Nunes on 25/12/13.
//
//

#import <Foundation/Foundation.h>

@interface DBSideBarItem : NSObject

@property (nonatomic, strong) NSString * name;
@property (nonatomic, assign) BOOL isGroup;
@property (nonatomic, strong) NSMutableArray *children;

@end
