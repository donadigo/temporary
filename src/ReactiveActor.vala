

public class ReactiveActor : Clutter.Actor {

    public override bool event (Clutter.Event event) {
        foreach (var child in get_children ()) {
            child.emit_event (event, false);
        }

        return false;
    }
}