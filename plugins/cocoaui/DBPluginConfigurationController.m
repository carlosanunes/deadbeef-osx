//
//  DBPluginConfigurationController.m
//  deadbeef
//
//  Created by Carlos Nunes on 12/04/15.
//
//

#import "DBPluginConfigurationController.h"

#include "../libparser/parser.h"
#include "deadbeef.h"
extern DB_functions_t *deadbeef;


@interface DBPluginConfigurationController ()

@end

@implementation DBPluginConfigurationController


- (NSInteger) runModal {
    
    return [NSApp runModalForWindow: [self window] ];
}


+ (DBPluginConfigurationController *) initPanelForPlugin : (NSString *) identifier {
    
    DB_plugin_t * plugin = deadbeef->plug_get_for_id( [identifier UTF8String] );
    
    NSRect contentSize = NSMakeRect(100.0, 100.0, 100.0, 100.0);
    NSUInteger styleMask = NSTitledWindowMask | NSResizableWindowMask | NSClosableWindowMask | NSMiniaturizableWindowMask;
    
    NSPanel * panel = [[NSPanel alloc] initWithContentRect: contentSize styleMask:styleMask backing:NSBackingStoreBuffered defer:YES];
    
    [panel setTitle: [NSString stringWithUTF8String: plugin->name] ];
    
    DBPluginConfigurationController * controller = [[DBPluginConfigurationController alloc] initWithWindow: panel];
    
    // parse script
    // code based on the equivalent in the gtkui plugin
    
/*    char token[MAX_TOKEN];
    const char *script = plugin->configdialog;
    parser_line = 1;
    
    int ncurr = 0;
    NSControl *controls[100] = {NULL};
    int pack[100] = {0};
    
    while (script = gettoken (script, token)) {
        if (strcmp (token, "property")) {
            fprintf (stderr, "invalid token while loading plugin %s config dialog: %s at line %d\n", plugin->name, token, parser_line);
            break;
        }
        char labeltext[MAX_TOKEN];
        script = gettoken_warn_eof (script, labeltext);
        if (!script) {
            break;
        }
        
        if (ncurr > 0) {
            pack[ncurr]--;
            if (pack[ncurr] < 0) {
                ncurr--;
            }
        }
        
        char type[MAX_TOKEN];
        script = gettoken_warn_eof (script, type);
        if (!script) {
            break;
        }
        
        if (!strncmp (type, "hbox[", 5) || !strncmp (type, "vbox[", 5)) {
            ncurr++;
            int n = 0;
            if (1 != sscanf (type+4, "[%d]", &n)) {
                break;
            }
            pack[ncurr] = n;
            
            int vert = 0;
            int hmg = FALSE;
            int fill = FALSE;
            int expand = FALSE;
            int border = 0;
            int spacing = 8;
            int height = 100;
            
            char param[MAX_TOKEN];
            for (;;) {
                script = gettoken_warn_eof (script, param);
                if (!script) {
                    break;
                }
                if (!strcmp (param, ";")) {
                    break;
                }
                else if (!strcmp (param, "hmg")) {
                    hmg = TRUE;
                }
                else if (!strcmp (param, "fill")) {
                    fill = TRUE;
                }
                else if (!strcmp (param, "expand")) {
                    expand = TRUE;
                }
                else if (!strncmp (param, "border=", 7)) {
                    border = atoi (param+7);
                }
                else if (!strncmp (param, "spacing=", 8)) {
                    spacing = atoi (param+8);
                }
                else if (!strncmp (param, "height=", 7)) {
                    height = atoi (param+7);
                }
            }
            // TODO: Equiv Cocoa
            //widgets[ncurr] = vert ? gtk_vbox_new (TRUE, spacing) : gtk_hbox_new (TRUE, spacing);
            //gtk_widget_set_size_request (widgets[ncurr], -1, height);
            //gtk_widget_show (widgets[ncurr]);
            //gtk_box_pack_start (GTK_BOX(widgets[ncurr-1]), widgets[ncurr], fill, expand, border);
            
            continue;
        }
        
        int vertical = 0;
        
        char key[MAX_TOKEN];
        for (;;) {
            script = gettoken_warn_eof (script, key);
            if (!script) {
                break;
            }
            if (!strcmp (key, "vert")) {
                vertical = 1;
            }
            else {
                break;
            }
        }
        
        char def[MAX_TOKEN];
        script = gettoken_warn_eof (script, def);
        if (!script) {
            break;
        }
        
        // add to dialog
        NSControl *label = NULL;
        NSControl *prop = NULL;
        NSControl *cont = NULL;
        char value[1000];
        conf->get_param (key, value, sizeof (value), def);
        if (!strcmp (type, "entry") || !strcmp (type, "password")) {
            label = gtk_label_new (_(labeltext));
            gtk_widget_show (label);
            prop = gtk_entry_new ();
            gtk_entry_set_activates_default (GTK_ENTRY (prop), TRUE);
            g_signal_connect (G_OBJECT (prop), "changed", G_CALLBACK (prop_changed), win);
            gtk_widget_show (prop);
            gtk_entry_set_text (GTK_ENTRY (prop), value);
            
            if (!strcmp (type, "password")) {
                gtk_entry_set_visibility (GTK_ENTRY (prop), FALSE);
            }
        }
        else if (!strcmp (type, "checkbox")) {
            prop = gtk_check_button_new_with_label (_(labeltext));
            g_signal_connect (G_OBJECT (prop), "toggled", G_CALLBACK (prop_changed), win);
            gtk_widget_show (prop);
            int val = atoi (value);
            gtk_toggle_button_set_active (GTK_TOGGLE_BUTTON (prop), val);
        }
        else if (!strcmp (type, "file")) {
            label = gtk_label_new (_(labeltext));
            gtk_widget_show (label);
            if (deadbeef->conf_get_int ("gtkui.pluginconf.use_filechooser_button", 0)) {
                prop = gtk_file_chooser_button_new (_(labeltext), GTK_FILE_CHOOSER_ACTION_OPEN);
                gtk_widget_show (prop);
                gtk_file_chooser_set_filename (GTK_FILE_CHOOSER (prop), value);
                g_signal_connect (G_OBJECT (prop), "file-set", G_CALLBACK (prop_changed), win);
            }
            else {
                cont = gtk_hbox_new (FALSE, 2);
                gtk_widget_show (cont);
                prop = gtk_entry_new ();
                gtk_entry_set_activates_default (GTK_ENTRY (prop), TRUE);
                g_signal_connect (G_OBJECT (prop), "changed", G_CALLBACK (prop_changed), win);
                gtk_widget_show (prop);
                gtk_editable_set_editable (GTK_EDITABLE (prop), FALSE);
                gtk_entry_set_text (GTK_ENTRY (prop), value);
                gtk_box_pack_start (GTK_BOX (cont), prop, TRUE, TRUE, 0);
                GtkWidget *btn = gtk_button_new_with_label ("…");
                gtk_widget_show (btn);
                gtk_box_pack_start (GTK_BOX (cont), btn, FALSE, FALSE, 0);
                g_signal_connect (G_OBJECT (btn), "clicked", G_CALLBACK (on_prop_browse_file), prop);
            }
        }
        else if (!strncmp (type, "select[", 7)) {
            int n;
            if (1 != sscanf (type+6, "[%d]", &n)) {
                break;
            }
            
            label = gtk_label_new (_(labeltext));
            gtk_widget_show (label);
            
            prop = gtk_combo_box_text_new ();
            gtk_widget_show (prop);
            
            for (int i = 0; i < n; i++) {
                char entry[MAX_TOKEN];
                script = gettoken_warn_eof (script, entry);
                if (!script) {
                    break;
                }
                
                gtk_combo_box_text_append_text (GTK_COMBO_BOX_TEXT (prop), entry);
            }
            if (!script) {
                break;
            }
            gtk_combo_box_set_active (GTK_COMBO_BOX (prop), atoi (value));
            g_signal_connect ((gpointer) prop, "changed",
                              G_CALLBACK (prop_changed),
                              win);
        }
        else if (!strncmp (type, "hscale[", 7) || !strncmp (type, "vscale[", 7) || !strncmp (type, "spinbtn[", 8)) {
            float min, max, step;
            const char *args;
            if (type[0] == 's') {
                args = type + 7;
            }
            else {
                args = type + 6;
            }
            if (3 != sscanf (args, "[%f,%f,%f]", &min, &max, &step)) {
                break;
            }
            int invert = 0;
            if (min >= max) {
                float tmp = min;
                min = max;
                max = tmp;
                invert = 1;
            }
            if (step <= 0) {
                step = 1;
            }
            if (type[0] == 's') {
                prop = gtk_spin_button_new_with_range (min, max, step);
                gtk_spin_button_set_value (GTK_SPIN_BUTTON (prop), atof (value));
            }
            else {
                prop = type[0] == 'h' ? gtk_hscale_new_with_range (min, max, step) : gtk_vscale_new_with_range (min, max, step);
                if (invert) {
                    gtk_range_set_inverted (GTK_RANGE (prop), TRUE);
                }
                gtk_range_set_value (GTK_RANGE (prop), (gdouble)atof (value));
                gtk_scale_set_value_pos (GTK_SCALE (prop), GTK_POS_RIGHT);
            }
            label = gtk_label_new (_(labeltext));
            gtk_widget_show (label);
            g_signal_connect (G_OBJECT (prop), "value-changed", G_CALLBACK (prop_changed), win);
            gtk_widget_show (prop);
        }
        
        script = gettoken_warn_eof (script, token);
        if (!script) {
            break;
        }
        if (strcmp (token, ";")) {
            fprintf (stderr, "expected `;' while loading plugin %s config dialog: %s at line %d\n", conf->title, token, parser_line);
            break;
        }
        
        
        if (label && prop) {
            GtkWidget *hbox = NULL;
            hbox = vertical ? gtk_vbox_new (FALSE, 8) : gtk_hbox_new (FALSE, 8);
            gtk_widget_show (hbox);
            gtk_box_pack_start (GTK_BOX (hbox), label, FALSE, FALSE, 0);
            gtk_box_pack_start (GTK_BOX (hbox), cont ? cont : prop, TRUE, TRUE, 0);
            cont = hbox;
        }
        else {
            cont = prop;
        }
        if (prop) {
            g_object_set_data (G_OBJECT (win), key, prop);
        }
        if (cont) {
            gtk_box_pack_start (GTK_BOX (widgets[ncurr]), cont, FALSE, FALSE, 0);
        }
    }
    */
    
    return controller;
    
}

@end
