shader_type spatial;
render_mode depth_draw_always; 
#include "funcs.gdshaderinc"
uniform sampler2D icon; 
uniform vec3 color: source_color; 
uniform float num_cells: hint_range(2.0, 50.0, 1.0)=10.0; 
uniform float speed: hint_range(0.1,2.0, 0.01)=1.0;
uniform float smoothness: hint_range(0.5, 2.0, 0.01)=0.5; 
uniform float angle: hint_range(0.0, 360.0)=45.0; 

void fragment(){	
	vec2 igrid = floor(UV * num_cells)/num_cells;	
	igrid = rotation(igrid, vec2(0.5), angle * PI/180.0);  
	igrid.x += 2.0 - mod(TIME*speed,4.0); 
	vec2 fgrid = fract(UV * num_cells); 
	float rect_mask = rectanglef(igrid,0.001,2.0,smoothness); 
	float grid_mask = 1.0 - rectangle(fgrid,rect_mask,rect_mask); 
	float emission_mask = 1.0 - rectangle(fgrid,rect_mask+0.1,rect_mask+0.1) - grid_mask; 
	vec3 tex = texture(icon,UV).rgb;	
	ALBEDO = mix(tex, color, emission_mask); 
	ALPHA = emission_mask+grid_mask;
	EMISSION = emission_mask * color * 5.0; 
	
}