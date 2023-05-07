define_custom_obj_fields({
    oRayTimer = 'u32',
    oRayOwner = 'u32'
})

--- @param o Object
function bhv_raycast_init(o)
    obj_set_billboard(o)
    o.oFlags = OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE

    o.oIntangibleTimer = 2
    o.oInteractType = INTERACT_DAMAGE

    o.hitboxRadius = 60
    o.hitboxHeight = 60

    o.oForwardVel = 180

    -- physics
    o.oWallHitboxRadius =  30
    o.oGravity          =  0
    o.oBounciness       =  0
    o.oDragStrength     =  0
    o.oFriction         =  0
    o.oBuoyancy         =  0

    o.oRayTimer = 3 -- time until the ray despawns

    local i = network_local_index_from_global(o.oRayOwner)

    network_init_object(o, true, { "oRayOwner" })
end

--- @param o Object
function ray_hit(o)
    spawn_mist_particles()
    obj_mark_for_deletion(o)
end

local dist = 200
--- @param o Object
function bhv_raycast_loop(o)
    --spawn_wind_particles(o.oFaceAnglePitch, o.oFaceAngleYaw)
    cur_obj_update_floor_and_walls()
    if (o.oMoveFlags & OBJ_MOVE_HIT_WALL) ~= 0 then
        ray_hit(o)
    end

    local soundPos = gMarioStates[0].marioObj.header.gfx.cameraToObject

    local toad = obj_get_nearest_object_with_behavior_id(o, id_bhvToadMessage)
    local corkbox = obj_get_nearest_object_with_behavior_id(o, id_bhvBreakableBoxSmall)
    local box = obj_get_nearest_object_with_behavior_id(o, id_bhvBreakableBox)
    local sign = obj_get_nearest_object_with_behavior_id(o, id_bhvMessagePanel)
    local post = obj_get_nearest_object_with_behavior_id(o, id_bhvWoodenPost)
    local tree = obj_get_nearest_object_with_behavior_id(o, id_bhvTree)
    local snowtree = obj_get_nearest_object_with_behavior_id(o, id_bhvTreeSnow)
    if toad ~= nil and dist_between_objects(o, toad) < dist then
        obj_mark_for_deletion(toad)
        table.insert(trashList, {id_bhvToadMessage, E_MODEL_TOAD})
        ray_hit(o)
    elseif corkbox ~= nil and dist_between_objects(o, corkbox) < dist then
        obj_mark_for_deletion(corkbox)
        table.insert(trashList, {id_bhvBreakableBoxSmall, E_MODEL_BREAKABLE_BOX_SMALL})
        ray_hit(o)
    elseif box ~= nil and dist_between_objects(o, box) < dist then
        obj_mark_for_deletion(box)
        table.insert(trashList, {id_bhvBreakableBox, E_MODEL_BREAKABLE_BOX})
        ray_hit(o)
    elseif sign ~= nil and dist_between_objects(o, sign) < dist then
        obj_mark_for_deletion(sign)
        table.insert(trashList, {id_bhvMessagePanel, E_MODEL_WOODEN_SIGNPOST})
        ray_hit(o)
    elseif post ~= nil and dist_between_objects(o, post) < dist then
        obj_mark_for_deletion(post)
        table.insert(trashList, {id_bhvWoodenPost, E_MODEL_WOODEN_POST})
        ray_hit(o)
    elseif tree ~= nil and dist_between_objects(o, tree) < dist then
        obj_mark_for_deletion(tree)
        table.insert(trashList, {id_bhvTree, E_MODEL_BUBBLY_TREE})
        ray_hit(o)
    elseif snowtree ~= nil and dist_between_objects(o, snowtree) < dist then
        obj_mark_for_deletion(snowtree)
        table.insert(trashList, {id_bhvTreeSnow, E_MODEL_SNOW_TREE})
        ray_hit(o)
    end

    if o.oTimer > o.oRayTimer then
        obj_mark_for_deletion(o)
    end

    if o.oVelY == 0 then cur_obj_move_xz_using_fvel_and_yaw()
    else cur_obj_move_using_vel() end
end

id_bhvRay = hook_behavior(nil, OBJ_LIST_GENACTOR, true, bhv_raycast_init, bhv_raycast_loop)

--- @param m MarioState
--- @param o Object
function allow_interact(m, o)
    local b = obj_get_nearest_object_with_behavior_id(m.marioObj, id_bhvRay)
    if o == b then
        if o.oRayOwner == gNetworkPlayers[m.playerIndex].globalIndex then return false end
    else
        if b ~= nil then obj_mark_for_deletion(b) end
        return true
    end
end

hook_event(HOOK_ALLOW_INTERACT, allow_interact)