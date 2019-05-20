

public class CHeaderBar : Gtk.HeaderBar {
    Gtk.SearchEntry search_entry;
    Gtk.Button newdoc_btn;

    NewDocumentDialog? newdoc_dialog;

    construct {
        show_close_button = true;
        
        search_entry = new Gtk.SearchEntry ();
        search_entry.valign = Gtk.Align.CENTER;

        pack_end (search_entry);

        newdoc_btn = new Gtk.Button.from_icon_name ("document-new", Gtk.IconSize.LARGE_TOOLBAR);
        newdoc_btn.clicked.connect (on_newdoc_btn_clicked);
        pack_start (newdoc_btn);

        var open_btn = new Gtk.Button.from_icon_name ("document-open", Gtk.IconSize.LARGE_TOOLBAR);
        pack_start (open_btn);
    }

    void on_newdoc_btn_clicked () {
        newdoc_btn.sensitive = false;

        newdoc_dialog = new NewDocumentDialog ();
        newdoc_dialog.transient_for = (Gtk.Window)get_toplevel ();
        newdoc_dialog.destroy.connect (() => newdoc_btn.sensitive = true);
        newdoc_dialog.show_all ();
    }
}