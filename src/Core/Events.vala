
[Flags]
public enum Core.EventType {
    SELECT_LAYERS,
    ALL
}

public struct Core.Event<G> {
    EventType type;
    G data;
}


public struct SelectLayersEvent<SelectLayersEventData> : Core.Event {}
public struct SelectLayersEventData {
    Gee.LinkedList<unowned Core.LayerStackItem> items;
}