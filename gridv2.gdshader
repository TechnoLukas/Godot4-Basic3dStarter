shader_type spatial;
render_mode ensure_correct_normals;


uniform vec4 lightColor : source_color;
uniform vec4 darkColor : source_color;
uniform vec4 borderColor : source_color;
const float gridSize = 4.0;
const float half = gridSize / 2.0;
const float border = gridSize / 1000.0;

bool borde(float pos) {
	return mod(pos, 1.0) < border || 1.0 - mod(pos, 1.0) < border || mod(pos, 0.5) < border || 0.5 - mod(pos, 0.5) < border;
}

void fragment(){
	vec4 world = INV_VIEW_MATRIX * vec4(VERTEX, 1.0);
	vec3 pos = world.xyz;
	// This is to avoid the zero incoherence
	if (pos.x <= 0.0) pos.x = abs(pos.x - half);
	if (pos.y <= 0.0) pos.y = abs(pos.y - half);
	if (pos.z <= 0.0) pos.z = abs(pos.z - half);
	pos /= gridSize;
	//pos += gridSize * half;
	
	pos.y += float(fract(float(int(pos.x*half))/half));
	pos.z += float(fract(float(int(pos.y*half))/half));
	
	vec3 col = vec3(0.0);
	if (vec3(fract(float(int(pos.z*half))/half)) == vec3(0.0)) {
		col += lightColor.rgb;
	} else {
		col += darkColor.rgb;
	}
	
	// border color
	if (borde(pos.x)) col = borderColor.rgb;
	if (borde(pos.y)) col = borderColor.rgb;
	if (borde(pos.z)) col = borderColor.rgb;
	
	ROUGHNESS = col.x / half + 1.0;
	ALBEDO = col;
	//METALLIC = 1f;
	//SPECULAR = 1f;
	
	// alpha changes the rendering order
	//ALPHA = 1f;
}