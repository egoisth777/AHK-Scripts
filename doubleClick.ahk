#Requires AutoHotkey v2.0

; Double tap "d" to simulate delete while holding
d::
    currentTime := A_TickCount  ; Get the current time in milliseconds
    if (currentTime - dLastPressTime <= dPressDelay) {  ; Check if "d" was pressed again within the delay
        dPressCount++
        if (dPressCount = 2) {
            Send, {Delete}  ; Send the Delete key command
            dPressCount := 0  ; Reset the counter
        }
    } else {
        dPressCount := 1  ; Reset the counter if the delay has passed
    }
    dLastPressTime := currentTime  ; Update the last press time
return