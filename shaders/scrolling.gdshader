shader_type canvas_item;

uniform vec2 offset;

void vertex() {
	UV = UV + offset*TIME;
}