

public class LayerActor : Clutter.Actor {
    public Document doc { get; construct; }
    public Layer layer { get; construct; }
    public unowned RenderPipeline pipeline { get; construct; }

    bool dragging = false;
    float drag_x = 0;
    float drag_y = 0;

    Gdk.Rectangle start_box;

    public LayerActor (Document doc, Layer layer, RenderPipeline pipeline) {
        Object (doc: doc, layer: layer, pipeline: pipeline);
    }

    construct {
        reactive = true;
        layer.notify["bounding-box"].connect (update_bounding_box);
        layer.notify["opacity"].connect (update_opacity);
        update_bounding_box ();
        update_opacity ();

        set_pivot_point (0.5f, 0.5f);
    }

    public override bool motion_event (Clutter.MotionEvent event) {
        if (dragging) {
            float delta_x = event.x - drag_x;
            float delta_y = event.y - drag_y;
            layer.bounding_box = {
                start_box.x + (int)delta_x, start_box.y + (int)delta_y,
                layer.bounding_box.width, layer.bounding_box.height
            };

            layer.update ();
        }
            
        return true;
    }

    public override bool button_release_event (Clutter.ButtonEvent event) {
        if (event.button == 1) {
            dragging = false;
            return true;
        }

        return false;
    }

    public override bool button_press_event (Clutter.ButtonEvent event) {
        if (event.button == 1) {
            drag_x = event.x;
            drag_y = event.y;
            start_box = layer.bounding_box;
            dragging = true;
            return true;
        }

        return false;
    }


    public override void paint () {
        pipeline.bind_layer ();

        uint twidth, theight;
        pipeline.get_size (out twidth, out theight);

        var pp = get_stage ().get_perspective ();
        var matrix = setup_viewport (twidth, theight, pp.fovy, 1, pp.z_near, pp.z_far);

        var layer_matrix = Clutter.Matrix.alloc ().init_from_matrix ((Clutter.Matrix)matrix);
        apply_transform (ref layer_matrix);
        Cogl.set_modelview_matrix (layer_matrix);

        layer.paint_content (doc, this);

        pipeline.end_layer ();

        pipeline.bind_current ();
        /**
         * We avoid setting up the viewport again. We just restore it's matrix + perspective.
         */
        Cogl.set_modelview_matrix (matrix);
        set_perspective (twidth, theight, pp.fovy, 1, pp.z_near, pp.z_far);
        layer.paint (doc, this);
        pipeline.end_current ();
    }

    void update_bounding_box () {
        set_position (layer.bounding_box.x, layer.bounding_box.y);
        set_size (layer.bounding_box.width, layer.bounding_box.height);
    }

    void update_opacity () {
        opacity = (uint)(layer.opacity * 255);
    }

    public static Cogl.Matrix setup_viewport (float width, float height, float fovy, float aspect, float z_near, float z_far) {
        set_perspective (width, height, fovy, aspect, z_near, z_far);
        Cogl.Matrix projection_matrix;
        CoglFixes.get_projection_matrix (out projection_matrix);
        float z_camera = 0.5f * projection_matrix.xx;

        var matrix = Cogl.Matrix.identity ();
        matrix.translate (-0.5f, -0.5f, -z_camera);
        matrix.scale (1.0f / width, -1.0f / height, 1.0f /width);
        matrix.translate (0, -1.0f * height, 0);
        return matrix;
    }

    public static void set_perspective (float width, float height, float fovy, float aspect, float z_near, float z_far) {
        Cogl.set_viewport (0, 0, (int)width, (int)height);
        Cogl.perspective (fovy, aspect, z_near, z_far);
    }
}