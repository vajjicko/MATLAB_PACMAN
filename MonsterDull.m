classdef MonsterDull < Monster
    properties
    end
    methods
        function obj = MonsterDull(x, y)
            obj@Monster(x, y, 1);
        end
        
        function monsterMove(obj, up, right, down, left, direction)
            while true
                random = floor(rand(1) * 3);
                
                switch random
                    case 0
                        if left == true
                            obj.direction = 4;
                            obj.posX = obj.posX - 1;
                            break;
                        end
                    case 1
                        if right == true
                            obj.direction = 2;
                            obj.posX = obj.posX + 1;
                            break;
                        end
                    case 2
                        if up == true
                            obj.direction = 1;
                            obj.posY = obj.posY - 1;
                            break;
                        end
                    case 3
                        if down == true
                            obj.direction = 3;
                            obj.posY = obj.posY + 1;
                            break;
                        end
                end
            end
        end
        
    end
end