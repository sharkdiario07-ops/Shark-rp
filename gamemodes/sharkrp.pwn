
#include <a_samp>

#define DIALOG_REGISTRO 1
#define DIALOG_LOGIN 2

new bool:Logado[MAX_PLAYERS];

main()
{
    print("================================");
    print("           SHARK RP");
    print("       Servidor iniciado");
    print("================================");
}

public OnGameModeInit()
{
    SetGameModeText("SHARK ROLEPLAY");

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

    print("[SHARK RP] Gamemode carregado!");

    return 1;
}

public OnPlayerConnect(playerid)
{
    new nome[MAX_PLAYER_NAME];
    new arquivo[64];

    GetPlayerName(playerid, nome, sizeof(nome));
    format(arquivo, sizeof(arquivo), "%s.ini", nome);

    Logado[playerid] = false;

    TogglePlayerSpectating(playerid, true);

    if(fexist(arquivo))
    {
        ShowPlayerDialog(
            playerid,
            DIALOG_LOGIN,
            DIALOG_STYLE_PASSWORD,
            "SHARK RP | Login",
            "Digite sua senha para entrar na cidade:",
            "Entrar",
            "Sair"
        );
    }
    else
    {
        ShowPlayerDialog(
            playerid,
            DIALOG_REGISTRO,
            DIALOG_STYLE_PASSWORD,
            "SHARK RP | Registro",
            "Bem-vindo ao SHARK RP!\nCrie uma senha para sua conta:",
            "Registrar",
            "Sair"
        );
    }

    return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(!response)
    {
        Kick(playerid);
        return 1;
    }

    new nome[MAX_PLAYER_NAME];
    new arquivo[64];
    new hash[65];
    new senhaSalva[128];

    GetPlayerName(playerid, nome, sizeof(nome));
    format(arquivo, sizeof(arquivo), "%s.ini", nome);

    if(dialogid == DIALOG_REGISTRO)
    {
        if(strlen(inputtext) < 4)
        {
            ShowPlayerDialog(playerid, DIALOG_REGISTRO,
                DIALOG_STYLE_PASSWORD,
                "SHARK RP | Registro",
                "Sua senha precisa ter pelo menos 4 caracteres:",
                "Registrar", "Sair");
            return 1;
        }

        SHA256_PassHash(inputtext, nome, hash, sizeof(hash));

        new File:conta = fopen(arquivo, io_write);

        if(conta)
        {
            fwrite(conta, hash);
            fclose(conta);

            Logado[playerid] = true;

            SendClientMessage(playerid, 0x32CDFFFF,
                "Conta criada com sucesso!");

            TogglePlayerSpectating(playerid, false);
            SpawnPlayer(playerid);
        }
        else
        {
            SendClientMessage(playerid, 0xFF0000FF,
                "Erro ao criar sua conta.");
            Kick(playerid);
        }

        return 1;
    }

    if(dialogid == DIALOG_LOGIN)
    {
        new File:conta = fopen(arquivo, io_read);

        if(conta)
        {
            fread(conta, senhaSalva, sizeof(senhaSalva));
            fclose(conta);

            SHA256_PassHash(inputtext, nome, hash, sizeof(hash));

            if(!strcmp(hash, senhaSalva))
            {
                Logado[playerid] = true;

                SendClientMessage(playerid, 0x32CDFFFF,
                    "Login realizado com sucesso!");

                TogglePlayerSpectating(playerid, false);
                SpawnPlayer(playerid);
            }
            else
            {
                ShowPlayerDialog(playerid, DIALOG_LOGIN,
                    DIALOG_STYLE_PASSWORD,
                    "SHARK RP | Login",
                    "Senha incorreta!\nDigite novamente:",
                    "Entrar", "Sair");
            }
        }

        return 1;
    }

    return 0;
}

public OnPlayerSpawn(playerid)
{
    if(!Logado[playerid])
    {
        TogglePlayerSpectating(playerid, true);
        return 1;
    }

    SendClientMessage(playerid, 0xFFFFFFFF,
        "Voce entrou na cidade. Bom jogo!");

    return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    Logado[playerid] = false;
    return 1;
}
