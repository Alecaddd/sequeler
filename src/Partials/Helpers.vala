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

namespace Sequeler.Partials { 
	public class TitleBar : Gtk.Grid {
		public TitleBar (string text) {
			get_style_context ().add_class ("library-titlebar");

			var title = new Gtk.Label (text);
			title.get_style_context ().add_class ("h4");
			title.halign = Gtk.Align.CENTER;
			title.margin = 4;
			title.hexpand = true;

			this.add (title);
		}
	}

	public class ResponseMessage : Gtk.Label {
		public ResponseMessage () {
			get_style_context ().add_class ("h4");
			halign = Gtk.Align.CENTER;
			valign = Gtk.Align.CENTER;
			justify = Gtk.Justification.CENTER;
			set_line_wrap (true);
			margin_bottom = 10;
		}
	}

	public class Entry : Gtk.Entry {
		public Entry (string? placeholder, string? val) {
			hexpand = true;

			if (placeholder != null) {
				placeholder_text = placeholder;
			}

			if (val != null) {
				text = val;
			}
		}
	}

	public class ButtonClass : Gtk.Button {
		public ButtonClass (string text, string* class) {
			label = text;

			if (class != null) {
				var style_context = this.get_style_context ();
				style_context.add_class (class);
			}   
		}
	}

	public class TableRow : Gtk.Grid {
		public TableRow (string text, int type) {
			if (type % 2 == 0) {
				get_style_context ().add_class ("row-odd");
			} else {
				get_style_context ().add_class ("row-even");
			}

			var title = new Gtk.Label (text);
			title.get_style_context ().add_class ("h4");
			title.halign = Gtk.Align.START;
			title.margin_start = 6;
			title.margin_end = 6;
			title.hexpand = true;

			this.add (title);
		}
	}

	public class LabelForm : Gtk.Label {
		public LabelForm (string text) {
			label = text;
			halign = Gtk.Align.END;
		}
	}
}