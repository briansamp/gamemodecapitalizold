new	ServerSong[128];

Song_Save()
{
	new str[5000];

	CreateServerPoint();
    format(str, sizeof(str), "UPDATE server SET serversong='%s' WHERE id=0",
	ServerSong);
    return mysql_tquery(g_SQL, str);
}

function LoadSong()
{
	cache_get_value_name(0, "serversong", ServerSong);
	format(ServerSong, 128, ServerSong);
	printf("[Server] Number of Loaded Data Song Server...");
	
}