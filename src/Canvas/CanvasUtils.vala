


namespace Canvas.CanvasUtils { 
    public static void translate_to_stage_layer (Clutter.Actor stage, Clutter.Event event, Clutter.Actor layer_actor, out float x, out float y) {
        event.get_coords (out x, out y);
        float ex = x / (float)layer_actor.scale_x;
        float ey = y / (float)layer_actor.scale_y;
        stage.transform_stage_point (ex, ey, out ex, out ey);

        x = ex;
        y = ey;
    }

    public static void translate_to_stage (Clutter.Actor stage, Clutter.Event event, out float x, out float y) {
        event.get_coords (out x, out y);
        float ex = x;
        float ey = y;
        stage.transform_stage_point (ex, ey, out ex, out ey);

        x = ex;
        y = ey;
    }
}