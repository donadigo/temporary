

public class LayerActor : Clutter.Actor {
    public Document doc { get; construct; }
    public Layer layer { get; construct; }
    public unowned RenderPipeline pipeline { get; construct; }

    bool dragging = false;
    float drag_x = 0;
    float drag_y = 0;

    Gegl.Rectangle start_box;

    public LayerActor (Document doc, Layer layer, RenderPipeline pipeline) {
        Object (doc: doc, layer: layer, pipeline: pipeline);
    }

    construct {
        reactive = true;
        layer.notify["bounding-box"].connect (update_bounding_box);
        layer.notify["opacity"].connect (update_opacity);
        update_bounding_box ();
        update_opacity ();

        notify["scale-x"].connect (update_position);
        notify["scale-y"].connect (update_position);
        doc.notify["scale"].connect (() => {
            set_scale (doc.scale, doc.scale);
        });
    }

    public override bool key_press_event (Clutter.KeyEvent event) {
        doc.enter_actor_mode ();
        switch (event.keyval) {
            case Clutter.Key.Left:
                layer.bounding_box.x -= 1;
                update_bounding_box ();
                break;
            case Clutter.Key.Right:
                layer.bounding_box.x += 1;
                update_bounding_box ();
                break;
            case Clutter.Key.Down:
                layer.bounding_box.y += 1;
                update_bounding_box ();
                break;
            case Clutter.Key.Up:
                layer.bounding_box.y -= 1;
                update_bounding_box ();
                break;                    
        }

        return true;
    }

    public override bool key_release_event (Clutter.KeyEvent event) {
        doc.process_graph ();
        return true;
    }

    public override bool motion_event (Clutter.MotionEvent event) {
        if (dragging) {
            float ex = event.x / (float)scale_x;
            float ey = event.y / (float)scale_y;
            get_parent ().transform_stage_point (ex, ey, out ex, out ey);

            float delta_x = ex - drag_x;
            float delta_y = ey - drag_y;
            layer.bounding_box = new Gegl.Rectangle (
                start_box.x + (int)delta_x, start_box.y + (int)delta_y,
                layer.bounding_box.width, layer.bounding_box.height
            );

            layer.update ();
        }
        
        return true;
    }

    public override bool button_release_event (Clutter.ButtonEvent event) {
        if (event.button == 1) {
            doc.process_graph ();
            layer.dirty = false;
            dragging = false;
            return true;
        }

        return false;
    }

    public override bool button_press_event (Clutter.ButtonEvent event) {
        if (event.button == 1) {
            get_stage ().set_key_focus (this);
            doc.enter_actor_mode ();

            layer.dirty = true;

            float ex = event.x / (float)scale_x;
            float ey = event.y / (float)scale_y;
            get_parent ().transform_stage_point (ex, ey, out ex, out ey);

            drag_x = ex;
            drag_y = ey;
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

    void update_position () {
        set_position (layer.bounding_box.x * (float)scale_x, layer.bounding_box.y * (float)scale_y);
    }

    void update_bounding_box () {
        set_size (layer.bounding_box.width, layer.bounding_box.height);
        update_position ();
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