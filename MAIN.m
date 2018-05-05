function MAIN
close all;
clear;
clc;

%profile on

imgBricks = imread('images/brickSmall.jpg');
imgGrass = imread('images/grassSmall.jpg');
[imgPacman, pm, alphaPacman] = imread('images/pac3D.png');
[imgCoin, pm, alphaCoin] = imread('images/coin.png');
[imgMonster, pm, alphaMonster] = imread('images/m1.png');

grassColor = [0 153/255 51/255];
wallColor = [102/255 51/255 0];
coinColor = [255/255 255/255 0];
pacmanColor = [0 102/255 255/255];
monsterDullColor = [204/255 0 204/255];
monsterSemiColor = [255/255 0 0];

fieldHeight = 75;
fieldWidth = 75;


[filename,pathname] = uigetfile('*.txt', 'Select file containing map');

game = Game(filename, 5, 5);

initializeGame(game);

arrayOfFields = gobjects(game.numberOfRows,game.numberOfColumns);
arrayOfCoins = gobjects(game.numberOfRows,game.numberOfColumns);
arrayOfPacman = gobjects(game.numberOfRows,game.numberOfColumns);
arrayOfMonsters = gobjects(game.numberOfRows,game.numberOfColumns);


[music1, music2] = audioread('sounds/music.mp3');
sound(music1, music2, 16);

[coin1, coin2] = audioread('sounds/coin.mp3');

initGraphic();

    function startLoop()
        aaa = 0;
        while true
            aaa = aaa + 1;
            if mod(aaa, 2000000) == 0
                
                %display('IT´S TIME!');
                
                movePacman(game);
                
                if isCoin(game, game.pacman.posX, game.pacman.posY) == true
                    sound(coin1, coin2, 16);
                    game.coins = game.coins + 1;
                    game.map(game.pacman.posY, game.pacman.posX) = '-';
                end
                
                moveMonsters(game);
                
                if isEnemy(game) == true
                    %death.play();
                    game.pacman.health = game.pacman.health - 1;
                    %display('ZIVOT');
                end
                refreshGraphic();
            end
        end
    end

    function initGraphic()
        fullHeight = game.numberOfRows * fieldHeight;
        fullWidth = game.numberOfColumns * fieldWidth;
        
        figSize = [fullWidth, fullHeight];
        dispSize = get(0, 'ScreenSize');
        figHndl = figure('pos',[(dispSize(3)-figSize(1))/2 (dispSize(4)-figSize(2))/2 figSize(1) figSize(2)]);
        figHndl.Units = 'pixels';
        figHndl.Name = 'Pacman';
        figHndl.NumberTitle = 'off';
        figHndl.Tag = 'figure';
        figHndl.MenuBar = 'none';
        
        figHndl.Resize = 'off';
        
        for r = 1:game.numberOfRows
            for c = 1:game.numberOfColumns
                tag = "field"+r+"_"+c;
                positionX = (c-1)*fieldWidth;
                positionY = fullHeight-(r-1)*fieldHeight-fieldHeight;
                
                brickS = false;
                coinS = false;
                monsterS = false;
                pacmanS = false;
                
                if game.map(r,c) == 'X'
                    brickS = true;
                end
                
                if game.map(r,c) == 'C'
                    coinS = true;
                end
                
                if (game.pacman.posX == c) && (game.pacman.posY == r)
                    pacmanS = true;
                end
                
                for m = 1:game.numberOfMonsters
                    if (game.monsters(m).posX == c) && (game.monsters(m).posY == r)
                        monsterS = true;
                    end
                end
                
                uip = uipanel('Units', 'Pixels',...
                    'Position', [positionX positionY fieldWidth fieldHeight],...
                    'Tag',tag);
                
                arrayOfFields(r, c) = uip;
                
                if brickS
                    set(uip, 'BackgroundColor', wallColor);
                else
                    set(uip, 'BackgroundColor', grassColor);
                end
                
                if coinS
                    tag = "coin"+r+"_"+c;
                    ui = uipanel(uip, 'units','normalized', 'position', [0.4 0.4 0.2 0.2], 'BackgroundColor', coinColor, 'Tag', tag);
                    arrayOfCoins(r, c) = ui;
                end
                
                if pacmanS
                    tag = "pacman"+r+"_"+c;
                    ui = uipanel(uip, 'units','normalized', 'position', [0.05 0.05 0.9 0.9], 'BackgroundColor', pacmanColor, 'Tag', tag);
                    
                    arrayOfPacman(r, c) = ui;
                end
                
                if monsterS
                    tag = "monster"+r+"_"+c;
                    ui = uipanel(uip, 'units','normalized', 'position', [0.1 0.1 0.8 0.8], 'BackgroundColor', monsterDullColor, 'Tag', tag);
                    
                    arrayOfMonsters(r, c) = ui;
                end
            end
            drawnow;
        end
        
        figHndl.WindowKeyPressFcn = @keyPress;
        figHndl.CloseRequestFcn = {@closeWindow};
    end

    function closeWindow(scr, event)
        delete(gcf);
    end

    function keyPress(src, event)
        display(event.Key);
        switch event.Key
            case 'space'
                startLoop();
            case 'uparrow'
                game.pacman.direction = 1;
            case 'rightarrow'
                game.pacman.direction = 2;
            case 'downarrow'
                game.pacman.direction = 3;
            case 'leftarrow'
                game.pacman.direction = 4;
        end
        display(game.pacman.direction);
    end

    function deletePanels()
        %display('DELETING');
        for r = 1:game.numberOfRows
            for c = 1:game.numberOfColumns
                delete(arrayOfCoins);
                delete(arrayOfMonsters);
                delete(arrayOfPacman);
            end
        end
        %display('DELETE DONE');
    end

    function refreshGraphic()
        
        deletePanels();
        
        for r = 1:game.numberOfRows
            for c = 1:game.numberOfColumns
                %brickS = false;
                coinS = false;
                monsterS = false;
                pacmanS = false;
                
                %                 if game.map(r,c) == 'X'
                %                     brickS = true;
                %                 end
                
                if game.map(r,c) == 'C'
                    coinS = true;
                end
                
                if (game.pacman.posX == c) && (game.pacman.posY == r)
                    pacmanS = true;
                end
                
                for m = 1:game.numberOfMonsters
                    if (game.monsters(m).posX == c) && (game.monsters(m).posY == r)
                        monsterS = true;
                    end
                end
                
                uip = arrayOfFields(r, c);
                
                if coinS
                    tag = "coin"+r+"_"+c;
                    ui = uipanel(uip, 'units','normalized', 'position', [0.4 0.4 0.2 0.2], 'BackgroundColor', coinColor, 'Tag', tag);
                    arrayOfCoins(r, c) = ui;
                end
                
                if pacmanS
                    tag = "pacman"+r+"_"+c;
                    ui = uipanel(uip, 'units','normalized', 'position', [0.05 0.05 0.9 0.9], 'BackgroundColor', pacmanColor, 'Tag', tag);
                    
                    arrayOfPacman(r, c) = ui;
                end
                
                if monsterS
                    tag = "monster"+r+"_"+c;
                    ui = uipanel(uip, 'units','normalized', 'position', [0.1 0.1 0.8 0.8], 'BackgroundColor', monsterDullColor, 'Tag', tag);
                    
                    arrayOfMonsters(r, c) = ui;
                end
            end
        end
        drawnow;
    end
end