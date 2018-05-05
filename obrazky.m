    function gr()
        fullHeight = numberOfRows * fieldHeight;
        fullWidth = numberOfColumns * fieldWidth;
        
        figSize = [fullWidth, fullHeight];
        dispSize = get(0, 'ScreenSize');
        figHndl = figure('pos',[(dispSize(3)-figSize(1))/2 (dispSize(4)-figSize(2))/2 figSize(1) figSize(2)]);
        figHndl.Units = 'pixels';
        figHndl.Name = 'Pacman';
        figHndl.NumberTitle = 'off';
        figHndl.Tag = 'figure';
        figHndl.MenuBar = 'none';

        for r = 1:numberOfRows
            for c = 1:numberOfColumns
                tag = "field"+r+"_"+c;
                positionX = (c-1)*fieldWidth;
                positionY = fullHeight-(r-1)*fieldHeight-fieldHeight;
                
                brickS = false;
                coinS = false;
                monsterS = false;
                pacmanS = false;
                
                if map(r,c) == 'X'
                    brickS = true;
                end
                
                if map(r,c) == 'C'
                    coinS = true;
                end
                
                if (pacman.posX == c) && (pacman.posY == r)
                    pacmanS = true;
                end
                
                for m = 1:numberOfMonsters
                    if (monsters(m).posX == c) && (monsters(m).posY == r)
                        monsterS = true;
                    end
                end
%                 
%                 if brickS
%                     ha = subplot(1,1,1);
%                     imagesc(imgBricks);
%                     set(ha, 'handlevisibility','off','visible','off', 'Units','Pixels', 'Position', [positionX positionY fieldWidth fieldHeight], 'Tag',tag);
%                 else
%                     ha = subplot(1,1,1);
%                     imagesc(imgGrass);
%                     set(ha, 'handlevisibility','off','visible','off', 'Units','Pixels', 'Position', [positionX positionY fieldWidth fieldHeight], 'Tag',tag);
%                 end

                if coinS
                    ha = subplot(1,1,1);
                    uistack(ha,'up');
                    
                    imagesc(imgCoin, 'AlphaData', alphaCoin);
                    set(ha,'handlevisibility','off','visible','off', 'Units', 'Pixels', 'Position', [positionX+fieldWidth/4 positionY+fieldHeight/4 fieldWidth/2 fieldHeight/2]);
                end
                
                if pacmanS
                    ha = subplot(1,1,1);
                    uistack(ha,'up');
                    
                    imagesc(imgPacman, 'AlphaData', alphaPacman);
                    set(ha,'handlevisibility','off','visible','off', 'Units', 'Pixels', 'Position', [positionX positionY fieldWidth fieldHeight]);
                end
                
                if monsterS
                    ha = subplot(1,1,1);
                    uistack(ha,'up');
                    
                    imagesc(imgMonster, 'AlphaData', alphaMonster);
                    set(ha,'handlevisibility','off','visible','off', 'Units', 'Pixels', 'Position', [positionX positionY fieldWidth fieldHeight]);
                end
            end
        end        
    end

    function initGraphic()
        fullHeight = numberOfRows * fieldHeight;
        fullWidth = numberOfColumns * fieldWidth;
        
        figSize = [fullWidth, fullHeight];
        dispSize = get(0, 'ScreenSize');
        figHndl = figure('pos',[(dispSize(3)-figSize(1))/2 (dispSize(4)-figSize(2))/2 figSize(1) figSize(2)]);
        figHndl.Units = 'pixels';
        figHndl.Name = 'Pacman';
        figHndl.NumberTitle = 'off';
        figHndl.Tag = 'figure';
        figHndl.MenuBar = 'none';
        
        %arrayOfFields = gobjects(numberOfRows,numberOfColumns);        
        
        for r = 1:numberOfRows
            for c = 1:numberOfColumns
                tag = "field"+r+"_"+c;
                positionX = (c-1)*fieldWidth;
                positionY = fullHeight-(r-1)*fieldHeight-fieldHeight;
                
                brickS = false;
                coinS = false;
                monsterS = false;
                pacmanS = false;
                
                if map(r,c) == 'X'
                    brickS = true;
                end
                
                if map(r,c) == 'C'
                    coinS = true;
                end
                
                if (pacman.posX == c) && (pacman.posY == r)
                    pacmanS = true;
                end
                
                for m = 1:numberOfMonsters
                    if (monsters(m).posX == c) && (monsters(m).posY == r)
                        monsterS = true;
                    end
                end
                
                uip = uipanel('Units', 'Pixels',...
                    'Position', [positionX positionY fieldWidth fieldHeight],...
                    'Tag',tag);
                %arrayOfFields(r, c) = uip;
                
                ha = axes(uip, 'units','normalized', 'position', [0 0 1 1]);                
                uistack(ha,'bottom');
                
                if brickS
                    imagesc(imgBricks);
                else
                    imagesc(imgGrass);
                end
                
                set(ha,'handlevisibility','off','visible','off');

                if coinS
                    ha = axes(uip, 'units','normalized', 'position', [0.25 0.25 0.5 0.5]);
                    uistack(ha,'up');
                    
                    imagesc(imgCoin, 'AlphaData', alphaCoin);
                    set(ha,'handlevisibility','off','visible','off');
                end
                
                if pacmanS
                    ha = axes(uip, 'units','normalized', 'position', [0 0 1 1]);
                    uistack(ha,'up');
                    
                    imagesc(imgPacman, 'AlphaData', alphaPacman);
                    set(ha,'handlevisibility','off','visible','off');
                end
                
                if monsterS
                    ha = axes(uip, 'units','normalized', 'position', [0.1 0.1 0.8 0.8]);
                    uistack(ha,'up');

                    imagesc(imgMonster, 'AlphaData', alphaMonster);
                    set(ha,'handlevisibility','off','visible','off');
                end                
            end
        end
        drawnow;
    end
    
        function refreshGraphic()        
        display('REFRESH');
        %clf;
        
        fullHeight = numberOfRows * fieldHeight;
        fullWidth = numberOfColumns * fieldWidth;       
        
        for r = 1:numberOfRows
            for c = 1:numberOfColumns
                tag = "field"+r+"_"+c;
                positionX = (c-1)*fieldWidth;
                positionY = fullHeight-(r-1)*fieldHeight-fieldHeight;
                
                brickS = false;
                coinS = false;
                monsterS = false;
                pacmanS = false;
                
                if map(r,c) == 'X'
                    brickS = true;
                end
                
                if map(r,c) == 'C'
                    coinS = true;
                end
                
                if (pacman.posX == c) && (pacman.posY == r)
                    pacmanS = true;
                end
                
                for m = 1:numberOfMonsters
                    if (monsters(m).posX == c) && (monsters(m).posY == r)
                        monsterS = true;
                    end
                end
                
                uip = uipanel('Units', 'Pixels',...
                    'Position', [positionX positionY fieldWidth fieldHeight],...
                    'Tag',tag);
                %arrayOfFields(r, c) = uip;
                
                ha = axes(uip, 'units','normalized', 'position', [0 0 1 1]);
                uistack(ha,'bottom');
                
                if brickS
                    imagesc(imgBricks);
                else
                    imagesc(imgGrass);
                end
                
                set(ha,'handlevisibility','off','visible','off');
                
                if coinS
                    ha = axes(uip, 'units','normalized', 'position', [0.25 0.25 0.5 0.5]);
                    uistack(ha,'up');
                    
                    imagesc(imgCoin, 'AlphaData', alphaCoin);
                    set(ha,'handlevisibility','off','visible','off');
                end
                
                if pacmanS
                    ha = axes(uip, 'units','normalized', 'position', [0 0 1 1]);
                    uistack(ha,'up');
                    
                    imagesc(imgPacman, 'AlphaData', alphaPacman);
                    set(ha,'handlevisibility','off','visible','off');
                end
                
                if monsterS
                    ha = axes(uip, 'units','normalized', 'position', [0.1 0.1 0.8 0.8]);
                    uistack(ha,'up');
                    
                    imagesc(imgMonster, 'AlphaData', alphaMonster);
                    set(ha,'handlevisibility','off','visible','off');
                end
            end
        end
        display('REFRESH DONE');
        drawnow;
    end
