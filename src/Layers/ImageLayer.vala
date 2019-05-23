

public class ImageLayer : Layer {
    public Image image { get; construct; }
    public File? file { get; construct; }
    public signal void ready ();

    public Cogl.Texture texture;
    Cogl.Material material;
    Cogl.PixelFormat format;

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
        //  material.set_layer_combine (1, "RGBA = MOUDLATE(PREVIOUS, TEXTURE)");
        //  material.set_layer_combine (1, "RGBA = REPLACE(TEXTURE)");

        shader = new Clutter.Shader ();
        shader.set_fragment_source ("""
            uniform sampler2D tex0;
            uniform sampler2D tex1;
            uniform float canvasWidth;
            uniform float canvasHeight;
            uniform float layerWidth;
            uniform float layerHeight;

            void main () {
                vec2 sample = cogl_tex_coord1_in.xy *  vec2(layerWidth, layerHeight) / vec2(canvasWidth, canvasHeight) ;
                cogl_color_out = texture2D(tex0, cogl_tex_coord0_in.xy) + texture2D(tex1, cogl_tex_coord1_in.xy);
                
                //  float ratio = layerWidth / canvasWidth;
                //  cogl_color_out = texture2D(tex0, cogl_tex_coord0_in.xy) + texture2D(tex1, cogl_tex_coord1_in.xy * ratio);
            }
        """, -1);
        shader.compile ();

        CoglFixes.set_user_program (material, shader.get_cogl_program ());
        //  material.set_layer_combine  (1, "RGBA = ADD (PREVIOUS, TEXTURE)");
    }
    
    public override void paint (Document doc, LayerActor actor, Clutter.Matrix matrix) {
        //  var previous = doc.layer_stack.get_by_index (index - 1);
        //  if (previous != null) {
        //      material.set_layer (0, ((ImageLayer)previous).texture);
        //      material.set_layer (1, texture);
        //  }
        //  doc.material.set_layer (doc.material.get_n_layers (), texture);
        float canvas_width = (float)actor.pipeline.get_current_texture ().get_width ();
        float canvas_height = (float)actor.pipeline.get_current_texture ().get_height ();
        shader.set_uniform ("tex0", 0);
        shader.set_uniform ("tex1", 1);
        shader.set_uniform ("canvasWidth", (float)actor.pipeline.get_current_texture ().get_width ());
        shader.set_uniform ("canvasHeight", (float)actor.pipeline.get_current_texture ().get_height ());
        shader.set_uniform ("layerWidth", (float)bounding_box.width);
        shader.set_uniform ("layerHeight", (float)bounding_box.height);

        
        Cogl.Matrix mat;
        Cogl.push_matrix ();
        Cogl.set_modelview_matrix (Cogl.Matrix.identity());
        Cogl.set_viewport (bounding_box.x, bounding_box.y, bounding_box.width, bounding_box.height);
        CoglFixes.get_modelview_matrix (out mat);
        Cogl.pop_matrix ();

        var p = actor.get_stage ().get_perspective ();
        //  Cogl.Matrix mat = Cogl.Matrix.identity ();
        //  mat.translate (-0.1f, -0.1f, 0);
        //  mat.translate (-0.1f, -0.1f, 0);
        //  mat.ortho (0, 0.5f, 0, 0.5f, -1, 100);
        //  CoglFixes.get_modelview_matrix (out mat);
        //  mat.translate (bounding_box.x, bounding_box.y, 0);
        //  mat.frustum ()
        //  var m = (Clutter.Matrix)mat;
        //  actor.apply_transform (ref matrix);

        //  mat.translate (-bounding_box.x, -bounding_box.y, 0);
        //  material.set_layer_matrix (0, mat);

        //  print (file.get_path () + "\n");
        //  material.set_layer (0, actor.pipeline.get_current_texture ());
        material.set_layer (0, actor.pipeline.get_current_texture ());
        material.set_layer (1, texture);

        //  material.set_layer_matrix (0, Cogl.Matrix.identity ());
        material.set_layer_matrix (1, mat);


        uchar opacity = (uchar)actor.get_paint_opacity ();
        material.set_color4ub (opacity, opacity, opacity, opacity);

        Cogl.set_source (material);
        //  var black = Cogl.Color.from_4ub (0, 0, 0, 0);
        //  Cogl.TextureVertex[] verts = {};
        //  Cogl.TextureVertex v = { 100, 0, 0, 0, 0, black };
        //  verts += v;
        //  v = { 0, (float)bounding_box.height, 0, 0, 1, black };
        //  verts += v;
        //  v = { (float)bounding_box.width, (float)bounding_box.height, 0, 1, 1, black };
        //  verts += v;
        //  v = { (float)bounding_box.width - 100, 0, 0, 1, 0, black };
        //  verts += v;
        //  verts[0] = 

        //  Cogl.polygon (verts, false);
        //  Cogl.rectangle (0, 0, (float)bounding_box.width, (float)bounding_box.height);
        Cogl.rectangle (0, 0, actor.pipeline.get_current_texture ().get_width (), actor.pipeline.get_current_texture ().get_height());

        //  Cogl.rectangle (-1, -1, 1, 1)
    
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