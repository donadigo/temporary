namespace CoglFixes { 
    [CCode (cname = "cogl_get_projection_matrix")]
    public void get_projection_matrix (out Cogl.Matrix matrix);

    [CCode (cname = "cogl_get_modelview_matrix")]
    public void get_modelview_matrix (out Cogl.Matrix matrix);

    [CCode (cname = "cogl_material_set_user_program")]
    public void set_user_program (Cogl.Material material, Cogl.Handle program);
    
    [CCode (cname = "cogl_program_set_uniform_1f")]
    public void set_uniform_1f (Cogl.Program program, int uniform_no, float value);
    
    [CCode (cname = "cogl_program_set_uniform_1i")]
    public void set_uniform_1i (Cogl.Program program, int uniform_no, int value);	
}