
#include <a_samp>

main()
{
    print("================================");
    print("       BRASIL ROLEPLAY");
    print("       Servidor iniciado");
    print("================================");
}

public OnGameModeInit()
{
    SetGameModeText("Brasil Roleplay");
    ShowPlayerMarkers(PLAYER_MARKERS_MODE_GLOBAL);
    ShowNameTags(true);
    SetWorldTime(12);
    SetWeather(2);

    AddPlayerClass(
        0,
        1481.0, -1771.0, 18.7958,
        0.0,
        0, 0, 0, 0, 0, 0
    );

    print("[BRASIL RP] Gamemode carregado!");

    return 1;
}

public OnPlayerConnect(playerid)
{
    SendClientMessage(
        playerid,
        0x32CD32FF,
        "Bem-vindo ao Brasil Roleplay!"
    );

    return 1;
}

public OnPlayerSpawn(playerid)
{
    SendClientMessage(
        playerid,
        0xFFFFFFFF,
        "Voce entrou na cidade. Bom jogo!"
    );

    return 1;
}
