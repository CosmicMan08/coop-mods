shootSound = audio_sample_load("BlinxShoot.mp3")
E_MODEL_TIMESWEEPER = smlua_model_util_get_id("timesweeper_geo")

trashList = {}
sweeper = nil
timerSweep = 0

function shoot_trash()
    local m = gMarioStates[0]

    m.forwardVel = m.forwardVel / 2
    if tablelength(trashList) > 0 then
        trashBHV = trashList[tablelength(trashList)][1]
        trashModel = trashList[tablelength(trashList)][2]
        projectile = spawn_sync_object(
            id_bhvTrash,
            trashModel,
            m.pos.x, m.pos.y + 60, m.pos.z,
            function(o)
                o.oDamageOrCoinValue = 3
                if trashModel ~= E_MODEL_WOODEN_SIGNPOST and trashModel ~= E_MODEL_BUBBLY_TREE then
                    o.header.gfx.scale.x = 0.5
                    o.header.gfx.scale.y = 0.5
                    o.header.gfx.scale.z = 0.5
                end
                if trashModel == E_MODEL_BUBBLY_TREE then
                    obj_set_billboard(o)
                end
            end
        )
        table.remove(trashList)
    end
    timerSweep = 100
end

function suck_trash()
    local m = gMarioStates[0]

    m.forwardVel = m.forwardVel / 2
    if tablelength(trashList) < 5 then
        spawn_sync_object(
            id_bhvRay,
            E_MODEL_SMOKE,
            m.pos.x, m.pos.y + 60, m.pos.z,
            nil
        )
    end
    timerSweep = 100
end

define_custom_obj_fields({
    oSweeperOwner = 'u32',
    oCompensation = 'u32'
})

--- @param m MarioState
function active_player(m)
    local np = gNetworkPlayers[m.playerIndex]
    if m.playerIndex == 0 then
        return true
    end
    if not np.connected then
        return false
    end
    if np.currCourseNum ~= gNetworkPlayers[0].currCourseNum then
        return false
    end
    if np.currActNum ~= gNetworkPlayers[0].currActNum then
        return false
    end
    if np.currLevelNum ~= gNetworkPlayers[0].currLevelNum then
        return false
    end
    if np.currAreaIndex ~= gNetworkPlayers[0].currAreaIndex then
        return false
    end
    return is_player_active(m)
end

--- @param o Object
function bhv_sweeper_init(o)
    o.oFlags = OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE
    cur_obj_scale(0.12)

    o.hitboxRadius = 0
    o.hitboxHeight = 0

    network_init_object(o, true, { 'oSweeperOwner' })
end
--- @param o Object
function bhv_sweeper_loop(o)
    local np = network_player_from_global_index(o.oSweeperOwner)
    if np == nil then
        obj_mark_for_deletion(o)
        return
    end

    local m = gMarioStates[np.localIndex]
    if not active_player(m) then
        obj_mark_for_deletion(o)
        return
    end

    if m.playerIndex == 0 then
        if gPlayerSyncTable[np.localIndex].blinx then
            if timerSweep == 0 then
                cur_obj_scale(0)
                if gPlayerSyncTable[np.localIndex].invert then
                    gPlayerSyncTable[np.localIndex].modelId = E_MODEL_BLINXSWEEPEDINVERTED
                else
                    gPlayerSyncTable[np.localIndex].modelId = E_MODEL_BLINXSWEEPED
                end
            else
                cur_obj_scale(0.12)
                if gPlayerSyncTable[np.localIndex].invert then
                    gPlayerSyncTable[np.localIndex].modelId = E_MODEL_BLINXINVERTED
                else
                    gPlayerSyncTable[np.localIndex].modelId = E_MODEL_BLINX
                end
            end
        end

        if timerSweep > 0 then
            timerSweep = timerSweep - 1
        end

        if m.action ~= ACT_FLYING and (m.action & ACT_FLAG_SWIMMING) == 0 then
            -- it works, it just works.
            if o.oSweeperOwner ~= gNetworkPlayers[0].globalIndex then
                o.oPosX = get_hand_foot_pos_x(m, 0) + m.vel.x
                if m.action ~= ACT_JUMP then
                    o.oPosY = get_hand_foot_pos_y(m, 0)
                else
                    o.oPosY = get_hand_foot_pos_y(m, 0) + 25
                end
                o.oPosZ = get_hand_foot_pos_z(m, 0) + m.vel.z
            else
                o.oPosX = get_hand_foot_pos_x(m, 0) + m.vel.x
                if m.action ~= ACT_JUMP then
                    o.oPosY = get_hand_foot_pos_y(m, 0)
                else
                    o.oPosY = get_hand_foot_pos_y(m, 0) + 25
                end
                o.oPosZ = get_hand_foot_pos_z(m, 0) + m.vel.z
            end
        else
            o.oPosX = m.pos.x
            o.oPosZ = m.pos.z
            o.oPosY = m.pos.y + 50
        end

        if o.oPosY == o.header.gfx.prevPos.y and o.oSweeperOwner ~= gNetworkPlayers[0].globalIndex then
            if o.oCompensation < 30 then o.oCompensation = o.oCompensation + 1 end
        else o.oCompensation = 0 end

        if o.oCompensation >= 30 then
            o.oPosX = m.pos.x + m.vel.x
            if m.action ~= ACT_JUMP then
                o.oPosY = m.pos.y
            else
                o.oPosY = m.pos.y + 25
            end
            o.oPosZ = m.pos.z + m.vel.z
        end

        o.oFaceAnglePitch = 0
        o.oFaceAngleYaw = m.faceAngle.y
        o.oFaceAngleRoll = 0
    end
end
id_bhvSweeper = hook_behavior(nil, OBJ_LIST_GENACTOR, true, bhv_sweeper_init, bhv_sweeper_loop)

function despawn_sweeper()
    if sweeper ~= nil then
        obj_mark_for_deletion(sweeper)
    end
end

function spawn_sweeper()
    local m = gMarioStates[0]
    sweeper = spawn_sync_object(
        id_bhvSweeper,
        E_MODEL_TIMESWEEPER,
        get_hand_foot_pos_x(m, 0), get_hand_foot_pos_y(m, 0), get_hand_foot_pos_z(m, 0),
        function (o)
            o.oSweeperOwner = gNetworkPlayers[0].globalIndex
        end
    )
end

