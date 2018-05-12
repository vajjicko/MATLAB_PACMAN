function MAIN
close all;
clear;
clc;

%profile on

imgMenu = imread('images/menu.png');
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

fieldHeight = 30;
fieldWidth = 30;

game = 0;
map = 0;
difficulty = 0;

fullHeight = 0;
fullWidth = 0;

arrayOfFields = 0;
arrayOfCoins = 0;
arrayOfPacman = 0;
arrayOfMonsters = 0;

[music1, music2] = audioread('sounds/music.mp3');
[coin1, coin2] = audioread('sounds/coin.mp3');
[death1, death2] = audioread('sounds/death.mp3');

mapLoaded = false;
gameLoaded = false;
gameStarted = false;
gamePaused = false;
gameOver = false;
musicStatus = false;
soundsStatus = false;
timerLoaded = false;


thisTimer = 0;

buildMenu();

%% MENU

    function buildMenu()
        
        menuWidth = 400;
        menuHeight = 600;
        
        figSize = [menuWidth, menuHeight];
        dispSize = get(0, 'ScreenSize');
        figHndl = figure('pos',[(dispSize(3)-figSize(1))/2 (dispSize(4)-figSize(2))/2 figSize(1) figSize(2)]);
        figHndl.Units = 'pixels';
        figHndl.Name = 'Pacman Menu';
        figHndl.NumberTitle = 'off';
        figHndl.Tag = 'menu';
        figHndl.MenuBar = 'none';
        
        figHndl.Resize = 'off';
        
        ha = subplot(1,1,1);
        uistack(ha,'down');
        
        imagesc(imgMenu);
        set(ha,'handlevisibility','off','visible','off', 'Units', 'Normalized', 'Position', [0 0 1.0 1.0]);
        
        backgroundColor = 'black';
        backgroundColorTitle = 'black';
        foregroundColorTitle = 'white';
        
        set(figHndl,'color',backgroundColor);
        
        mapPanel = uipanel('Units', 'Pixels',...
            'Position', [0 300 menuWidth 100],...
            'BackgroundColor', backgroundColorTitle, ...
            'Tag','mapPanel');
        
        mapTitle = uicontrol(mapPanel,'Units','Pixels',...
            'Style', 'Text', ...
            'BackgroundColor', backgroundColorTitle, ...
            'ForegroundColor', foregroundColorTitle, ...
            'FontSize', 13, ...
            'FontWeight', 'bold', ...
            'Position', [0 65 menuWidth 30],...
            'Tag','mapTitle',...
            'String','MAPA');
        
        mapButton = uicontrol(mapPanel,'Units','Pixels',...
            'Style', 'Pushbutton', ...
            'FontSize', 10, ...
            'FontWeight', 'bold', ...
            'Position', [0 10 menuWidth/2 50],...
            'Tag','mapTitle',...
            'String','Zvolit mapu');
        
        mapStatus = uicontrol(mapPanel,'Units','Pixels',...
            'Style', 'Text', ...
            'BackgroundColor', backgroundColorTitle, ...
            'ForegroundColor', 'red', ...
            'FontSize', 10, ...
            'FontWeight', 'bold', ...
            'Position', [menuWidth/2 10 menuWidth/2 50],...
            'Tag','mapStatus',...
            'String','Není naètena žádná mapa!');
        
        difficultyPanel = uipanel('Units', 'Pixels',...
            'Position', [0 100 menuWidth 200],...
            'BackgroundColor', backgroundColorTitle, ...
            'Tag','difficultyPanel');
        
        difficultyTitle = uicontrol(difficultyPanel,'Units','Pixels',...
            'Style', 'Text', ...
            'BackgroundColor', backgroundColorTitle, ...
            'ForegroundColor', foregroundColorTitle, ...
            'FontSize', 13, ...
            'FontWeight', 'bold', ...
            'Position', [0 165 menuWidth 30],...
            'Tag','difficultyTitle',...
            'String','OBTÍŽNOST');
        
        difficultyRadioGroup = uibuttongroup(difficultyPanel,...
            'Visible','on',...
            'BackgroundColor', backgroundColorTitle, ...
            'Units','Pixels',...
            'Position',[0 0 menuWidth 170],...
            'Tag', 'difficultyRadioGroup', ...
            'SelectionChangedFcn',@radioButtonSelection);
        
        easyDifficultyRadio = uicontrol(difficultyRadioGroup,'Units','Pixels',...
            'Style', 'Radiobutton', ...
            'BackgroundColor', backgroundColorTitle, ...
            'ForegroundColor', foregroundColorTitle, ...
            'FontSize', 13, ...
            'FontWeight', 'bold', ...
            'Position', [0 145 menuWidth/2 25],...
            'Tag','easyDifficultyRadio',...
            'String','snadná',...
            'HandleVisibility','off');
        
        mediumDifficultyRadio = uicontrol(difficultyRadioGroup,'Units','Pixels',...
            'Style', 'Radiobutton', ...
            'BackgroundColor', backgroundColorTitle, ...
            'ForegroundColor', foregroundColorTitle, ...
            'FontSize', 13, ...
            'FontWeight', 'bold', ...
            'Position', [0 115 menuWidth/2 25],...
            'Tag','easyDifficultyRadio',...
            'String','støední',...
            'HandleVisibility','off');
        
        hardDifficultyRadio = uicontrol(difficultyRadioGroup,'Units','Pixels',...
            'Style', 'Radiobutton', ...
            'BackgroundColor', backgroundColorTitle, ...
            'ForegroundColor', foregroundColorTitle, ...
            'FontSize', 13, ...
            'FontWeight', 'bold', ...
            'Position', [menuWidth/2 145 menuWidth/2 25],...
            'Tag','easyDifficultyRadio',...
            'String','tìžká',...
            'HandleVisibility','off');
        
        extremeDifficultyRadio = uicontrol(difficultyRadioGroup,'Units','Pixels',...
            'Style', 'Radiobutton', ...
            'BackgroundColor', backgroundColorTitle, ...
            'ForegroundColor', foregroundColorTitle, ...
            'FontSize', 13, ...
            'FontWeight', 'bold', ...
            'Position', [menuWidth/2 115 menuWidth/2 25],...
            'Tag','easyDifficultyRadio',...
            'String','extrémní',...
            'HandleVisibility','off');
        
        musicButton = uicontrol('Units','Pixels',...
            'Style', 'Pushbutton', ...
            'BackgroundColor', 'red', ...
            'ForegroundColor', 'black', ...
            'FontSize', 10, ...
            'FontWeight', 'bold', ...
            'Position', [30 45 150 50],...
            'Tag','musicButton',...
            'String','Hudba');
        
        soundButton = uicontrol('Units','Pixels',...
            'Style', 'Pushbutton', ...
            'BackgroundColor', 'red', ...
            'ForegroundColor', 'black', ...
            'FontSize', 10, ...
            'FontWeight', 'bold', ...
            'Position', [220 45 150 50],...
            'Tag','soundButton',...
            'String','Zvuky');
        
        startButton = uicontrol('Units','Pixels',...
            'Style', 'Pushbutton', ...
            'FontSize', 20, ...
            'FontWeight', 'bold', ...
            'Position', [0 0 menuWidth 40],...
            'Tag','startButton',...
            'String','START',...
            'Enable', 'off');
        
        startButton.Callback = @pressStartButton;
        mapButton.Callback = @pressLoadMapButton;
        musicButton.Callback = @pressMusicButton;
        soundButton.Callback = @pressSoundButton;
    end

    function radioButtonSelection(source,event)
        switch event.NewValue.String
            case 'snadná'
                difficulty = 0;
            case 'støední'
                difficulty = 1;
            case 'tìžká'
                difficulty = 2;
            case 'extrémní'
                difficulty = 3;
        end
    end

    function pressStartButton(src, event)
        if(gameLoaded == true)
            warndlg('Hra již bìží!', ...
                'Chyba', 'modal');
        else
            gameLoaded = true;
            startGame();
        end
    end

    function pressMusicButton(src, event)
        if(musicStatus == true)
            musicStatus = false;
            set(findobj('Style','pushbutton','-and','Tag','musicButton'), 'BackgroundColor', 'red');
        else
            musicStatus = true;
            set(findobj('Style','pushbutton','-and','Tag','musicButton'), 'BackgroundColor', 'green');
        end
    end

    function pressSoundButton(src, event)
        if(soundsStatus == true)
            soundsStatus = false;
            set(findobj('Style','pushbutton','-and','Tag','soundButton'), 'BackgroundColor', 'red');
        else
            soundsStatus = true;
            set(findobj('Style','pushbutton','-and','Tag','soundButton'), 'BackgroundColor', 'green');
        end
    end

    function loadMap(filename)
        inputMap = dlmread(filename,' ');
        map = prepareMap(inputMap);
    end

    function map = prepareMap(inputMap)
        numberOfRows = size(inputMap,1);
        numberOfColumns = size(inputMap,2);
        
        for r = 1:numberOfRows
            for c = 1:numberOfColumns
                if inputMap(r,c) == 1
                    map(r,c) = 'X';
                else
                    map(r,c) = 'C';
                end
            end
        end
    end

    function validMap = checkMapValidity()
        validMap = true;
    end

    function pressLoadMapButton(src, event)
        [filename,pathname] = uigetfile('*.txt', 'Select file containing map');
        
        loadMap(filename);
        
        if(checkMapValidity() == true)
            mapLoaded = true;
            set(findobj('Style','text','-and','Tag','mapStatus'), 'String', 'Mapa naètena','ForegroundColor', 'green');
            set(findobj('Style','pushbutton','-and','Tag','startButton'), 'Enable', 'on');
        else
            set(findobj('Style','text','-and','Tag','mapStatus'), 'String', 'Není naètena žádná mapa!','ForegroundColor', 'red');
            set(findobj('Style','pushbutton','-and','Tag','startButton'), 'Enable', 'off');
            warndlg('Vstupní soubor neobsahuje validní mapu!', ...
                'Chyba', 'modal');
        end
    end

    function startGame()
        
        switch difficulty
            case 0
                game = Game(map, 5, 2);
            case 1
                game = Game(map, 5, 5);
            case 2
                game = Game(map, 3, 5);
            case 3
                game = Game(map, 3, 7);
        end        

        initializeGame(game);
        
        fullHeight = game.numberOfRows * fieldHeight;
        fullWidth = game.numberOfColumns * fieldWidth;
        
        arrayOfFields = gobjects(game.numberOfRows,game.numberOfColumns);
        arrayOfCoins = gobjects(game.numberOfRows,game.numberOfColumns);
        arrayOfPacman = gobjects(1);
        arrayOfMonsters = gobjects(game.numberOfMonsters);
        
        initGraphic();
        
        if(musicStatus)
            sound(music1, music2, 16);
        end
    end

%% GAME LOOP

    function timer_update(myTimer, ~)
        
        movePacman(game);
        
        if isCoin(game, game.pacman.posX, game.pacman.posY) == true
            
            if(soundsStatus)
                sound(coin1, coin2, 16);
            end
            
            game.coins = game.coins + 1;
            game.map(game.pacman.posY, game.pacman.posX) = '-';
        end
        
        moveMonsters(game);
        
        if isEnemy(game) == true
            if(soundsStatus)
                sound(death1, death2, 16);
            end
            
            game.pacman.health = game.pacman.health - 1;
        end
        refreshGraphic();
    end

    function startLoop()
        thisTimer = timer;
        thisTimer.StartDelay = 1;
        thisTimer.Period = 0.2;
        thisTimer.ExecutionMode = 'fixedSpacing';
        thisTimer.TimerFcn = {@timer_update};
        start(thisTimer);
        timerLoaded = true;
    end

%% INIT GRAPHIC

    function initHeaderGraphic()
        headerPanel = uipanel('Units', 'Pixels',...
            'Position', [0 fullHeight fullWidth 50],...
            'BackgroundColor', 'black', ...
            'Tag','header');
        
        pointsLabel = uicontrol(headerPanel,'Units','Normalized',...
            'Style', 'Text', ...
            'FontSize', 30, ...
            'FontWeight', 'bold', ...
            'Position', [0.45 0.0 0.1 1],...
            'BackgroundColor', 'black', ...
            'ForegroundColor', 'white', ...
            'Tag','pointsValueLabel',...
            'String','0');
        
        health = char(9829);
        hL = '';
        
        for index = 1:game.pacman.health
            hL = strcat(hL,health);
        end
        
        healthLabel = uicontrol(headerPanel,'Units','Normalized',...
            'Style', 'Text', ...
            'HorizontalAlignment', 'left', ...
            'FontSize', 30, ...
            'FontWeight', 'bold', ...
            'Position', [0.0 0.0 0.4 1],...
            'BackgroundColor', 'black', ...
            'ForegroundColor', 'red', ...
            'Tag','healthLabel',...
            'String',hL);
    end

    function initBackgroundAndCoinsGraphic()
        for r = 1:game.numberOfRows
            for c = 1:game.numberOfColumns
                tag = "field"+r+"_"+c;
                positionX = (c-1)*fieldWidth;
                positionY = fullHeight-(r-1)*fieldHeight-fieldHeight;
                
                brickS = false;
                coinS = false;
                
                if game.map(r,c) == 'X'
                    brickS = true;
                end
                
                if game.map(r,c) == 'C'
                    coinS = true;
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
            end
        end
        drawnow;
    end

    function initMonsterGraphic()
        
        for monsterIndex = 1:game.numberOfMonsters
            
            posX = game.monsters(monsterIndex).posX;
            posY = game.monsters(monsterIndex).posY;
            
            tag = "monster_"+monsterIndex;
            
            position = [(posX-1)*fieldWidth fullHeight-(posY-1)*fieldHeight-fieldHeight fieldWidth fieldHeight];
            
            uip = uipanel('Units', 'Pixels',...
                'Position', position,...
                'BackgroundColor', grassColor,...
                'Tag',tag);
            
            ha = axes(uip, 'units','normalized', 'position', [0 0 1 1]);
            uistack(ha,'top');
            
            imagesc(imgMonster, 'AlphaData', alphaMonster);
            set(ha,'handlevisibility','off','visible','off');
            
            arrayOfMonsters(monsterIndex) = uip;
        end
    end

    function initPacmanGraphic()
        
        tag = 'pacman';
        
        uip = uipanel('Units', 'Pixels',...
            'Position', [(game.pacman.posX-1)*fieldWidth fullHeight-(game.pacman.posY-1)*fieldHeight-fieldHeight fieldWidth fieldHeight],...
            'BackgroundColor', grassColor,...
            'Tag',tag);
        
        ha = axes(uip, 'units','normalized', 'position', [0 0 1 1]);
        uistack(ha,'top');
        
        imagesc(imgPacman, 'AlphaData', alphaPacman);
        set(ha,'handlevisibility','off','visible','off');
        
        arrayOfPacman(1) = uip;
    end

    function initGraphic()
        
        figSize = [fullWidth, fullHeight+50];
        dispSize = get(0, 'ScreenSize');
        figHndl = figure('pos',[(dispSize(3)-figSize(1))/2 (dispSize(4)-figSize(2))/2 figSize(1) figSize(2)]);
        figHndl.Units = 'pixels';
        figHndl.Name = 'Pacman';
        figHndl.NumberTitle = 'off';
        figHndl.Tag = 'figure';
        figHndl.MenuBar = 'none';
        figHndl.Resize = 'off';
        
        initHeaderGraphic();
        drawnow;
        initBackgroundAndCoinsGraphic();
        drawnow;
        initMonsterGraphic();
        drawnow;
        initPacmanGraphic();
        drawnow;
        
        figHndl.WindowKeyPressFcn = @keyPress;
        figHndl.CloseRequestFcn = {@closeWindow};
    end

%% CALLBACKS

    function closeWindow(scr, event)
        gameLoaded = false;
        if(timerLoaded == true)
            stop(thisTimer);
        end
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


%% REFRESH GRAPHIC

    function refreshPointsGraphic()
        set(findobj('Style','text','-and','Tag','pointsValueLabel'), 'String', game.coins);
    end

    function refreshHealthGraphic()
        hearthChar = char(9829);
        hL = '';
        
        for index = 1:game.pacman.health
            hL = strcat(hL,hearthChar);
        end
        
        set(findobj('Style','text','-and','Tag','healthLabel'), 'String', hL);
    end

    function refreshPacmanGraphic()
        set(arrayOfPacman(1), 'Position', [(game.pacman.posX-1)*fieldWidth fullHeight-(game.pacman.posY-1)*fieldHeight-fieldHeight fieldWidth fieldHeight]);
    end

    function refreshMonstersGraphic()
        for monsterIndex = 1:game.numberOfMonsters
            
            posX = game.monsters(monsterIndex).posX;
            posY = game.monsters(monsterIndex).posY;
            
            position = [(posX-1)*fieldWidth fullHeight-(posY-1)*fieldHeight-fieldHeight fieldWidth fieldHeight];
            
            set(arrayOfMonsters(monsterIndex), 'Position', position);
        end
    end

    function refreshCoinsGraphic()
        for r = 1:game.numberOfRows
            for c = 1:game.numberOfColumns
                coinS = false;
                
                if game.map(r,c) == 'C'
                    coinS = true;
                end
                
                uip = arrayOfFields(r, c);
                
                if coinS
                    tag = "coin"+r+"_"+c;
                    ui = uipanel(uip, 'units','normalized', 'position', [0.4 0.4 0.2 0.2], 'BackgroundColor', coinColor, 'Tag', tag);
                    arrayOfCoins(r, c) = ui;
                end
            end
        end
    end

    function refreshGraphic()
        
        delete(arrayOfCoins);
        
        refreshHealthGraphic();
        refreshPointsGraphic();
        refreshPacmanGraphic();
        refreshMonstersGraphic();
        refreshCoinsGraphic();
        
        drawnow;
    end
end