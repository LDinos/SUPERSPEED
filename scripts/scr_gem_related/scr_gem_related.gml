function gems_spawn(spawn_matchless) //called by board
{ 
	for(var i = 0; i < BOARD_ROWS; i++)
	{
		for(var j = 0; j < BOARD_COLS; j++)
		{
			instance_create_layer(x + GRID_SIZE/2 + j*GRID_SIZE, y + GRID_SIZE/2 + i*GRID_SIZE, "Gems",obj_gem)
		}
	}
	
	if (spawn_matchless) {gems_spawn_unmatch()}
}

function gems_spawn_unmatch()
{
	while gems_find_num_matches(true) //while we have at least one match
	{	
		with(obj_gem) image_index = irandom(6) //re-make the skins
	}
	gems_create_board_array()
}

function gems_reset_board_array()
{
	for(var i = 0; i < BOARD_ROWS; i++)
	{
		for(var j = 0; j < BOARD_COLS; j++)
		{
			with(obj_board) gem_array[i][j] = noone
		}
	}
}

function gems_create_board_array()
{
	gems_reset_board_array() //set every grid to noone
	with(obj_gem) //then set every grid to whatever gem is in
	{
		var i = (y-obj_board.y) div 64
		var j = (x-obj_board.x) div 64
		obj_board.gem_array[i][j] = id
	}
}

function gems_find_num_matches(stop_at_one)
{
	gems_create_board_array()
	var num_matches = 0;
	
	for(var i = 0; i < 8; i++)
	{
		var row_consecutive_matches = 1;
		var col_consecutive_matches = 1;
		var check = false;
		for(var row = 1; row < BOARD_ROWS; row++)
		{
			var skin = obj_board.gem_array[row][i].image_index
			var prev_skin = obj_board.gem_array[row-1][i].image_index
			if (skin == prev_skin) row_consecutive_matches++
			else check = true
			
			if (row == 7) check = true
			if check
			{
				if (row_consecutive_matches >= 3)
				{
					num_matches++
					if (stop_at_one) return true;
				}
				row_consecutive_matches = 1
				check = false
			}
			
		}
		for(var col = 1; col < BOARD_COLS; col++)
		{
			var skin = obj_board.gem_array[i][col].image_index
			var prev_skin = obj_board.gem_array[i][col-1].image_index
			if (skin == prev_skin) col_consecutive_matches++
			else check = true
			
			if (col == 7) check = true
			if check
			{	
				if (col_consecutive_matches >= 3)
				{
					num_matches++
					if (stop_at_one) return true;
				}
				col_consecutive_matches = 1
				check = false
			}
		}
	}

	return num_matches;
}

function gems_find_ij_index(gem){
	var gem_struct = {
		i : (gem.y-obj_board.y) div 64,
		j : (gem.x-obj_board.x) div 64
	};
	
	return gem_struct;
}