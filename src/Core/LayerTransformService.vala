


public class Core.LayerTransformService : Object {
    static LayerTransformService? instance;
    public static unowned LayerTransformService get_default () {
        if (instance == null) {
            instance = new LayerTransformService ();
        }

        return instance;
    }

    Gee.LinkedList<TransformActor> actors;

    construct {
        actors = new Gee.LinkedList<TransformActor> ();
    }

    public bool activate (Clutter.Stage stage, Widgets.CanvasView canvas_view, Layer layer) {
        unowned LayerActor? actor = canvas_view.get_actor_by_layer (layer);
        if (actor == null) return false;

        layer.freeze_updates ();
        var tactor = new TransformActor (stage, canvas_view, actor);
        actors.add (tactor);
        stage.add_child (tactor);
        return true;
    }

    public void deactivate_current () {
        foreach (var tactor in actors) {
            tactor.layer_actor.layer.thaw_updates ();
            tactor.destroy ();
        }

        actors.clear ();
    }
}