-- name: Go Commit Dive
-- incompatible: moveset
-- description: Press A to dive.

timerj = 60

--function mario_on_set_action(m)
    -- fjldkghssdfl;
--end

function mario_physicnt(m)
    if (m.input & INPUT_A_PRESSED) ~= 0 then
        if (m.action & ACT_GROUP_MASK) ~= ACT_GROUP_SUBMERGED then
            set_mario_action(m, ACT_DIVE, 0)
        end
        timerj=60
        mario_set_forward_vel(m, 48)
    end
    if (m.action & ACT_GROUP_MASK) == ACT_GROUP_SUBMERGED then
        if timerj > 0 then
            set_mario_animation(m, MARIO_ANIM_DIVE)
        end
    end
    timerj = timerj - 1
end

--hook_event(HOOK_ON_SET_MARIO_ACTION, mario_on_set_action)
hook_event(HOOK_BEFORE_PHYS_STEP, mario_physicnt)