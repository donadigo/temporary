
using Core;

public class TransformHandleActor : Clutter.Actor {
    Clutter.Canvas canvas;

    public TransformHandleActor (int initial_width, int initial_height) {
        canvas.set_size (initial_width, initial_height);
        set_size (initial_width, initial_height);
    }

    construct {
        set_pivot_point (0.5f, 0.5f);

        canvas = new Clutter.Canvas ();
        canvas.draw.connect (on_content_draw);
        content = canvas;

        notify["allocation"].connect (() => canvas.set_size ((int)width, (int)height));
    }

    bool on_content_draw (Cairo.Context cr, int width, int height) {
        cr.set_operator (Cairo.Operator.CLEAR);
        cr.paint ();

        cr.set_operator (Cairo.Operator.OVER);
        cr.set_antialias (Cairo.Antialias.NONE);
        draw_rectangle (cr, 0, 0, width, height);
        return true;
    }

    static void draw_rectangle (Cairo.Context cr, int x, int y, int width, int height) {
        cr.set_line_width (2);
        cr.set_source_rgba (0.6, 0.6, 0.6, 1);
        cr.rectangle (x, y, width, height);
        cr.stroke ();

        cr.set_line_width (1);
        cr.set_source_rgba (1, 1, 1, 0.5);
        cr.rectangle (x + 2, y + 1.5, width-3, height-3);
        cr.stroke ();
    }
}