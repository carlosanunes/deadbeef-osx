//
//  DBValueTransformerFirstElement.m
//  deadbeef
//
//  Created by Carlos Nunes on 10/19/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "DBValueTransformerFirstElement.h"


@implementation DBValueTransformerFirstElement

- (id) transformedValue:(id)value {

	return [value objectAtIndex:0];
}

@end
