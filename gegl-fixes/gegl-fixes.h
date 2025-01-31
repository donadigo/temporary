#include <glib.h>
#include <gegl.h>
#include <cogl/cogl.h>

GeglRectangle *gegl_fixes_get_bounding_box(GeglNode *node);
void *gegl_fixes_format(const gchar *format);

void gegl_fixes_set(GeglBuffer *buffer,
                    const GeglRectangle *rect,
                    gint mipmap_level,
                    const gchar *format,
                    const void *src,
                    gint rowstride);
         

void gegl_fixes_get (GeglBuffer* buffer,
                    const GeglRectangle* rect,
                    gdouble scale,
                    const gchar* format,
                    gpointer dest,
                    gint rowstride,
                    GeglAbyssPolicy abyss_policy);