#include <a_samp>

#define MAX_SPIKESTRIPS		2

#define COLOR_BLUE        0xFFFFFF


enum spike
{
	sCreated,
    Float:sX,
    Float:sY,
    Float:sZ,
    sObject,
};
new SpikeInfo[MAX_SPIKESTRIPS][spike];
new PlayerSpikeCount[MAX_PLAYERS];


stock CreateStrip(Float:x, Float:y, Float:z, Float:Angle, playerid)
{
    if (PlayerSpikeCount[playerid] >= MAX_SPIKESTRIPS)
    {
        SendClientMessage(playerid, COLOR_BLUE, "Вы установили максимальное количество шипов");
        return 0;
    }

    for (new i = 0; i < sizeof(SpikeInfo); i++)
    {
        if (SpikeInfo[i][sCreated] == 0)
        {
            SpikeInfo[i][sCreated] = 1;
            SpikeInfo[i][sX] = x;
            SpikeInfo[i][sY] = y;
            SpikeInfo[i][sZ] = z - 0.7;
            SpikeInfo[i][sObject] = CreateObject(2892, x, y, z - 0.9, 0, 0, Angle - 90);
            PlayerSpikeCount[playerid]++;
            SendClientMessage(playerid, COLOR_BLUE, "Вы установили шипы");
            return 1;
        }
    }
    return 0;
}

stock DeleteClosestStrip(playerid)
{
	if (PlayerSpikeCount[playerid] < 0)
    {
        SendClientMessage(playerid, COLOR_BLUE, "Вы не устанавливали шипы");
        return 0;
    }
    for(new i = 0; i < sizeof(SpikeInfo); i++)
  	{
  	    if(IsPlayerInRangeOfPoint(playerid, 2.0, SpikeInfo[i][sX], SpikeInfo[i][sY], SpikeInfo[i][sZ]))
        {
  	        if(SpikeInfo[i][sCreated] == 1)
            {
                SpikeInfo[i][sCreated]= 0;
                SpikeInfo[i][sX]= 0.0;
                SpikeInfo[i][sY]= 0.0;
                SpikeInfo[i][sZ]= 0.0;
                DestroyObject(SpikeInfo[i][sObject]);
                SendClientMessage(playerid, COLOR_BLUE, "Вы удалили шипы");

				PlayerSpikeCount[playerid]--;
                if (PlayerSpikeCount[playerid] < 0)
                    PlayerSpikeCount[playerid] = 0;
                return 1;
  	        }
  	    }
  	}
    return 0;
}

public OnPlayerUpdate(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;

    if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
    {
        for(new i = 0; i < sizeof(SpikeInfo); i++)
        {
            if(IsPlayerInRangeOfPoint(playerid, 4.0, SpikeInfo[i][sX], SpikeInfo[i][sY], SpikeInfo[i][sZ]))
            {
                if(SpikeInfo[i][sCreated] == 1)
                {
                    new panels, doors, lights, tires;
                    new carid = GetPlayerVehicleID(playerid);
                    GetVehicleDamageStatus(carid, panels, doors, lights, tires);
                    tires = encode_tires(1, 1, 1, 1);
                    UpdateVehicleDamageStatus(carid, panels, doors, lights, tires);
                    return 0;
                }
            }
        }
    }

    return 1;
}


encode_tires(tires1, tires2, tires3, tires4) {

	return tires1 | (tires2 << 1) | (tires3 << 2) | (tires4 << 3);

}
