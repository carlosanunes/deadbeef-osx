//
//  DBSideBarItem.h
//  deadbeef
//
//  Created by Carlos Nunes on 25/12/13.
//
//

#import <Foundation/Foundation.h>

@interface DBSideBarItem : NSObject {
    
    NSString * name;
    NSString * identifier;
    NSMutableArray * children;
    
}
    
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * identifier;
@property (nonatomic, copy) NSMutableArray * children;

@property (readonly) BOOL isLeaf;
@property (readonly) BOOL isHeader;

+ (DBSideBarItem *) itemWithName:(NSString *)name isHeader:(BOOL) header;
+ (DBSideBarItem *) itemWithName:(NSString *)name isHeader:(BOOL) header identifier:(NSString *) aIdentifier;

@end