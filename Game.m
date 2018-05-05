classdef Game < handle
    properties
        health
        mapFile
        map
        numberOfRows
        numberOfColumns
        pacman
        coins
        numberOfMonsters
        monsters
    end
    
    methods
        function obj = Game(mapFile, health, numberOfMonsters)
            obj.mapFile = mapFile;
            obj.health = health;
            obj.numberOfMonsters = numberOfMonsters;
        end
        
        function initializeGame(obj)
            obj.coins = 0;
            
            loadMap(obj);
            
            obj.pacman = initializePacman(obj);
            
            obj.monsters = initializeMonsters(obj);
        end
        
        function loadMap(obj)
            inputMap = dlmread(obj.mapFile,' ');
            
            obj.numberOfRows = size(inputMap,1);
            obj.numberOfColumns = size(inputMap,2);
            
            obj.map = prepareMap(obj, inputMap);
        end
        
        function map = prepareMap(obj, inputMap)
            map = char(obj.numberOfRows, obj.numberOfColumns);
            
            for r = 1:obj.numberOfRows
                for c = 1:obj.numberOfColumns
                    if inputMap(r,c) == 1
                        map(r,c) = 'X';
                    else
                        map(r,c) = 'C';
                    end
                end
            end
        end
        
        function pacman = initializePacman(obj)
            coordinates = generateRandomCoordinates(obj);
            
            while isWall(obj, coordinates(1),coordinates(2)) == true
                coordinates = generateRandomCoordinates(obj);
            end
            
            pacman = Pacman(coordinates(1),coordinates(2),obj.health);
            obj.map(coordinates(2),coordinates(1)) = '-';
        end
        
        function monsters = initializeMonsters(obj)
            for m = 1:obj.numberOfMonsters
                coordinates = generateMonsterCoordinates(obj);
                while isWall(obj, coordinates(1),coordinates(2)) == true
                    coordinates = generateMonsterCoordinates(obj);
                end
                
                monsters(m) = MonsterDull(coordinates(1), coordinates(2));
            end
        end
        
        function status = isWall(obj,x,y)
            if obj.map(y,x) == 'X'
                status = true;
            else
                status = false;
            end
        end
        
        function status = isCoin(obj,x,y)
            if obj.map(y,x) == 'C'
                status = true;
            else
                status = false;
            end
        end
        
        function status = isEnemy(obj)
            for m = 1:obj.numberOfMonsters
                if (obj.pacman.posX == obj.monsters(m).posX) && (obj.pacman.posY == obj.monsters(m).posY)
                    status = true;
                    return;
                end
                %switch x places MONSTER/PACMAN => PACMAN/MONSTER
                if (obj.pacman.posX - obj.monsters(m).posX == -1) && (obj.pacman.posY == obj.monsters(m).posY) && (obj.monsters(m).direction == 2) && (obj.pacman.direction == 4)
                    status = true;
                    return;
                end
                %switch x places PACMAN/MONSTER => MONSTER/PACMAN
                if (obj.pacman.posX - obj.monsters(m).posX == 1) && (obj.pacman.posY == obj.monsters(m).posY) && (obj.monsters(m).direction == 4) && (obj.pacman.direction == 2)
                    status = true;
                    return;
                end
                %switch y places MONSTER/PACMAN => PACMAN/MONSTER
                if (obj.pacman.posY - obj.monsters(m).posY == -1) && (obj.pacman.posX == obj.monsters(m).posX) && (obj.monsters(m).direction == 3) && (obj.pacman.direction == 1)
                    status = true;
                    return;
                end
                %switch y places PACMAN/MONSTER => MONSTER/PACMAN
                if (obj.pacman.posY - obj.monsters(m).posY == 1) && (obj.pacman.posX == obj.monsters(m).posX) && (obj.monsters(m).direction == 1) && (obj.pacman.direction == 3)
                    status = true;
                    return;
                end
                
                status = false;
            end
        end
        
        function coord = generateRandomCoordinates(obj)
            xMin = 2;
            xMax = obj.numberOfColumns-1;
            
            yMin = 2;
            yMax = obj.numberOfRows-1;
            
            x = floor(xMin+rand(1)*(xMax-xMin));
            y = floor(yMin+rand(1)*(yMax-yMin));
            coord(1) = x;
            coord(2) = y;
        end
        
        function coord = generateMonsterCoordinates(obj)
            while true
                xMin = 2;
                xMax = obj.numberOfColumns-1;
                
                yMin = 2;
                yMax = obj.numberOfRows-1;
                
                x = floor(xMin+rand(1)*(xMax-xMin));
                y = floor(yMin+rand(1)*(yMax-yMin));
                
                if obj.map(y, x) == 'X'
                    continue;
                end
                
                if (x == obj.pacman.posX) && (y == obj.pacman.posY)
                    continue;
                end
                
                coord(1) = x;
                coord(2) = y;
                break;
            end
        end
        
        function movePacman(obj)
            upAvailable = false;
            rightAvailable = false;
            downAvailable = false;
            leftAvailable = false;
            
            if isWall(obj, obj.pacman.posX-1, obj.pacman.posY) == false
                leftAvailable = true;
            end
            if isWall(obj, obj.pacman.posX+1, obj.pacman.posY) == false
                rightAvailable = true;
            end
            if isWall(obj, obj.pacman.posX, obj.pacman.posY+1) == false
                downAvailable = true;
            end
            if isWall(obj, obj.pacman.posX, obj.pacman.posY-1) == false
                upAvailable = true;
            end
            
            pacmanMove(obj.pacman, upAvailable, rightAvailable, downAvailable, leftAvailable);
        end
        
        function moveMonsters(obj)
            for m = 1:obj.numberOfMonsters
                upAvailable = false;
                rightAvailable = false;
                downAvailable = false;
                leftAvailable = false;
                
                if isWall(obj, obj.monsters(m).posX-1, obj.monsters(m).posY) == false
                    leftAvailable = true;
                end
                if isWall(obj, obj.monsters(m).posX+1, obj.monsters(m).posY) == false
                    rightAvailable = true;
                end
                if isWall(obj, obj.monsters(m).posX, obj.monsters(m).posY+1) == false
                    downAvailable = true;
                end
                if isWall(obj, obj.monsters(m).posX, obj.monsters(m).posY-1) == false
                    upAvailable = true;
                end
                
                monsterMove(obj.monsters(m), upAvailable, rightAvailable, downAvailable, leftAvailable, 0);
            end
        end        
    end
end