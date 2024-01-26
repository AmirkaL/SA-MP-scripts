#include <a_samp>

#define DIALOG_SOE			1051
#define DIALOG_CREATE		DIALOG_SOE + 1
#define DIALOG_SELECT   	DIALOG_SOE + 2

#define MAX_OBJECT_DISTANCE 25.0


enum SavedEnums {
	Float:foX,
	Float:foY,
	Float:foZ,
	Float:roX,
	Float:roY,
	Float:roZ
};

new g_ObjectIDs[] = {1427, 1422, 1434, 1459, 1228, 1423, 1424, 1282, 1435, 1238, 1237, 979, 1425, 3091, 981, 19834};


public OnPlayerCommandText(playerid, cmdtext[])
{
	if(strcmp("/bort create", cmdtext, true, 10) == 0)
	{
		ShowPlayerDialog(playerid, DIALOG_SOE, DIALOG_STYLE_TABLIST_HEADERS,
		"Выбор ограждения", "Название\tID объекта\t\n\
            Дорожный барьер #1\t1427\n\
            Дорожный барьер #2\t1422\n\
            Дорожный барьер #3\t1434\n\
            Дорожный барьер #4\t1459\n\
            Дорожный барьер #5\t1228\n\
            Дорожный барьер #6\t1423\n\
            Дорожный барьер #7\t1424\n\
            Дорожный барьер #8\t1282\n\
            Дорожный барьер #9\t1435\n\
            Дорожный барьер #10\t1238\n\
            Дорожный барьер #11\t1237\n\
            Дорожный барьер #12\t979\n\
            Дорожный барьер #13\t1425\n\
            Дорожный барьер #14\t3091\n\
            Дорожный барьер #15\t981\n\
            Дорожный барьер #16\t19834", 
            "Выбрать", "Отменить");
		return 1;
	}

	else if(strcmp(cmdtext, "/bort list", true) == 0)
	{
	    ShowPlayerDialog(playerid, 22, DIALOG_STYLE_TABLIST_HEADERS, "Список ограждений", "Название\tID объекта\tНикнейм\n\
	\t\t", "ОК", "Закрыть");
		return 1;
	}

    else if(strcmp("/bort edit", cmdtext, true, 10) == 0)
	{
		SelectObject(playerid);
		return 1;
	}
	return 0;		
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    switch(dialogid)
    {
        case DIALOG_SOE:
        {
            if(response)
            {
                if(listitem >= 0 && listitem < sizeof(g_ObjectIDs))
                {
                    CreateObjectAndEdit(playerid, g_ObjectIDs[listitem]);
                    SendClientMessage(playerid, 0xFFFFFF, "Вы начали установку ограждения");
                }
                else
                {
                    SendClientMessage(playerid, 0xFF0000FF, "Ошибка: Неправильный выбор ограждения");
                }
            }
            else
            {
                SendClientMessage(playerid, 0xFF0000FF, "Вы отменили установку ограждения");
            }
            return 1;
        }

        case DIALOG_SELECT:
        {
            new objectid = GetPVarInt(playerid, "SelectedObject");
            if(response)
            {
                EditObject(playerid, objectid);
                SendClientMessage(playerid, 0xFFFFFF, "Вы установили ограждение");
            }
            else
            {
                DestroyObject(objectid);
                CancelEdit(playerid);
                SendClientMessage(playerid, 0xFF0000FF, "Вы отменили установку ограждения");
            }
            return 1;
        }
    }
    return 1;
}

public OnPlayerSelectObject(playerid, type, objectid, modelid, Float:fX, Float:fY, Float:fZ)
{
    ShowPlayerDialog(playerid, DIALOG_SELECT, DIALOG_STYLE_MSGBOX, "Действие с объектом", \
        "Вы можете изменить или удалить установленный объект", "Изменить", "Удалить");
    SetPVarInt(playerid, "SelectedObject", objectid);
    SetPVarInt(playerid, "ModelID", modelid);
    return 1;
}

public ShowObjectList(playerid)
{
    return 1;
}

public CreateObjectAndEdit(playerid, modelid)
{
    new Float:playerX, Float:playerY, Float:playerZ;
    GetPlayerPos(playerid, playerX, playerY, playerZ);

    new Float:X, Float:Y, Float:Z;
    GetPlayerPos(playerid, X, Y, Z);

    if (!CheckObjectPosition(X, Y, Z, playerX, playerY, playerZ))
    {
        SendClientMessage(playerid, 0xFF0000FF, "Вы попытались установить ограждение за пределами разрешенных координат. Объект не был установлен");
        return;
    }

    new obj = CreateObject(modelid, X + 1, Y + 1, Z, 0.0, 0.0, 0.0);

    printf("Player Pos: %.2f, %.2f, %.2f", playerX, playerY, playerZ);
    printf("Object Pos: %.2f, %.2f, %.2f", X + 1, Y + 1, Z);

    EditObject(playerid, obj);
    SetPVarInt(playerid, "ModelID", modelid);
}


public CheckObjectPosition(Float:X, Float:Y, Float:Z, Float:playerX, Float:playerY, Float:playerZ)
{
    // минимальные координаты
    new Float:minX = playerX - MAX_OBJECT_DISTANCE;
    new Float:minY = playerY - MAX_OBJECT_DISTANCE;
    new Float:minZ = playerZ - MAX_OBJECT_DISTANCE;

    // Проверка пределов
    if (X < minX || X > (playerX + MAX_OBJECT_DISTANCE) ||
        Y < minY || Y > (playerY + MAX_OBJECT_DISTANCE) ||
        Z < minZ || Z > (playerZ + MAX_OBJECT_DISTANCE))
    {
        return false; // объект за пределами радиуса
    }

    return true; // объект в пределе радиуса
}
