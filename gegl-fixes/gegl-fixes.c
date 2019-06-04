#include <glib.h>
#include <gegl.h>
#include "gegl-fixes.h"

GeglRectangle* gegl_fixes_get_bounding_box (GeglNode* node)
{
    g_return_if_fail (node);

    GeglRectangle box;
    box = gegl_node_get_bounding_box (node);
    return gegl_rectangle_dup (&box);
}

void* gegl_fixes_format (const gchar* format)
{
    return babl_format(format);
}

void gegl_fixes_set (GeglBuffer* buffer,
                    const GeglRectangle* rect,
                    gint mipmap_level, 
                    const gchar* format, 
                    const void* src,
                    gint rowstride)
{
    g_return_if_fail (buffer);
    Babl* bformat;

    bformat = babl_format (format);
    gegl_buffer_set(buffer, rect, mipmap_level, bformat, src, GEGL_AUTO_ROWSTRIDE);
}                    