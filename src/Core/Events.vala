
[Flags]
public enum Core.EventType {
    CANVAS_EVENT,
    FOCUS_CANVAS,

    DRAW_HIGHLIGHT,

    CHANGE_CURSOR,
    FREEZE_CURSOR_CHANGES,

    SELECT_LAYERS,
    ALL
}

public struct Core.Event<G> {
    EventType type;
    G data;
}

public struct FocusCanvasEventData {
    unowned Core.Document doc;
}

public struct DrawHighlightEventData {
    Widgets.CDockWindow.AllocateHighlightRectangleCb? allocate_cb;
}

public struct SelectLayersEventData {
    Gee.LinkedList<unowned Core.LayerStackItem> items;
}

public struct FreezeCursorChangesEventData {
    bool freeze;
}

public struct ChangeCursorEventData {
    string name;
    unowned Gdk.Window? window;
}

public struct CanvasEventEventData {
    unowned Widgets.CanvasView canvas_view;
    unowned Clutter.Event event;
}
