namespace CoglFixes { 
    [CCode (cname = "cogl_get_projection_matrix")]
    public void get_projection_matrix (out Cogl.Matrix matrix);

    [CCode (cname = "cogl_get_modelview_matrix")]
    public void get_modelview_matrix (out Cogl.Matrix matrix);

    [CCode (cname = "cogl_material_set_user_program")]
	public void set_user_program (Cogl.Material material, Cogl.Handle program);    
}