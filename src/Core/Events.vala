
[Flags]
public enum EventType {
    SELECT_LAYERS,
    ALL
}

public struct Event<G> {
    EventType type;
    G data;
}


public struct SelectLayersEvent<SelectLayersEventData> : Event {}
public struct SelectLayersEventData {
    Gee.LinkedList<unowned LayerStackItem> items;
}