--Variables

local startPosX = 1;
local startPosZ = 1;

local dropZoneX = 0;
local dropZoneZ = 0;

local posX = 0;
local posZ = 0;

function fuel() --Method for fueling
    turtle.select(1);
    if turtle.refuel(1) then        
        print("Fueling succeeded!");
    else
        print("No sufficient fuel available!");
    end
end


function dropItems() --Method for dropping items
    turtle.select(2);
    while turtle.getItemCount(2) > 16 do
        turtle.dropDown(1);
    end

    for i = 3, 16, 1 do
        turtle.select(i);
        turtle.dropDown(turtle.getItemCount(i) - 1);
    end

    turtle.turnRight(); turtle.turnRight(); 

    debugInfo();
    sleep(300);

end


function startFromDropZone() --Method for starting from drop zone
    --start form drop zone
    if posX == 0 and posZ == 0 then
        turtle.forward();
        turtle.turnLeft();
        posX = posX + 1;
        posZ = posZ + 1;
    end
end


function debugInfo() --Method for displaying debug info
    --Debug info
    shell.run("clear")
    print("Position X: ", posX);
    print("Position Z: ", posZ, "\n");
    print("Fuel: ", turtle.getFuelLevel(), " L");
end


while true do  
        
    debugInfo();

    --Refuel if empty
    if turtle.getFuelLevel() == 0 then     
        if turtle.getItemCount(1) > 1 then
            fuel();
        else
            print("No sufficient fuel available!");
            sleep(0);
        end  
    else        
        --Select seed
        turtle.select(2);

        startFromDropZone();

        --Check if there is plant below
        local success, plant = turtle.inspectDown();

        if success then
            print("Plant name: ", string.sub(plant.name, 11, 15));
            
            --Check if plant is mature
            if plant.metadata == 7 then
                
                print("Ready to harvest! (", string.sub(plant.name, 11, 15), ")");                           

                --Break plant below
                turtle.digDown();                
                
                --Plant seed
                turtle.placeDown();

            end
        end

        --Go to drop zone if full
        if turtle.getItemCount(16) == 64 then
            if posZ % 2 == 1 then
              turtle.turnRight(); turtle.turnRight();                 
            end

            while posX ~= 1 do
                posX = posX - 1;
                turtle.forward();
            end

            while posZ ~= 0 do
                posZ = posZ - 1;
                turtle.forward();
            end

            posX = 0;

            dropItems();
        end

        --At the end go back to drop zone, sleep for <time> sec and try again
        if posX == 1 and posZ == 14 then
            turtle.turnRight();

            while posZ ~= 0 do
                posZ = posZ - 1;
                turtle.forward();
            end

            posX = 0;

            dropItems();
        end


        --Move turtle
        if posX ~= 0 and posZ ~= 0 and not turtle.forward() then                       

            local success, block = turtle.inspect();
            
            --Check block in front
            if success and block.name == "minecraft:stone" then
                turtle.turnRight(); --if stone turn right
                turtle.forward(); --then move forward to next row
                turtle.turnRight();
                posZ = posZ + 1;
            elseif success and block.name == "minecraft:glass" then
                turtle.turnLeft(); --if glass turn left
                turtle.forward(); --then move forward to next row
                turtle.turnLeft();
                posZ = posZ + 1;
            end
        elseif posX ~= 0 and posZ ~= 0 then
            --location on X
            if posZ % 2 == 0 then
                posX = posX - 1;
            else
                posX = posX + 1;
            end
        end   

    end
end