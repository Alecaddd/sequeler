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

public class Sequeler.Services.Types.MySQL : Object, DataBaseType {
	public string port { set; get; default = "3306"; }
	public string host { set; get; default = "127.0.0.1"; }

	public string connection_string (Gee.HashMap<string, string> data) {
		var username = Gda.rfc1738_encode (data["username"]);
		var password = Gda.rfc1738_encode (data["password"]);
		var name = Gda.rfc1738_encode (data["name"]);
		host = data["host"] != "" ? Gda.rfc1738_encode (data["host"]) : host;
		if (data["has_ssh"] == "true") {
			port = "9000";
		} else {
			port = data["port"] != "" ? data["port"] : port;
		}

		return "MySQL://" + username + ":" + password + "@DB_NAME=" + name + ";HOST=" + host + ";PORT=" + port;
	}

	public string show_schema () {
		return "SHOW SCHEMAS";
	}

	public string show_table_list (string name) {
		return "SHOW TABLES;";
	}

	public string edit_table_name (string old_table, string new_table) {
		return "RENAME TABLE %s TO %s".printf (old_table, new_table);
	}

	public string show_table_structure (string table) {
		return "DESCRIBE %s".printf (table);
	}

	public string show_table_content (string table) {
		return "SELECT * FROM %s".printf (table);
	}

	public string show_table_relations (string table, string? database) {
		return "SELECT COLUMN_NAME, CONSTRAINT_NAME, REFERENCED_COLUMN_NAME, REFERENCED_TABLE_NAME FROM information_schema.KEY_COLUMN_USAGE WHERE TABLE_NAME = '%s' AND TABLE_SCHEMA = '%s'".printf (table, database);
	}
}
