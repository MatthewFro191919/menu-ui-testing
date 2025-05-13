function opponentNoteHit(id,data,type,sus)
    if getProperty('dad.curCharacter') == 'gshaggy' then
        triggerEvent('Add Camera Zoom', '0.010', '0.02')
        triggerEvent('Screen Shake','0.1, 0.02','0.01, 0.02')
    end
end