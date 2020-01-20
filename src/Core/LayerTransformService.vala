


public class Core.LayerTransformService : Service {
    Gee.LinkedList<TransformActor> actors;

    construct {
        actors = new Gee.LinkedList<TransformActor> ();
    }

    public override bool activate (Widgets.CanvasView canvas_view, Gee.HashMap<string, Variant>? options) {
        base.activate (canvas_view, options);

        unowned Clutter.Stage? stage = canvas_view.get_stage ();
        if (stage == null) {
            return false;
        }

        foreach (unowned Layer layer in canvas_view.doc.layer_stack.selected.get_layers ()) {
            unowned LayerActor? actor = canvas_view.get_actor_by_layer (layer);
            if (actor == null) continue;

            layer.dirty = true;
            var tactor = new TransformActor (stage, canvas_view, actor);
            actors.add (tactor);
            stage.add_child (tactor);
        }

        canvas_view.doc.freeze_mode_changes (ACTOR);
        var settings_widget = new Widgets.TransformSettingsWidget ();
        EventBus.get_default ().set_tool_settings_widget (null, settings_widget);

        return true;
    }

    public override void deactivate () {
        base.deactivate ();
        
        foreach (var tactor in actors) {
            tactor.layer_actor.layer.dirty = false;
            tactor.destroy ();
        }

        actors.clear ();
    }
}