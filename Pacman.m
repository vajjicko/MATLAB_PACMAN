classdef Pacman < handle
    properties
        initX
        initY
        posX
        posY
        direction
        health
    end
    methods
        function obj = Pacman(x, y, health)
            obj.posX = x;
            obj.posY = y;
            obj.direction = 0;
            obj.health = health;
        end
        
        function setDirection(obj,x,y)
            obj.dirX = x;
            obj.dirY = y;
        end
        
        function pacmanMove(obj, up, right, down, left)
            %1 - up
            %2 - right
            %3 - down
            %4 - left
            switch obj.direction
                case 1
                    if up == true
                        obj.posY = obj.posY - 1;
                    end
                case 2
                    if right == true
                        obj.posX = obj.posX + 1;
                    end
                case 3
                    if down == true
                        obj.posY = obj.posY + 1;
                    end
                case 4
                    if left == true
                        obj.posX = obj.posX - 1;
                    end
            end
        end
        
        function reset(obj)
            obj.posX = obj.initX;
            obj.posY = obj.initY;
            obj.direction = 0;
        end
    end
end