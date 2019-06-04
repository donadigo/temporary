#include <glib.h>
#include <gegl.h>

GeglRectangle *gegl_fixes_get_bounding_box(GeglNode *node);

void gegl_fixes_set(GeglBuffer *buffer,
                    const GeglRectangle *rect,
                    gint mipmap_level,
                    const gchar *format,
                    const void *src,
                    gint rowstride);
         
void *gegl_fixes_format(const gchar *format);
