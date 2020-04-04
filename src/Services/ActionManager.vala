/*
* Copyright (c) 2011-2018 Alecaddd (http://alecaddd.com)
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public
* License as published by the Free Software Foundation; either
* version 2 of the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* General Public License for more details.
*
* You should have received a copy of the GNU General Public
* License along with this program; if not, write to the
* Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
* Boston, MA 02110-1301 USA
*
* Authored by: Alessandro "Alecaddd" Castellani <castellani.ale@gmail.com>
*/

public class Sequeler.Services.ActionManager : Object {
    public const int FONT_SIZE_MAX = 72;
    public const int FONT_SIZE_MIN = 7;

    public weak Sequeler.Application app { get; construct; }
    public weak Sequeler.Window window { get; construct; }

    public SimpleActionGroup actions { get; construct; }

    public const string ACTION_PREFIX = "win.";
    public const string ACTION_NEW_WINDOW = "action_new_window";
    public const string ACTION_NEW_CONNECTION = "action_new_connection";
    public const string ACTION_RUN_QUERY = "action_run_query";
    public const string ACTION_LOGOUT = "action_logout";
    public const string ACTION_QUIT = "action_quit";
    public const string ACTION_ZOOM_DEFAULT = "action_zoom_default";
    public const string ACTION_ZOOM_IN = "action_zoom_in";
    public const string ACTION_ZOOM_OUT = "action_zoom_out";

    public static Gee.MultiMap<string, string> action_accelerators = new Gee.HashMultiMap<string, string> ();

    private const ActionEntry[] ACTION_ENTRIES = {
        { ACTION_NEW_WINDOW, action_new_window },
        { ACTION_NEW_CONNECTION, action_new_connection },
        { ACTION_RUN_QUERY, action_run_query },
        { ACTION_LOGOUT, action_logout },
        { ACTION_QUIT, action_quit },
        { ACTION_ZOOM_DEFAULT, action_set_default_zoom },
        { ACTION_ZOOM_IN, action_zoom_in },
        { ACTION_ZOOM_OUT, action_zoom_out}
    };

    public ActionManager (Sequeler.Application sequeler_app, Sequeler.Window main_window) {
        Object (
            app: sequeler_app,
            window: main_window
        );
    }

    static construct {
        action_accelerators.set (ACTION_NEW_WINDOW, "<Control>n");
        action_accelerators.set (ACTION_NEW_CONNECTION, "<Control><Shift>n");
        action_accelerators.set (ACTION_RUN_QUERY, "<Control>Return");
        action_accelerators.set (ACTION_LOGOUT, "<Control>Escape");
        action_accelerators.set (ACTION_QUIT, "<Control>q");
        action_accelerators.set (ACTION_ZOOM_DEFAULT, "<Control>0");
        action_accelerators.set (ACTION_ZOOM_DEFAULT, "<Control>KP_0");
        action_accelerators.set (ACTION_ZOOM_IN, "<Control>plus");
        action_accelerators.set (ACTION_ZOOM_IN, "<Control>equal");
        action_accelerators.set (ACTION_ZOOM_IN, "<Control>KP_Add");
        action_accelerators.set (ACTION_ZOOM_OUT, "<Control>minus");
        action_accelerators.set (ACTION_ZOOM_OUT, "<Control>KP_Subtract");
    }

    construct {
        actions = new SimpleActionGroup ();
        actions.add_action_entries (ACTION_ENTRIES, this);
        window.insert_action_group ("win", actions);

        foreach (var action in action_accelerators.get_keys ()) {
            var accels_array = action_accelerators[action].to_array ();
            accels_array += null;

            app.set_accels_for_action (ACTION_PREFIX + action, accels_array);
        }
    }

    private void action_quit () {
        window.before_destroy ();
    }

    private void action_logout () {
        window.headerbar.toggle_logout.begin ();
        window.headerbar.title = APP_NAME;
        window.headerbar.subtitle = null;

        if (window.main.database_schema.scroll.get_child () != null) {
            window.main.database_schema.scroll.remove (window.main.database_schema.scroll.get_child ());
        }

        window.main.database_view.query.buffer.text = "";
        window.main.database_view.query.export_button.sensitive = false;

        window.main.database_view.structure.reset.begin ();
        window.main.database_view.structure.table_name = "";

        window.main.database_view.content.reset.begin ();
        window.main.database_view.content.table_name = "";

        window.main.database_view.relations.reset.begin ();
        window.main.database_view.relations.table_name = "";

        window.main.connection_closed ();
        window.data_manager.data = null;
    }

    private void action_new_window () {
        app.new_window ();
    }

    private void action_new_connection () {
        if (window.main.connection_manager != null) {
            return;
        }

        window.data_manager.data = null;

        if (window.connection_dialog == null) {
            window.connection_dialog = new Sequeler.Widgets.ConnectionDialog (window);
            window.connection_dialog.show_all ();

            window.connection_dialog.destroy.connect (() => {
                window.connection_dialog = null;
            });
        }

        window.connection_dialog.present ();
    }

    private void action_run_query () {
        if (window.main.connection_manager == null) {
            return;
        }

        var query = window.main.database_view.query.get_text ().strip ();

        if (query == "") {
            return;
        }

        window.main.database_view.query.run_query (query);
    }

    public static void action_from_group (string action_name, ActionGroup? action_group) {
        action_group.activate_action (action_name, null);
    }

    public void set_default_zoom () {
        Sequeler.settings.font = get_current_font () + " " + get_default_font_size ().to_string ();
        window.main.database_view.query.update_font_style ();
    }

    // Ctrl + scroll
    public void action_zoom_in () {
        zooming (Gdk.ScrollDirection.UP);
    }

    // Ctrl + scroll
    public void action_zoom_out () {
        zooming (Gdk.ScrollDirection.DOWN);
    }

    private void zooming (Gdk.ScrollDirection direction) {
        string font = get_current_font ();
        int font_size = (int) get_current_font_size ();
        if (Sequeler.settings.use_system_font) {
            Sequeler.settings.use_system_font = false;
            font = get_default_font ();
            font_size = (int) get_default_font_size ();
        }

        if (direction == Gdk.ScrollDirection.DOWN) {
            font_size --;
            if (font_size < FONT_SIZE_MIN) {
                return;
            }
        } else if (direction == Gdk.ScrollDirection.UP) {
            font_size ++;
            if (font_size > FONT_SIZE_MAX) {
                return;
            }
        }

        string new_font = font + " " + font_size.to_string ();
        Sequeler.settings.font = new_font;
        window.main.database_view.query.update_font_style ();
    }

    public string get_current_font () {
        string font = Sequeler.settings.font;
        string font_family = font.substring (0, font.last_index_of (" "));
        return font_family;
    }

    public double get_current_font_size () {
        string font = Sequeler.settings.font;
        string font_size = font.substring (font.last_index_of (" ") + 1);
        return double.parse (font_size);
    }

    public string get_default_font () {
        string font = window.main.database_view.query.default_font;
        string font_family = font.substring (0, font.last_index_of (" "));
        return font_family;
    }

    public double get_default_font_size () {
        string font = window.main.database_view.query.default_font;
        string font_size = font.substring (font.last_index_of (" ") + 1);
        return double.parse (font_size);
    }

    // Actions functions
    private void action_set_default_zoom () {
        set_default_zoom ();
    }
}
