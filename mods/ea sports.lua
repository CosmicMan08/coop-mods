-- name: Super Mario 64: EA Edition
-- incompatible: your wallet
-- description: This free to play mod implements a new currency, called "EA Coins". \nEvery press of the A-button now costs a single EA coin. \nYou can also use EA coins to purchase extra DLC, items, or boosts by pressing up on the D-pad to open the shop. \nalso theres ads lmao\n\nLegally required credits:\nKaze Emanuar - the concept\nEA Games - being an absolutely awful company\nCosmicMan08 - most programming\nKeeb - groundpound dive code

--other variables
eaCoins = 5
shopOpen = false
shopCursor = 1
shopTimer = 0
adTimer = 0
hyperSpeedTimer = 0
boughtstuff = false

ads = {
    "This ad is personalized.", 
    "Wii Play, the game everybody has.", 
    "Hot princesses in your area!", 
    "4.99$ little sponges", 
    "You're the 1000000th visitor!", 
    "You want sports? EA show you sports!", 
    "Panasonic Blu-rays for only 99$", 
    "Thigh highs for only 800 EA Coins", 
    "Shoutouts to SimpleFlips", 
    "F*** YOU BALTIMORE!",
    "Stwawbewwy Miwk veri gud",
    "Subscribe to CosmicMan08 on YT"
}

--list of stuff in the shop
inAppPurchases = {
    {false, 120, "Invisible wall patch", false},
    {false, 150, "Z Button", false},
    {false, 200, "Dive out of Ground Pound", false},
    {false, 1200, "Remove ads", false},
    {false, 50, "Koopa Shell", true},
    {false, 50, "Wing Cap", true},
    {false, 50, "1-up", true},
    {false, 25, "HyperSpeed", true},
    {false, 5, "Random Item", true},
    {false, 1, "literally nothing", true},
    {false, 0, "Respawn", true}
}
--indexes!
noInvis = 1
zBut = 2
poundDive = 3
noAds = 4
koopaShell = 5
wingCap = 6
oneUp = 7
HyperSpeed = 8
lootBox = 9
literallyNothing = 10
respawn = 11

function tablelength(t)
    local count = 0
    for i in pairs(t) do
        count = count + 1
    end
    return count
end

function on_hud_render()
    height = djui_hud_get_screen_height()
    width = djui_hud_get_screen_width()
    textHeight = height/56.25

    --djui_popup_create(tostring(height),1)

    djui_hud_set_font(2) -- makes the font based
    djui_hud_print_text(string.format("ea coins ".. tostring(eaCoins)), 16, 128, 3)

    if shopOpen then
        --shop box
        djui_hud_set_color(0,0,0,128)
        djui_hud_render_rect(width/3,height/25,width/3,height-(height/12.5))

        --shop text
        djui_hud_set_font(2) -- makes the font based
        djui_hud_set_color(255,255,255,255)
        djui_hud_print_text("shop", width/3 + (textHeight*3), height/25 + (textHeight*3), 3)

        --cursor
        djui_hud_print_text("a", width/3, height/25 + (textHeight*3) + (textHeight*3 * shopCursor), 3)

        --items!
        djui_hud_set_font(0) -- unbased but complete font
        for j,i in ipairs(inAppPurchases) do
            if i[1] then
                djui_hud_print_text("Bought " ..i[3], width/3 + (textHeight*3), height/25 + (textHeight*3) + (textHeight*3 * j), 1.5)
            else
                djui_hud_print_text("$" .. tostring(i[2]) .. " " ..i[3], width/3 + (textHeight*3), height/25 + (textHeight*3) + (textHeight*3 * j), 1.5)
            end
        end
    end

    --ads !
    if not inAppPurchases[noAds][1] then
        djui_hud_set_font(1) -- ew
        adTimer = adTimer + 1

        math.randomseed(adTimer/60)
        adText = ads[math.ceil((adTimer/60) % tablelength(ads))]
        djui_hud_print_text(adText, math.random(0,math.floor(width - djui_hud_measure_text(adText))), math.random(0,height), 1)
        
        math.randomseed(adTimer/42)
        adText = ads[math.ceil((adTimer/42) % tablelength(ads))]
        djui_hud_print_text(adText, math.random(0,math.floor(width - djui_hud_measure_text(adText))), math.random(0,height), 1)

        math.randomseed(adTimer/110)
        adText = ads[math.ceil((adTimer/110) % tablelength(ads))]
        djui_popup_create(adText,1)
    end
end

function mauto_the_prequel(m)
    if m.playerIndex ~= 0 then
        return
    else
        if (m.controller.buttonDown & A_BUTTON) == 0 then
            boughtstuff = false
        end

        --shop
        if (m.controller.buttonPressed & U_JPAD) ~= 0 and not shopOpen then
            shopOpen = true
        elseif (m.controller.buttonPressed & U_JPAD) ~= 0 then
            shopOpen = false
        end

        if (m.controller.stickY) > 20 and shopOpen and shopCursor > 1 and shopTimer == 0 then
            shopCursor = shopCursor - 1
            shopTimer = 20
        elseif (m.controller.stickY) < -20 and shopOpen and shopTimer == 0 and shopCursor < tablelength(inAppPurchases) then
            shopCursor = shopCursor + 1
            shopTimer = 20
        end
        if (m.controller.buttonPressed & A_BUTTON) ~= 0 and shopOpen and not boughtstuff then --purchase thing
            if eaCoins >= inAppPurchases[shopCursor][2] and inAppPurchases[shopCursor][1] == false then --if you haz money then yous can puwchases!
                if not inAppPurchases[shopCursor][4] then -- checks if the item is a one-time purchase or not
                    inAppPurchases[shopCursor][1] = true  -- marks the item as "bought" if the item was one-time
                else
                    if shopCursor == koopaShell then
                        spawn_sync_object(
                            id_bhvKoopaShell,
                            E_MODEL_KOOPA_SHELL,
                            m.pos.x, m.pos.y, m.pos.z,
                            nil
                        )
                    end
                    if shopCursor == oneUp then m.numLives = m.numLives + 1 end
                    if shopCursor == lootBox then
                        randomnumber = math.random(0,1000)
                        if randomnumber >= 0 and randomnumber <= 99 then
                            spawn_sync_object(
                                id_bhvMadPiano,
                                E_MODEL_MAD_PIANO,
                                m.pos.x, m.pos.y, m.pos.z,
                                nil
                            )
                        elseif randomnumber >= 100 and randomnumber <= 499 then
                            spawn_sync_object(
                                id_bhvGoomba,
                                E_MODEL_GOOMBA,
                                m.pos.x, m.pos.y, m.pos.z,
                                nil
                            )
                        elseif randomnumber >= 500 and randomnumber <= 649 then
                            eaCoins = eaCoins + 1
                        elseif randomnumber >= 650 and randomnumber <= 849 then
                            m.area.numRedCoins = m.area.numRedCoins + 1
                            eaCoins = eaCoins + 2
                        elseif randomnumber >= 850 and randomnumber <= 949 then
                            eaCoins = eaCoins + 10
                        elseif randomnumber >= 950 and randomnumber <= 999 then
                            spawn_sync_object(
                                id_bhvKoopaShell,
                                E_MODEL_KOOPA_SHELL,
                                m.pos.x, m.pos.y, m.pos.z,
                                nil
                            )
                        elseif randomnumber == 1000 then
                            m.numStars = m.numStars + 1
                        end
                    end
                    if shopCursor == HyperSpeed then hyperSpeedTimer = 10000 end
                    if shopCursor == wingCap then
                        spawn_sync_object(
                            id_bhvWingCap,
                            E_MODEL_MARIOS_WING_CAP,
                            m.pos.x, m.pos.y, m.pos.z,
                            nil
                        )
                    end
                    if shopCursor == respawn then warp_restart_level() end
                end
                eaCoins = eaCoins - inAppPurchases[shopCursor][2] -- takes away money when you buy smth
                boughtstuff = true
                djui_popup_create(tostring(boughtstuff),1)
                shopOpen = false
            end
        end

        if shopOpen then --disables some inputs
            m.controller.stickY = 0
            m.controller.stickX = 0
            m.controller.rawStickY = 0
            m.controller.rawStickX = 0
            m.controller.stickMag = 0
            m.controller.buttonPressed = m.controller.buttonPressed & ~A_BUTTON
            m.controller.buttonDown = m.controller.buttonDown & ~A_BUTTON
        end
        if shopTimer > 0 then shopTimer = shopTimer - 1 end --timer!!!!!
        --ea stuff
        if (m.input & INPUT_A_PRESSED) ~= 0 and eaCoins > 0 and not shopOpen and not boughtstuff then                -- decrease ea coins when you press a
            eaCoins = eaCoins - 1
        elseif eaCoins <= 0  then                                                -- stops you from pressing a if you don't have ea coins
            m.controller.buttonPressed = m.controller.buttonPressed & ~A_BUTTON
            m.controller.buttonDown = m.controller.buttonDown & ~A_BUTTON
        end

        if not inAppPurchases[zBut][1] then -- same thing as the a button code above, but with z
            m.controller.buttonPressed = m.controller.buttonPressed & ~Z_TRIG
            m.controller.buttonDown = m.controller.buttonDown & ~Z_TRIG
        end

        if hyperSpeedTimer > 0 then
            hyperSpeedTimer = hyperSpeedTimer - 1 
            m.forwardVel = 1000 -- weeeee
        end

        m.numCoins = eaCoins -- set the coin count to the eacoin count, this means that if the eacoins decrease, they won't be bumped back up again when the check in mauto() happens
    end
end

function mauto(m)
    if m.playerIndex ~= 0 then
        return
    else
        if eaCoins < m.numCoins then -- if the player has more coins than eacoins
            eaCoins = m.numCoins     -- update the eacoins to match the regular coins
        end

        if inAppPurchases[poundDive][1] then                          --dive         by Super nFT
            if m.action == ACT_GROUND_POUND then
                if (m.controller.buttonPressed & B_BUTTON) ~= 0 then
                    m.vel.y = 28
                    m.forwardVel = 16
                    m.faceAngle.y = m.intendedYaw
                    m.action = ACT_DIVE
                end
            end
        end
    end
end

function mario_physicnt(m)
    if m.playerIndex ~= 0 then
        return
    else
        if not inAppPurchases[noInvis][1] then
            if m.forwardVel > 20 and math.random(0,15) == 1 then
                m.action = ACT_BACKWARD_AIR_KB
                djui_popup_create("trolled",1)
            end
        end
    end
end

--hooks stuff
hook_event(HOOK_ON_HUD_RENDER, on_hud_render)
hook_event(HOOK_MARIO_UPDATE, mauto)
hook_event(HOOK_BEFORE_PHYS_STEP, mario_physicnt)
hook_event(HOOK_BEFORE_MARIO_UPDATE, mauto_the_prequel)