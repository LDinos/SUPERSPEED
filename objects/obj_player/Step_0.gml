if mouse_check_button(mb_left)
{
	var gem = instance_position(mouse_x,mouse_y,obj_gem)

	if (selected_gem == noone) {if (gem != noone) {selected_gem = gem; xx = mouse_x; yy = mouse_y; /*show_message(string(mouse_y)+ " " + string(yy))*/ }}
	else
	{
		var i_to_check = (selected_gem.y-obj_board.y) div 64
		var j_to_check = (selected_gem.x-obj_board.x) div 64
		var should_swap = false;
		if ((mouse_x - xx) >= deadzone) {j_to_check++; should_swap = true;} //swapped right
		else if ((mouse_x - xx) < -deadzone) {j_to_check--; should_swap = true;} //swapped left
		else if ((mouse_y - yy) < -deadzone) {i_to_check--; should_swap = true;} //swapped up
		else if ((mouse_y - yy) >= deadzone) {i_to_check++; should_swap = true;} //swapped down
		if (should_swap) //if we dragged the mouse enough to swap to somewhere
		{
			if (i_to_check >= 0 && i_to_check <= 7) && (j_to_check >= 0 && j_to_check <= 7)
			{		
				var gem2 = obj_board.gem_array[i_to_check][j_to_check]
				if (check_swap(selected_gem,gem2) == true)
				{
					audio_play_sound(snd_test,0,false)
					var posx = selected_gem.x
					selected_gem.x = gem2.x
					gem2.x = posx
					var posy = selected_gem.y
					selected_gem.y = gem2.y
					gem2.y = posy
					execute_matches()
				}
				mouse_clear(mb_left)
				selected_gem = noone; xx = 0; yy = 0;
			}
		}
	}
}
else {selected_gem = noone; xx = 0; yy = 0;}