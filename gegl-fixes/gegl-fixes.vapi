[CCode (cheader_filename = "gegl-fixes/gegl-fixes.h")]
namespace GeglFixes { 
    public Gegl.Rectangle get_bounding_box (Gegl.Node node);
    public void set (Gegl.Buffer buffer, Gegl.Rectangle rect, int mipmap_level, string format_name, void* src, int rowstride);
}

[CCode (cheader_filename = "gegl-fixes/gegl-fixes.h")]
namespace Babl {
    [CCode (cname = "gegl_fixes_format")]
    public void* format (string format);
}

namespace ClutterFixes {
    [CCode (cheader_filename = "clutter/clutter-types.h", cname = "clutter_matrix_init_from_array")]
    public static unowned Clutter.Matrix init_from_array ([CCode (array_length = false)] float values[16]);
}