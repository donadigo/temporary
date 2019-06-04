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