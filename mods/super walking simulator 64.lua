-- name: Super Walking Simulator 64
-- incompatible: your mother
-- description: Disables all of the buttons, meaning that all you can do is walk.

function noButtons(m)
    m.controller.buttonPressed = 1
    m.controller.buttonDown = 1
end

hook_event(HOOK_BEFORE_MARIO_UPDATE, noButtons)