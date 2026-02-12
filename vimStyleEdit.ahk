; Some customization
#Requires AutoHotkey v2.0
Persistent ; Keep the script running
#SingleInstance Force ; Allow only one instance of the script

^!p:: Pause    ; Pause script with Ctrl+Alt+P
^!s:: Suspend  ; Suspend script with Ctrl+Alt+S
^!r:: Reload   ; Reload script with Ctrl+Alt+R

CapsLock::Escape ; Remap CapsLock to Escape
Escape::Capslock ;Remap Escape to CapsLock

; Global variable to track space mode state with safety mechanism
global spaceMode := false
global spaceReleaseDetectedAt := 0  ; Timestamp when release was first detected for debouncing
global lastVimKeyPress := 0  ; Timestamp of last vim key usage - extends space mode

; Timer to ALWAYS sync spaceMode with actual key state
; This is the primary mechanism since space up:: doesn't fire when using space as modifier
SetTimer(UpdateSpaceMode, 10)  ; Check every 10ms for faster response

UpdateSpaceMode() {
    global spaceMode, spaceReleaseDetectedAt, lastVimKeyPress
    local currentState := GetKeyState("Space", "P")
    local now := A_TickCount

    ; === SPACE PRESSED ===
    if (currentState = 1) {
        spaceReleaseDetectedAt := 0
        if (spaceMode = 0) {
            spaceMode := 1
        }
        return
    }

    ; === SPACE RELEASED ===
    if (spaceMode = 0) {
        return
    }

    ; Calculate time since last vim key
    local timeSinceVimKey := (lastVimKeyPress = 0) ? 999999 : (now - lastVimKeyPress)

    ; If vim keys used recently (< 50ms), keep space mode active
    if (timeSinceVimKey < 50) {
        spaceReleaseDetectedAt := 0
        return
    }

    ; Start debouncing
    if (spaceReleaseDetectedAt = 0) {
        spaceReleaseDetectedAt := now
        return
    }

    ; Check if debounce period has elapsed
    if ((now - spaceReleaseDetectedAt) >= 60) {
        spaceMode := 0
        spaceReleaseDetectedAt := 0
    }
}

; Key-mapping
; Send space only when tapped alone (space & combinations take precedence)
space:: Send("{space}")
^space:: Send("^{space}")
#space:: Send("#{space}")
^#space:: Send("^#{space}")
!space:: Send("!{space}")
^!space:: Send("^!{space}")

; ; *** space + [] (windows virtual desktop switcher)
space & [:: send("^#{left}")
space & ]:: send("^#{right}")

; Space up handler - NOTE: This doesn't always fire when space is used as a modifier!
; We rely primarily on the timer for cleanup
space up:: {
    global spaceMode
    spaceMode := false

    ; Extra safety: if key is somehow still pressed, wait for it
    if GetKeyState("Space", "P") {
        KeyWait("Space")
        spaceMode := false
    }
}

; If the User has entered space hold mode
; * means wildcard - fires regardless of other modifiers
; $ means it won't trigger itself recursively
#HotIf spaceMode ; Use variable instead of GetKeyState for reliable tracking
; Key Remappings
; Map h, j, k, l to Left, Down, Up, Right for navigation

$*k:: {
    global lastVimKeyPress := A_TickCount
    Send("{Up}")
}
$*j:: {
    global lastVimKeyPress := A_TickCount
    Send("{Down}")
}
$*h:: {
    global lastVimKeyPress := A_TickCount
    Send("{Left}")
}
$*l:: {
    global lastVimKeyPress := A_TickCount
    Send("{Right}")
}

; Direct key remapping
; Mapping some important keystroke to places where is nearest to the hand
$*q::!
$*a::@
$*r::^ ; raised to the power of
$*s::$ ; dollar sign mapped to space plus s

$*u::Home
$*n::End

$*e::= ; e maps to equal
$*p::+ ; p is mapped to plus
$*d::- ; tline minus
$*i::_ ; underline

$*t::~ ; remap ~ by pressing
$*m::`
$*o::\

f::shift ; remap f to shift key
,::[ ; remap to [
.::] ; remap to ]
z::^z ; Ctrl+Z (undo)
c::^c ; Ctrl+C (copy)
0::(
-::)

; Modifier + key combinations
$*w:: {
    global lastVimKeyPress := A_TickCount
    Send("^{Right}")
}
$*b:: {
    global lastVimKeyPress := A_TickCount
    Send("^{Left}")
}

#HotIf ; reset the condition, end the script
