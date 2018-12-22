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

#if IS_DEVEL
public const string APP_NAME = "(Development) Sequeler";
#else
public const string APP_NAME = "Sequeler";
#endif
public const string TERMINAL_NAME = "sequeler";

public static int main (string[] args) {
	Environment.set_application_name ("Sequeler");
	Environment.set_prgname ("Sequeler");

	var application = new Sequeler.Application ();

	return application.run (args);
}
