

public class ImageLayer : Layer {
    public Image image { get; construct; }
    public File? file { get; construct; }
    public signal void ready ();

    public Cogl.Texture texture;
    Cogl.Material material;
    Cogl.PixelFormat format;

    Cogl.Material screen_material;

    Clutter.Shader shader;

    public ImageLayer (File? file) {
        Object (file: file);
    }

    construct {
        image = new Image ();

        if (file != null) {
            var reader = new PngFileReader ();
            reader.read.begin (file, (obj, res) => {
                var output = reader.read.end (res);
                image.data = output.data;
                bounding_box = { 0, 0, output.width, output.height };
                format = output.format;
                update ();
                ready ();
            });
        } else {
            ready ();
        }

        material = new Cogl.Material ();
        material.set_layer_filters (0, Cogl.MaterialFilter.NEAREST, Cogl.MaterialFilter.NEAREST);
        material.set_layer_filters (1, Cogl.MaterialFilter.NEAREST, Cogl.MaterialFilter.NEAREST);

        screen_material = new Cogl.Material ();
        screen_material.set_layer_filters (0, Cogl.MaterialFilter.NEAREST, Cogl.MaterialFilter.NEAREST);
        screen_material.set_layer_filters (1, Cogl.MaterialFilter.NEAREST, Cogl.MaterialFilter.NEAREST);        

        shader = new Clutter.Shader ();
        shader.set_fragment_source ("""
            uniform sampler2D tex0;
            uniform sampler2D tex1;

            void main () {
                vec4 t0 = texture2D(tex0, cogl_tex_coord0_in.xy);
                vec4 t1 = texture2D(tex1, cogl_tex_coord1_in.xy);

                cogl_color_out = mix(t0, t1, t1.a);
            }
        """, -1);
        shader.compile ();
        shader.set_uniform ("tex0", 0);
        shader.set_uniform ("tex1", 1);

        CoglFixes.set_user_program (screen_material, shader.get_cogl_program ());
    }
    
    public override void paint_content (Document doc, LayerActor actor) {
        float canvas_width = (float)actor.pipeline.get_current_texture ().get_width ();
        float canvas_height = (float)actor.pipeline.get_current_texture ().get_height ();

        material.set_layer (0, texture);

        uchar opacity = (uchar)actor.get_paint_opacity ();
        material.set_color4ub (opacity, opacity, opacity, opacity);

        Cogl.set_source (material);

        Cogl.rectangle (0, 0, (float)bounding_box.width, (float)bounding_box.height);
    }

    public override void paint (Document doc, LayerActor actor) {
        unowned Cogl.Texture current = actor.pipeline.get_current_texture ();
        unowned Cogl.Texture layer = actor.pipeline.get_layer_texture ();
        screen_material.set_layer (0, current);
        screen_material.set_layer (1, layer);
        Cogl.set_source (screen_material);

        Cogl.rectangle (0, 0, current.get_width (), current.get_height());
    }

    void rectangle (float x, float y, float width, float height) {
        Cogl.rectangle (
            map_coord_to_gl (bounding_box.width, x),
            map_coord_to_gl (bounding_box.height, y + height),
            map_coord_to_gl (bounding_box.width, x + width),
            map_coord_to_gl (bounding_box.height, y)
        );
    }

    static float map_coord_to_gl (float target_size, float val)
    {
        return 2.0f / target_size * val - 1.0f;
    }

    public override void update () {
        rebuild_texture ();
    }

    void rebuild_texture () {
        texture = new Cogl.Texture.from_data (
            bounding_box.width, bounding_box.height,
            Cogl.TextureFlags.NONE, format,
            Cogl.PixelFormat.ANY, 0, image.data
        );

        material.set_layer (0, texture);
    }
}