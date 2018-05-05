classdef Monster < handle
    properties
        posX
        posY
        type
        direction
    end
    methods
        function obj = Monster(x, y, type)
            obj.posX = x;
            obj.posY = y;
            obj.type = type;
            obj.direction = 0;
        end
    end
end