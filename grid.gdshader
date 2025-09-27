shader_type spatial;
render_mode unshaded;

uniform float len1=0.4;
uniform float len2=0.1;
uniform vec4 color1 = vec4(1.0,0.0,0.0,0.5); 
uniform vec4 color2 = vec4(1.0,1.0,1.0,0.25); 

varying vec3 loc_vertex;

void vertex() {
	loc_vertex = VERTEX;
}

void fragment() {
	if (mod(loc_vertex.z,len1+len2)<=len1) {
			ALBEDO = color1.rgb;
			ALPHA = color1.a;
	} else {
			ALBEDO = color2.rgb;
			ALPHA = color2.a;
		}
}