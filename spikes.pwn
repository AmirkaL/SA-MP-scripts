#include <a_samp>
#include <zcmd>

#include <spik>

#define COLOR_YELLOW	0xFFFF00AA



CMD:spikes(playerid, params[])
{
    if (!strcmp(params, "place", true))
    {
        new Float:x, Float:y, Float:z, Float:angle;
        GetPlayerPos(playerid, x, y, z);
        GetPlayerFacingAngle(playerid, angle);
        CreateStrip(x, y, z, angle, playerid);
        return 1;
    }

    if (!strcmp(params, "pickup", true))
    {
        DeleteClosestStrip(playerid);
        return 1;
    }
    return 0;
}
