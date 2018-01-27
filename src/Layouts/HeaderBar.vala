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

public class Sequeler.Layouts.HeaderBar : Gtk.HeaderBar {
    public weak Sequeler.Window window { get; construct; }

    private Gtk.Button logout_button;

    public bool logged_out { get; set; }

    public HeaderBar (Sequeler.Window main_window) {
        Object (
            window: main_window,
            logged_out: true
        );

        set_title (APP_NAME);
        set_show_close_button (true);

        build_ui ();
    }

    private void build_ui () {
        var eject_image = new Gtk.Image.from_icon_name ("media-eject", Gtk.IconSize.BUTTON);
        logout_button = new Gtk.Button.with_label (_("Logout"));
        logout_button.get_style_context ().add_class ("back-button");
        logout_button.always_show_image = true;
        logout_button.set_image (eject_image);
        logout_button.can_focus = false;
        logout_button.action_name = Sequeler.Services.ActionManager.ACTION_PREFIX + Sequeler.Services.ActionManager.ACTION_LOGOUT;
        toggle_logout ();

        var new_window = new HeaderBarButton ("window-new", _("New Window"));
        new_window.action_name = Sequeler.Services.ActionManager.ACTION_PREFIX + Sequeler.Services.ActionManager.ACTION_NEW_WINDOW;

        var new_connection = new HeaderBarButton ("bookmark-new", _("New Connection"));
        new_connection.action_name = Sequeler.Services.ActionManager.ACTION_PREFIX + Sequeler.Services.ActionManager.ACTION_NEW_CONNECTION;

        var menu = new Gtk.Menu ();

        var about_item = new Gtk.MenuItem.with_label (_("About"));
        about_item.activate.connect (() => {
            try {
                Gtk.show_uri (null, "https://github.com/alecaddd/sequeler", 0);
            } catch (Error error) {}
        });
        menu.add (about_item);

        var report_problem_item = new Gtk.MenuItem.with_label (_("Report a Problem…"));
        report_problem_item.activate.connect (() => {
            try {
                Gtk.show_uri (null, "https://github.com/alecaddd/sequeler/issues", 0);
            } catch (Error error) {}
        });
        menu.add (report_problem_item);

        menu.add (new Gtk.SeparatorMenuItem ());

        var new_window_item = new Gtk.MenuItem.with_label (_("New Window"));
        new_window_item.action_name = Sequeler.Services.ActionManager.ACTION_PREFIX + Sequeler.Services.ActionManager.ACTION_NEW_WINDOW;
        new_window_item.add_accelerator ("activate", window.accel_group, Gdk.keyval_from_name("N"), Gdk.ModifierType.CONTROL_MASK, Gtk.AccelFlags.VISIBLE);
        menu.add (new_window_item);

        var new_connection_item = new Gtk.MenuItem.with_label (_("New Connection"));
        new_connection_item.action_name = Sequeler.Services.ActionManager.ACTION_PREFIX + Sequeler.Services.ActionManager.ACTION_NEW_CONNECTION;
        new_connection_item.add_accelerator ("activate", window.accel_group, Gdk.keyval_from_name("N"), Gdk.ModifierType.CONTROL_MASK + Gdk.ModifierType.SHIFT_MASK, Gtk.AccelFlags.VISIBLE);
        menu.add (new_connection_item);

        var preferences_item = new Gtk.MenuItem.with_label (_("Preferences"));
        preferences_item.action_name = Sequeler.Services.ActionManager.ACTION_PREFIX + Sequeler.Services.ActionManager.ACTION_PREFERENCES;
        preferences_item.add_accelerator ("activate", window.accel_group, Gdk.keyval_from_name("a"), Gdk.ModifierType.CONTROL_MASK, Gtk.AccelFlags.VISIBLE);
        menu.add (preferences_item);

        menu.add (new Gtk.SeparatorMenuItem ());

        var quit_item = new Gtk.MenuItem.with_label (_("Quit"));
        quit_item.action_name = Sequeler.Services.ActionManager.ACTION_PREFIX + Sequeler.Services.ActionManager.ACTION_QUIT;
        quit_item.add_accelerator ("activate", window.accel_group, Gdk.keyval_from_name("Q"), Gdk.ModifierType.CONTROL_MASK, Gtk.AccelFlags.VISIBLE);
        menu.add (quit_item);

        menu.show_all  ();
        
        var open_menu = new Gtk.MenuButton ();
        open_menu.set_image (new Gtk.Image.from_icon_name ("open-menu", Gtk.IconSize.BUTTON));
        open_menu.set_tooltip_text ("Settings");

        open_menu.popup = menu;
        open_menu.relief = Gtk.ReliefStyle.NONE;
        open_menu.valign = Gtk.Align.CENTER;

        pack_start (logout_button);
        pack_end (open_menu);
        pack_end (new_connection);
        pack_end (new Gtk.Separator (Gtk.Orientation.VERTICAL));
        pack_end (new_window);
    }

    public void toggle_logout () {
        logged_out = !logged_out;
        logout_button.visible = logged_out;
        logout_button.no_show_all = !logged_out;
    }

    protected class HeaderBarButton : Gtk.Button {
        public HeaderBarButton (string icon_name, string tooltip) {
            can_focus = false;

            Gtk.Image image;

            if (icon_name.contains ("/")) {
                image = new Gtk.Image.from_resource (icon_name);
            } else {
                image = new Gtk.Image.from_icon_name (icon_name, Gtk.IconSize.BUTTON);
            }

            image.margin = 3;

            get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);
            set_tooltip_text (tooltip);
            this.add (image);
        }
    }
}