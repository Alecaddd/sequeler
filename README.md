# ![Sequeler](sequeler-logo-transparent.png)
> Friendly SQL Client

Sequeler is a native Linux SQL client built in Vala and Gtk. It allows you to connect to your local and remote databases, write SQL in a handy text editor with language recognition, and visualize SELECT results in a Gtk.Grid Widget.

![](sequeler-screenshot.png)

## Get it from the elementary OS AppCenter!
Sequeler, is primarly availabe from the AppCenter of elementary OS. Download it from there!

[![Get it on AppCenter](https://appcenter.elementary.io/badge.svg)](https://appcenter.elementary.io/com.github.alecaddd.sequeler)

## Install it from source
You can install Sequeler by compiling from the source, here's the list of dependecies required:
 - `gtk+-3.0>=3.9.10`
 - `granite>=0.5.0`
 - `glib-2.0`
 - `gee-0.8`
 - `gobject-2.0`
 - `libxml-2.0`
 - `libgda-5.0`
 - `gtksourceview-3.0`

**Arch Based**
 - `vala`
 - `granite-git`
 - `libgee`
 - `libxml2`
 - `libgda`
 - `gtksourceview3`
 - `libgda-mysql`
 - `libgda-postgres`

Installation using AUR and Yaourt:
```
yaourt -S vala granite-git libgee libxml2 libgda gtksourceview3 libgda-mysql libgda-postgres
```

## Building
```
mkdir build/ && cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr ../
make && sudo make install
```

### Donations
If you like Sequeler and you want to support its development, consider donating via [PayPal](https://www.paypal.me/alecaddd) or pledge on [Patreon](https://www.patreon.com/alecaddd)
