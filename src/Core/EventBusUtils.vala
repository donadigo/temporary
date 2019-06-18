

namespace Core.EventBusUtils { 
    public static void change_cursor (string name, Gdk.Window? window = null) {
        var data = ChangeCursorEventData () {
            name = name,
            window = window
        };

        EventBus.post<ChangeCursorEventData?> (EventType.CHANGE_CURSOR, data);        
    }
}