//
//  DBValueTransformerPluginName.m
//  deadbeef
//
//  Created by Carlos Nunes on 06/04/15.
//
//

#import "DBValueTransformerPluginName.h"

#include "deadbeef.h"
extern DB_functions_t *deadbeef;

@implementation DBValueTransformerPluginName

- (id) transformedValue:(id)value {
    
    DB_plugin_t * plugin = deadbeef->plug_get_for_id( [(NSString*) value UTF8String] );
    
    return ([NSString stringWithUTF8String: plugin->name]);
}

@end
