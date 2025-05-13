-- By ChatGPT XD
-- Configuração individual para cada seta
customSpeedX = {}  -- Velocidade de deslocamento X por seta
customSpeedY = {}  -- Velocidade de deslocamento Y por seta
customOffsetX = {} -- Deslocamento X base
customOffsetY = {} -- Deslocamento Y base

-- Inicializar configurações personalizadas
for i = 0, 17 do
    customSpeedX[i] = math.random() * (1 - 0.5) + 0.5  -- Número entre 0.5 e 1
    customSpeedY[i] = math.random() * (1 - 0.5) + 0.5  -- Número entre 0.5 e 1
    customOffsetX[i] = math.random() * (20 - 2) + 2    -- Número entre 2 e 20
    customOffsetY[i] = math.random() * (20 - 2) + 2    -- Número entre 2 e 20
end

-- Variáveis para armazenar a posição inicial das setas
defaultX = {}  
defaultY = {}  

-- Controladores de efeitos
local enableEffects = false  
local enableXEffect = false
local XEffectSpeed = 1
local enableYEffect = false
local YEffectSpeed = 1
local enableCircle = false  
local enableWave = false  
local circleSpeed = 400  
local circleSize = 15  
local waveSpeed = 5000  

function onCreatePost()
    -- Armazena a posição inicial de todas as setas
    for i = 0, 17 do  
        defaultX[i] = getPropertyFromGroup('strumLineNotes', i, 'x')  
        defaultY[i] = getPropertyFromGroup('strumLineNotes', i, 'y')  
    end  
end

function resetStrumPositions()  
    for i = 0, 17 do  
        noteTweenX("resetX" .. i, i, defaultX[i], 1, "linear")  
        noteTweenY("resetY" .. i, i, defaultY[i], 1, "linear")  
    end  
end  

function onUpdate(elapsed)
    if not enableEffects then return end  

    local songTime = getSongPosition() * 0.005  
    local songPos = getSongPosition()  
    local currentBeat = (songPos / waveSpeed) * (curBpm / 60)  

    for i = 0, 17 do
        local baseX = defaultX[i]  
        local baseY = defaultY[i]  

        -- Se a seta for ÍMPAR (1, 3, 5, ... 17)
        if i % 2 == 1 then
            -- Movimento no eixo X (se ativado)
            if enableXEffect then
                baseX = baseX + math.sin(songTime * customSpeedX[i]) * customOffsetX[i]
            end

            -- Movimento no eixo Y (se ativado)
            if enableYEffect then
                baseY = baseY + math.cos(songTime * customSpeedY[i]) * customOffsetY[i]
            end
        end

        -- Efeito circular (aplicado em todas as setas)
        local offsetX, offsetY = 0, 0
        if enableCircle then  
            offsetX = circleSize * math.cos((songPos / circleSpeed) + (i * 0.1))  
            offsetY = circleSize * math.sin((songPos / circleSpeed) + (i * 0.1))  
        end  

        -- Efeito de onda (aplicado em todas as setas)
        local waveOffsetY = 0
        if enableWave then  
            waveOffsetY = 50 * math.sin((currentBeat + i * 0.25) * math.pi)  
        end  

        -- Aplicando a posição final somando os efeitos permitidos
        setPropertyFromGroup('strumLineNotes', i, 'x', baseX + offsetX)
        setPropertyFromGroup('strumLineNotes', i, 'y', baseY + offsetY + waveOffsetY)
    end
end

function onStepHit()
    if curStep == 256 then  
        enableEffects = true
        enableCircle = true 
        circleSpeed = 300  
        circleSize = 35  
    elseif curStep == 800 then  
        enableEffects = false
        enableCircle = false  
        resetStrumPositions()
    elseif curStep == 928 then  
        enableEffects = true
        enableCircle = true  
        circleSpeed = 300  
        circleSize = 35  
    elseif curStep == 1184 then  
        enableEffects = false
        enableCircle = false  
        resetStrumPositions()
    elseif curStep == 1376 then  
        enableEffects = true
        enableCircle = true  
        circleSpeed = 200  
        circleSize = 35  
    elseif curStep == 1440 then  
        enableEffects = false
        enableCircle = false  
        resetStrumPositions()
    elseif curStep == 1472 then  
        enableEffects = true
        enableXEffect = true 
        enableCircle = true  
        circleSpeed = 300  
        circleSize = 35  
    elseif curStep == 2048 then  
        enableEffects = true
        enableXEffect = true
        enableCircle = true  
        circleSpeed = 200  
        circleSize = 35  
    elseif curStep == 2240 then  
        enableEffects = false
        resetStrumPositions()
    elseif curStep == 2368 then  
        enableEffects = true
        enableCircle = true  
        circleSpeed = 250  
        circleSize = 30  
    elseif curStep == 2496 then  
        enableEffects = true
        enableXEffect = true 
        enableYEffect = true 
        enableCircle = true
        circleSpeed = 150  
        circleSize = 30 
    elseif curStep == 2752 then  
        enableEffects = false
        enableXEffect = false 
        enableYEffect = false 
        enableCircle = false
        resetStrumPositions()
    elseif curStep == 2784 then  
        enableEffects = true
        enableXEffect = true 
        enableYEffect = true 
        enableCircle = true
        circleSpeed = 150  
        circleSize = 30 
        enableWave = true
    elseif curStep == 3168 then  
        enableEffects = false
        enableXEffect = false 
        enableYEffect = false 
        enableCircle = false
        enableWave = false
        resetStrumPositions()
    elseif curStep == 3296 then  
        enableEffects = true
        enableXEffect = true 
        enableYEffect = true 
        enableCircle = true
        circleSpeed = 150  
        circleSize = 30 
        enableWave = true
    elseif curStep == 3552 then  
        enableEffects = false
        enableXEffect = false 
        enableYEffect = false 
        enableCircle = false
        enableWave = false
        resetStrumPositions()
    elseif curStep == 3744 then  
        enableEffects = true
        enableXEffect = true 
        enableYEffect = true 
        enableCircle = true
        circleSpeed = 150  
        circleSize = 30 
        enableWave = true
    elseif curStep == 3808 then  
        enableEffects = false
        enableXEffect = false 
        enableYEffect = false 
        enableCircle = false
        enableWave = false
        resetStrumPositions()
    elseif curStep == 3840 then  
        enableEffects = true
        enableXEffect = true 
        XEffectSpeed = 50  
        enableYEffect = true 
        YEffectSpeed = 50  
        enableCircle = true
        circleSpeed = 150  
        circleSize = 30 
    elseif curStep == 4608 then  
        enableEffects = false
        enableXEffect = false 
        enableYEffect = false 
        enableCircle = false
        enableWave = false
        resetStrumPositions()
    elseif curStep == 4736 then  
        enableEffects = true
        enableXEffect = true 
        XEffectSpeed = 50  
        enableYEffect = true 
        YEffectSpeed = 50  
        enableCircle = true
        circleSpeed = 100  
        circleSize = 30    
        enableWave = true
    elseif curStep == 4864 then  
        enableEffects = false
        enableXEffect = false 
        enableYEffect = false 
        enableCircle = false
        enableWave = false
        resetStrumPositions()
    end  
end