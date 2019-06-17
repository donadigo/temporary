

public class Core.ContextStore {
    private static Cogl2.Context? ctx;

    public static void init () {
        var loop = new MainLoop ();

        var stage = new Clutter.Stage ();
        stage.set_size (1, 1);
        

        var actor = new Clutter.Actor ();
        actor.paint.connect (() => {
            print ("PAINT\n");
            ctx = Cogl2.get_draw_framebuffer ().get_context ();
            //  stage.destroy ();
            actor.continue_paint ();
            loop.quit ();
        });

        stage.add (actor);
        stage.show_all ();
        actor.queue_redraw ();
        loop.run ();
    }

    public static unowned Cogl2.Context get () {
        return ctx;
    }
}