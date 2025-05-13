local disableGhosts = {
    legs = false,
    dad = false
}
local sh_r = 600
local bfControlY = 0
local endCheck = false
local trigger = 1
local shag_fly = true
local songStarted = false
----------------------------
local collected = false
local state0 = true
local vsp = -10
----------------------------
local dvsp = {-20, -20, -20}
local dhsp = {0, 0, 0}
local CdebId = 1
local Csx = {0,0,0}
local Csy = {0,0,0}
local Csc = {0,0,0}
local CtF = {0,0,0}
local CtD = {0,0,0}
local CpF = {0,0,0}
------Thanks to Bf Myt for this----------
local currentGhost = 0
local lastGhost = 0
local fps = 0


function onStepHit()
	if curStep == 1 then
		sh_r = 60
	elseif curStep == 256 then
		sh_r = 600
	elseif curStep == 800 then
		sh_r = 60
	elseif curStep == 928 then
		sh_r = 600
	elseif curStep == 1184 then
		sh_r = 60
	elseif curStep == 1376 then
		sh_r = 600
	elseif curStep == 1440 then
		sh_r = 60
	elseif curStep == 1472 then
		sh_r = 600
	elseif curStep == 2224 then
		sh_r = 0
	elseif curStep == 2496 then
		sh_r = 600
    end
    if curStep == 2240 then
	disableGhosts["legs"] = true
	setProperty('legs.visible', false);
	end
	if curStep == 2752 then
		sh_r = 0
	elseif curStep == 2784 then
		sh_r = 600
	elseif curStep == 3168 then
		sh_r = 0
	elseif curStep == 3296 then
		sh_r = 600
	elseif curStep == 3552 then
		sh_r = 0
	elseif curStep == 3744 then
		sh_r = 600
	elseif curStep == 3808 then
		sh_r = 0
	elseif curStep == 3840 then
		sh_r = 1469
	elseif curStep == 4608 then
		sh_r = 0
	end
end

function debrisFly(sX, sY, debName, scroll, tFactor, tDelay, posFactor)
	Csx[CdebId] = sX
	Csy[CdebId] = sY
	Csc[CdebId] = scroll
	CtF[CdebId] = tFactor
	CtD[CdebId] = tDelay
	CpF[CdebId] = posFactor
	makeAnimatedLuaSprite('Cdebris'..CdebId, 'stages/god', Csx[CdebId], Csy[CdebId])
	addAnimationByPrefix('Cdebris'..CdebId, 'idk', 'deb_'..debName, 24, true)	
	setScrollFactor('Cdebris'..CdebId, Csc[CdebId], Csc[CdebId])
	scaleObject('Cdebris'..CdebId, Csc[CdebId] / 0.75, Csc[CdebId] / 0.75)
	addLuaSprite('Cdebris'..CdebId, false)
	CdebId = CdebId + 1
end

function onCreate()
	makeAnimatedLuaSprite('legs', 'characters/pshaggy', 0, 0)
	addAnimationByPrefix('legs', 'Instance', 'solo_legs', 24, false)
	addOffset('legs', 'Instance', 0, 0)
	setObjectOrder('legs', getObjectOrder('dadGroup'))
	addLuaSprite('legs', false)
	setProperty('legs.visible', true);
	
	makeLuaSprite('frame', 'zephy/part/frame', 230, 600)
	addLuaSprite('frame', true) 
end

local allowCountdown = true
function onCreatePost()
    setObjectOrder('dadGroup', getObjectOrder('boyfriendGroup') + 1)
	if isStoryMode and not seenCutscene then
		state0 = false
		shag_fly = false
		allowCountdown = false
	else
		scaleObject('gf', 0.8, 0.8)
		setScrollFactor('gf', 0.8, 0.8)
	end
end


function onStartCountdown()
	return onShaggyStart()
end

local cut = 0
function onShaggyStart()
	cut = cut + 1
	if not isStoryMode or cut == 1 and seenCutscene then
		--nothing
	elseif cut == 1 then
		setProperty('legs.alpha', 0)
		setProperty('bf_rock.alpha', 0)
		setProperty('gf_rock.alpha', 0)
		setProperty('frame.alpha', 0)
		playAnim('dad', 'back')
		setProperty('dad.x', 100)
		setProperty('dad.y', 100)
		setProperty('gf.x', 400)
		setProperty('gf.y', 130)
		setProperty('boyfriend.x', 770)
		setProperty('boyfriend.y', 450)
		setProperty('camFollow.x', getProperty('dad.x')+200)
		setProperty('camFollow.y', getProperty('dad.y')+300)
		runTimer('snap', 2)
		return Function_Stop;
	elseif cut == 2 then
		songStarted = true
	end
end

function onUpdate(elapsed)
	if isStoryMode and not seenCutscene then
		if getProperty('dad.animation.curAnim.name') == "snap" and getProperty('dad.animation.curAnim.finished') == true then
			playAnim('dad', 'snapped')
			cameraShake('game', 0.05, 0.2)
			playSound('god-eater/snap', 1)
			playSound('god-eater/undSnap', 1)
			runTimer('mansion_shake', 2)
		end
		for i = 1, 3 do
			dhsp[i] = CpF[i]
			dvsp[i] = dvsp[i] + 0.15

			setProperty('Cdebris'..i..'.x', getProperty('Cdebris'..i..'.x') + dhsp[i])
			setProperty('Cdebris'..i..'.y', getProperty('Cdebris'..i..'.y') + dvsp[i])
			setProperty('Cdebris'..i..'.angle', getProperty('Cdebris'..i..'.angle') - (dhsp[i] / 2))
		end
	end
	if not endCheck and allowCountdown then
		fps = fps + elapsed
		if fps >= 1/10 then
            if getProperty('legs.alpha') > 0 and not disableGhosts["legs"] then
			setObjectOrder('legs', getObjectOrder('dadGroup') - 1)
				createGhost('legs','FFFFF', getProperty('legs.animation.curAnim.name'), getProperty('dad.imageFile')) 
			end
            if not disableGhosts["dad"] then
			createGhost('dad', 'FFFFF', getProperty('dad.animation.curAnim.name'), getProperty('dad.imageFile'))
			fps = 0
		end
	end
		if getPropertyFromClass('flixel.FlxG', 'keys.pressed.DOWN') and bfControlY < 2290 then
			bfControlY = bfControlY + 1

		elseif getPropertyFromClass('flixel.FlxG', 'keys.pressed.UP') and bfControlY > 0 then
			bfControlY = bfControlY - 1

		end
		rotRateGf = curStep / 9.5 / 4
		gf_tox = 100 + math.sin(rotRateGf) * 200
		gf_toy = -2000 - math.sin(rotRateGf) * 80
		setProperty('gf.x', (getProperty('gf.x') + (gf_tox - getProperty('gf.x')) / 20))
		setProperty('gf.y', (getProperty('gf.y') + (gf_toy - getProperty('gf.y')) / 20))

		rotRate = curStep * 0.25
		bf_toy = -2000 + math.sin(rotRate) * 20 + bfControlY
		setProperty('boyfriend.y', (getProperty('boyfriend.y') + (bf_toy - getProperty('boyfriend.y')) / 20))

		rotRateShag = curStep / 9.25
		sh_toy = -2450 + -math.sin(rotRateShag * 2) * sh_r * 0.45
		sh_tox = -330 - math.cos(rotRateShag) * sh_r
		if shag_fly and curStep > 0 then
			setProperty('dad.x', getProperty('dad.x') + ((sh_tox - getProperty('dad.x')) / 12))
			setProperty('dad.y', getProperty('dad.y') + ((sh_toy - getProperty('dad.y')) / 12))
		elseif shag_fly and curStep <= 0 then
			setProperty('dad.x', getProperty('dad.x') + (((sh_tox+800) - getProperty('dad.x')) / 12))
			setProperty('dad.y', getProperty('dad.y') + ((sh_toy - getProperty('dad.y')) / 12))
		end

		if getProperty('dad.animation.curAnim.name') == "idle" then
			setProperty('dad.angle', math.sin(rotRateShag) * sh_r * 0.07 / 4)
			setProperty('legs.alpha', 1)
			setProperty('legs.angle', math.sin(rotRateShag) * sh_r * 0.07)
			setProperty('legs.x', (getProperty('dad.x') + -25 + math.cos((getProperty('legs.angle') + 90) * (math.pi/180)) * 150))
			setProperty('legs.y', (getProperty('dad.y') + 290 + math.sin((getProperty('legs.angle') + 90) * (math.pi/180)) * 150))
			setProperty('legs.x', getProperty('legs.x') - getProperty('legs.angle')*3.6)
			if getProperty('legs.angle') > 0 then
				setProperty('legs.y', getProperty('legs.y') + -getProperty('legs.angle')-getProperty('dad.angle')*2)
			elseif getProperty('legs.angle') < 0 then
				setProperty('legs.y', getProperty('legs.y') + getProperty('legs.angle')-getProperty('dad.angle')*2)
			end
		else
			setProperty('legs.alpha', 0)
			setProperty('dad.angle', 0)
		end
		
		if state0 then
			setProperty('frame.alpha', 1)
			setProperty('frame.y', getProperty('frame.y') + vsp)
			setProperty('frame.angle', getProperty('frame.angle') + 10)
			vsp = vsp + 0.3
			if vsp > 10 then
				setProperty('frame.angle', 0)
				setProperty('frame.x', 330)
				setProperty('frame.y', 660)
				state0 = false
			end
		end
	end
	if (not mustHitSection and not endCheck) and ((shag_fly and songStarted) or not isStoryMode) or (seenCutscene) or endCheck then
		cameraSetTarget('dad')
		setProperty('mouse.alpha', 0)
	elseif (not shag_fly and allowCountdown) or mustHitSection then
		cameraSetTarget('boyfriend')
		if bfControlY > 2000 and not collected then
			setProperty('mouse.alpha', 1)
		else
			setProperty('mouse.alpha', 0)
		end
	end
	if getProperty('dad.animation.curAnim.name') == "smile" and getProperty('dad.animation.curAnim.finished') == true and trigger == 1 then
		if bfControlY >= 400 then
			triggerEvent('startDialogue', 'dial1B', '');
		else
			doTweenX('camGY', 'camFollowPos', getMidpointX('dad'), 1, 'elasticInOut')
			doTweenY('camGF', 'camFollowPos', getMidpointY('dad'), 1, 'elasticInOut')
			triggerEvent('startDialogue', 'dial1A', '');
		end
		trigger = 2
	end


	setProperty('mouse.x',getMouseX('camGame')+ getProperty('camGame.scroll.x'));
	setProperty('mouse.y',getMouseY('camGame')+ getProperty('camGame.scroll.y'));

	if getProperty('frame.visible') == true and not collected and mouseClicked('left') and (getProperty('mouse.y') < getProperty('frame.y') + 200) and (getProperty('mouse.y') > getProperty('frame.y')) and (getProperty('mouse.x') < getProperty('frame.x') + 200) and (getProperty('mouse.x') > getProperty('frame.x')) then
		collected = true
		setProperty('orb.x', getMidpointX('frame')-50)
		setProperty('orb.y', getMidpointY('frame')-50)

		setProperty('fx.x', getProperty('orb.x')-50)
		setProperty('fx.y', getProperty('orb.y')-50)
		cancelTween('frame_fall')
		cancelTween('frame_speen')
		playSound('zephyrus/maskColl')
		setProperty('fx.alpha', 1)
		setProperty('orb.alpha', 1)
		setProperty('frame.alpha', 0)
		doTweenX('fx_growX', 'fx.scale', 1.3, 1, 'linear')
		doTweenY('fx_growY', 'fx.scale', 1.3, 1, 'linear')
		doTweenAlpha('bye_fx', 'fx', 0, 1, 'linear')
		doTweenX('orb_flyX', 'orb', getMidpointX('boyfriend'), 2, 'cubeIn')
		doTweenY('orb_flyY', 'orb', getMidpointY('boyfriend'), 2, 'sineInOut')
		saveFile('Shaggy/savefiles/frame.txt', "1", false)
	end
end

function onTimerCompleted(tag)
	if tag == "bf_fly" then
		allowCountdown = true
		state0 = true
		setProperty('camFollow.x', getProperty('boyfriend.x'))
		setProperty('camFollow.y', getProperty('boyfriend.y'))
		playSound('god-eater/rockFly', 1)
		debrisFly(-300, -120, 'ceil', 1, 1, -4, -40)
		debrisFly(0, -120, 'ceil', 1, 1, -4, -5)
		debrisFly(200, -120, 'ceil', 1, 1, -4, 40)
		setProperty('bf_rock.alpha', 1)
		setProperty('gf_rock.alpha', 1)
		doTweenX('gf_shrink', 'gf.scale', 0.8, 1, 'linear')
		doTweenY('gf_shrink2', 'gf.scale', 0.8, 1, 'linear')
		setScrollFactor('gf', 0.8, 0.8)
		runTimer('shaggy_up', 3)
	end
	if tag == "shaggy_up" then
		playAnim('dad', 'idle')
		playSound('god-eater/shagFly', 1, 'startC')
		shag_fly = true
	end
	if tag == "normal" then
		endCheck = true
		setProperty('defaultCamZoom',0.8)
		setProperty('frame.alpha', 0)
		setProperty('gf_rock.alpha', 0)
		setProperty('bf_rock.alpha', 0)
		scaleObject('gf', 1, 1)
		setScrollFactor('gf', 0.95, 0.95)
		playAnim('dad', 'stand')
		setProperty('dad.x', 100)
		setProperty('dad.y', 100)
		setProperty('scooby.alpha', 1)
		setProperty('gf.x', 400)
		setProperty('gf.y', 130)
		setProperty('boyfriend.x', 770)
		setProperty('boyfriend.y', 450)
		setProperty('camFollowPos.x', getProperty('dad.x') + 300)
		setProperty('camFollowPos.y', getProperty('dad.y') + 300)
		setProperty('camFollow.x', getProperty('dad.x') + 300)
		setProperty('camFollow.y', getProperty('dad.y') + 300)
		playSound('burst', 1, 'music1')
	end
end

function onTweenCompleted(tag)
	if string.find(tag,'dad') ~= nil and string.find(tag,'Bye') then
        for ghosts = currentGhost,lastGhost do
            local spriteName = 'dadGhost'..ghosts
            if tag == spriteName..'Bye' then
                removeLuaSprite(spriteName,true)
                currentGhost = currentGhost + 1
            end
        end
    end
end

function createGhost(character, color, anim, location)
    local spriteName = character..'Ghost'..lastGhost
    makeAnimatedLuaSprite(spriteName, location, getProperty(character..'.x'), getProperty(character..'.y'))
    scaleObject(spriteName, getProperty(character..'.scale.x'), getProperty(character..'.scale.y'))
    setProperty(spriteName..'.color',getColorFromHex(color))
    setProperty(spriteName..'.alpha', getProperty(character..'.alpha') - 0.4)
    doTweenAlpha(spriteName..'Bye',spriteName, 0, 0.5, 'linear')
    setObjectOrder(spriteName,getObjectOrder('dadGroup')-2)
    addGhostAnim(character,anim)
    addLuaSprite(spriteName,false)
    setProperty(spriteName..'.flipX', getProperty(character..'.flipX'))
    setProperty(spriteName..'.angle', getProperty(character..'.angle'))
    objectPlayAnimation(character..'Ghost'..lastGhost,anim,true)
    lastGhost = lastGhost + 1
end

function addGhostAnim(character, name)
	local spriteAnim = character..'Ghost'..lastGhost
	addAnimationByPrefix(spriteAnim, name, getProperty(character..'.animation.frameName'), getProperty(character..'.animation.curAnim.frameRate'), getProperty(character..'.animation.curAnim.looped'))
	setProperty(spriteAnim..'.offset.x', getProperty(character..'.offset.x'))
	setProperty(spriteAnim..'.offset.y', getProperty(character..'.offset.y'))
end