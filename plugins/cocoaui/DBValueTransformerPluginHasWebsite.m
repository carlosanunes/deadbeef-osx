//
//  DBValueTransformerPluginWebsite.m
//  deadbeef
//
//  Created by Carlos Nunes on 10/19/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "DBValueTransformerPluginWebsite.h"


@implementation DBValueTransformerPluginHasWebsite

+ (Class)transformedValueClass
{
	return [NSNumber class];
}


- (id) transformedValue:(id)value {

	return (id) ( [value objectAtIndex:PLUGIN_DATA_WEBSITE_POS] == nil ?
				 [NSNumber numberWithBool:NO] : [NSNumber numberWithBool:YES] );
}


@end
