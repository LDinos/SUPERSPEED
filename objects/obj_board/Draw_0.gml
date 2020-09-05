/// @description Insert description here
// You can write your code in this editor
draw_self()
for(var i = 0; i < BOARD_ROWS; i++)
{
	for(var j = 0; j < BOARD_COLS; j++)
	{
		if instance_exists(gem_array[i][j]) draw_text(8 +  j*24, 8 + i*24,gem_array[i][j].image_index)
	}
}
draw_text(8,8+9*24,fps_real)