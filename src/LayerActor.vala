

public class LayerActor : Clutter.Actor {
    public Document doc { get; construct; }
    public Layer layer { get; construct; }
    public unowned RenderPipeline pipeline { get; construct; }

    bool dragging = false;
    float drag_x = 0;
    float drag_y = 0;

    Rectangle<int> start_box;

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
        pipeline.bind_current ();

        var p = get_stage ().get_perspective ();
        
        uint twidth, theight;
        pipeline.get_size (out twidth, out theight);

        var matrix = setup_viewport (twidth, theight, p.fovy, 1, p.z_near, p.z_far);
        pipeline.draw_current ();

        //  apply_transform (ref matrix);
        //  Cogl.set_modelview_matrix (matrix);

        layer.paint (doc, this, matrix);

        pipeline.end_current ();
    }

    void update_bounding_box () {
        set_position (layer.bounding_box.x, layer.bounding_box.y);
        set_size (layer.bounding_box.width, layer.bounding_box.height);
    }

    void update_opacity () {
        opacity = (uint)(layer.opacity * 255);
    }

    public static Clutter.Matrix setup_viewport (float width, float height, float fovy, float aspect, float z_near, float z_far) {
        Cogl.set_viewport (0, 0, (int)width, (int)height);
        Cogl.perspective (fovy, aspect, z_near, z_far);
        
        Cogl.Matrix projection_matrix;
        CoglFixes.get_projection_matrix (out projection_matrix);
        float z_camera = 0.5f * projection_matrix.xx;

        var matrix = Clutter.Matrix.alloc ().init_identity ();

        matrix.translate (-0.5f, -0.5f, -z_camera);
        matrix.scale (1.0f / width, -1.0f / height, 1.0f /width);
        matrix.translate (0, -1.0f * height, 0);

        Cogl.set_modelview_matrix (matrix);
        return matrix;


        //  float z_camera;
        //  Cogl.Matrix projection_matrix;
        
    }
}