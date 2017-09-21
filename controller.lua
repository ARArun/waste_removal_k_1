--------------------------------------------------------------------------------
--------------------------------Foraging----------------------------------------
--------------------------------------------------------------------------------
count_time = 0
--------------------------------------------------------------------------------
-----------------------------Function Init--------------------------------------
--------------------------------------------------------------------------------
function init()
    state = "roam"
    prev_state = "dummy"
    robot.colored_blob_omnidirectional_camera.enable()
    robot.turret.set_position_control_mode()
end
--------------------------------------------------------------------------------
----------------------------Function Step---------------------------------------
--------------------------------------------------------------------------------
function step()
    if state ~= prev_state then
        log(state)
    end
    if state == "roam" then
        roam()
    elseif state == "choose" then
        choose()
    end
end
--------------------------------------------------------------------------------
-----------------------------Reset & Destroy------------------------------------
--------------------------------------------------------------------------------
function reset()
    init()
end

function destroy()

end
--------------------------------------------------------------------------------
--------------------------------Roam State--------------------------------------
--------------------------------------------------------------------------------
function roam()
    sensingLeft =     robot.proximity[3].value +
                      robot.proximity[4].value +
                      robot.proximity[5].value +
                      robot.proximity[6].value +
                      robot.proximity[2].value +
                      robot.proximity[1].value

    sensingRight =    robot.proximity[19].value +
                      robot.proximity[20].value +
                      robot.proximity[21].value +
                      robot.proximity[22].value +
                      robot.proximity[24].value +
                      robot.proximity[23].value
    if #robot.colored_blob_omnidirectional_camera >= 1 then
        state = "choose"
    elseif sensingLeft ~= 0 then
        robot.wheels.set_velocity(7,3)
    elseif sensingRight ~= 0 then
        robot.wheels.set_velocity(3,7)
    elseif robot.motor_ground[1].value < 0.40 then
        robot.wheels.set_velocity(7,3)
    elseif robot.motor_ground[4].value < 0.40 then
        robot.wheels.set_velocity(3,7)
    else
        robot.wheels.set_velocity(10,10)
    end
end
--------------------------------------------------------------------------------
--------------------------Function Choose---------------------------------------
--------We choose the nearest obstacle and orient our robot towards it----------
--------------------------------------------------------------------------------
function choose()

    robot.wheels.set_velocity(0,0)
    dist = robot.colored_blob_omnidirectional_camera[1].distance
    ang =  robot.colored_blob_omnidirectional_camera[1].angle

    for i = 1, #robot.colored_blob_omnidirectional_camera do

        if dist > robot.colored_blob_omnidirectional_camera[i].distance then
            dist = robot.colored_blob_omnidirectional_camera[i].distance
            ang = robot.colored_blob_omnidirectional_camera[i].angle
        end

    end

    if ang > 0.1 then
        robot.wheels.set_velocity(-1,1)
    elseif ang < -0.1 then
        robot.wheels.set_velocity(1,-1)
    elseif ang >= -0.1 and ang <= 0.1 then
        state = "approach"
    end

end
--------------------------------------------------------------------------------
