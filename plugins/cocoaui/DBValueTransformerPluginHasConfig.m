//
//  DBValueTransformerPluginName.m
//  deadbeef
//
//  Created by Carlos Nunes on 06/04/15.
//
//

#import "DBValueTransformerPluginHasConfig.h"

#include "deadbeef.h"
extern DB_functions_t *deadbeef;

@implementation DBValueTransformerPluginHasConfig

+ (Class)transformedValueClass
{
    return [NSNumber class];
}

- (id) transformedValue:(id)value {
    
    DB_plugin_t * plugin = deadbeef->plug_get_for_id( [(NSString*) value UTF8String] );
    
    return (id) ( plugin->configdialog ? [NSNumber numberWithBool:YES] : [NSNumber numberWithBool:NO] ) ;
}

@end
