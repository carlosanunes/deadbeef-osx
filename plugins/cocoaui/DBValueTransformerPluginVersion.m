//
//  DBValueTransformerPluginName.m
//  deadbeef
//
//  Created by Carlos Nunes on 06/04/15.
//
//

#import "DBValueTransformerPluginVersion.h"

#include "deadbeef.h"
extern DB_functions_t *deadbeef;

@implementation DBValueTransformerPluginVersion

- (id) transformedValue:(id)value {
    
    DB_plugin_t * plugin = deadbeef->plug_get_for_id( [(NSString*) value UTF8String] );
    
    char s[20];
    snprintf (s, sizeof (s), "%d.%d", plugin -> version_major, plugin -> version_minor);
    
    return ([NSString stringWithUTF8String: s]);
}

@end
