


public interface Action : Object { 
    public abstract string name { get; set; }
    public abstract string icon_name { get; set; }

    public abstract void undo ();
}