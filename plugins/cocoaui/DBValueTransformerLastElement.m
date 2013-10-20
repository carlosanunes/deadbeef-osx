//
//  DBValueTransformerLastElement.m
//  deadbeef
//
//  Created by Carlos Nunes on 10/19/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "DBValueTransformerLastElement.h"


@implementation DBValueTransformerLastElement

- (id) transformedValue:(id)value {
	
	return [value lastObject];
}


@end
