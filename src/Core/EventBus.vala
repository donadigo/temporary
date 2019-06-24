
public class Core.EventBus : Object {
    static EventBus? instance = null;
    public static unowned EventBus get_default () {
        if (instance == null) {
            instance = new EventBus ();
        }

        return instance;
    }

    public signal void canvas_event (Widgets.CanvasView canvas_view, Clutter.Event event);
    public signal void force_redraw_canvas (Core.Document doc);
    public signal void focus_canvas (Core.Document doc);

    public signal void draw_highlight (DrawHighlightEventData data);

    public signal void change_cursor (string name, Gdk.Window? window = null);
    public signal void freeze_cursor_changes (bool freeze);
    public signal void current_document_changed (Core.Document? doc);
    public signal void select_layers (Gee.LinkedList<unowned Core.LayerStackItem> items);

    public signal void set_tool_settings_widget (Gtk.Widget widget);
}