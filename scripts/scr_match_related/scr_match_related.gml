function check_swap(gem1,gem2) //see if the swap is legal (aka it matches gems)
{ 
	var board = obj_board.gem_array //take the board and put in a temporary variable
	var g1_index = gems_find_ij_index(gem1) //get their indexes in a struct
	var g2_index = gems_find_ij_index(gem2)
		
	//swap them
	board[g1_index.i,g1_index.j] = obj_board.gem_array[g2_index.i,g2_index.j]
	board[g2_index.i,g2_index.j] = obj_board.gem_array[g1_index.i,g1_index.j]
	//show_message(string(g1_index.i) + "," + string(g1_index.j) + " - " + string(g2_index.i) + "," + string(g2_index.j))
	//check if there are matches above/down or left/right of me
	if (is_gem_matching(board, g1_index) || is_gem_matching(board, g2_index)) {return true;}
	else { return false;}
}

function execute_matches()
{
	gems_create_board_array()
	check_for_matches(true)
	check_for_matches(false)
}

function check_for_matches(kill_matched_gems)
{
	var gems_to_kill = ds_list_create()
	var board = obj_board.gem_array //easier to read variable
	for (var i = 0; i < 8; i++)
	{
		var n = 1; //number of consecutive matches as far	
		for( var j = 1; j < 8; j++)
		{
			var do_match = false; //do we have 3+ gem matches? If so, execute them!
			var myskin = board[i][j].image_index
			var otherskin = board[i][j-1].image_index
			if (myskin == otherskin) n++
			else if (n >= 3) do_match = true;
			else n = 1
			
			var last_check = ((j == 7 && n >=3) && !do_match)
			if ((do_match) || last_check)
			{
				for(var k = j-n+last_check; k < j+last_check; k++) ds_list_add(gems_to_kill,board[i][k])
				n = 1
			}
			if (j==7) n = 1
		}
		n = 1
		for( var j = 1; j < 8; j++)
		{
			var do_match = false; //do we have 3+ gem matches? If so, execute them!
			var myskin = board[j][i].image_index
			var otherskin = board[j-1][i].image_index
			if (myskin == otherskin) n++
			else if (n >= 3) do_match = true;
			else n = 1
			
			var last_check = ((j == 7 && n >=3) && !do_match)
			if ((do_match) || last_check)
			{
				for(var k = j-n+last_check; k < j+last_check; k++) ds_list_add(gems_to_kill,board[k][i])
				n = 1
			}
			if (j==7) n = 1
		}
	}
	
	for(var j = 0; j < ds_list_size(gems_to_kill); j++)
	{
		if (kill_matched_gems) 
		{
			var ind = gems_find_ij_index(gems_to_kill[| j])
			board[ind.i][ind.j] = noone
			instance_destroy(gems_to_kill[| j])
		}
		else gems_to_kill[| j].shake = true
	}
	
	ds_list_destroy(gems_to_kill)
	if (kill_matched_gems) execute_board_spawn_physics(board)
}

function execute_board_spawn_physics(board)
{
	var temp_board;
	for(var i = 0; i < BOARD_ROWS; i++) for(var j = 0; j < BOARD_COLS; j++) temp_board[i][j] = noone
	for(var j = 0; j < BOARD_COLS; j++)
	{
		var n = 7
		var n_spawn = 0;
		for(var i = BOARD_ROWS-1; i >= 0; i--)
		{
			if (board[i][j] != noone) {temp_board[n][j] = board[i][j]; board[i][j].y = obj_board.y +n*GRID_SIZE+32; n--}
			else {temp_board[n_spawn][j] = instance_create_layer(obj_board.x + j*GRID_SIZE+32, obj_board.y + n_spawn*GRID_SIZE+32, "Gems",obj_gem); n_spawn++}
		}
	}
	obj_board.gem_array = temp_board
}

function is_gem_matching(board,index_struct){
	var skin = board[index_struct.i,index_struct.j].image_index
	var matches = 1;
	var n = 1;
	var deadzone_left = 0; // dont do a checkup after not finding the right skin, put a high number here
	var deadzone_right = 0; // so the loop condition will end
	do
	{
		var skinleft, skinright;
		if (index_struct.i - n - deadzone_left >= 0)
		{
			skinleft = board[index_struct.i - n,index_struct.j].image_index
			if (skin == skinleft) matches++
			else deadzone_left = 8 //end one condition
			if matches >= 3 return true;
		}
		if (index_struct.i + n + deadzone_right <= 7)
		{
			skinright = board[index_struct.i + n,index_struct.j].image_index
			if (skin == skinright) matches++
			else deadzone_right = 8 //end one condition
			if matches >= 3 return true;
		}
		n++
	}until ((index_struct.i - n - deadzone_left < 0) && (index_struct.i + n + deadzone_right> 7))
	matches = 1;
	n = 1;
	deadzone_left = 0; // dont do a checkup after not finding the right skin, put a high number here
	deadzone_right = 0; // so the loop condition will end
	do
	{
		var skinleft, skinright;
		if (index_struct.j - n - deadzone_left >= 0)
		{
			skinleft = board[index_struct.i,index_struct.j - n].image_index
			if (skin == skinleft) matches++
			else deadzone_left = 8 //end one condition
			if matches >= 3 return true;
		}
		if (index_struct.j + n + deadzone_right <= 7)
		{
			skinright = board[index_struct.i,index_struct.j + n].image_index
			if (skin == skinright) matches++
			else deadzone_right = 8 //end one condition
			if matches >= 3 return true;
		}
		n++
	}until ((index_struct.j - n - deadzone_left < 0) && (index_struct.j + n + deadzone_right> 7))
	

	return false;
}