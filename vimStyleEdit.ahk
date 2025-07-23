; Some customization
#Requires AutoHotkey v2.0
Persistent ; Keep the script running 
#SingleInstance Force ; Allow only one instance of the script  


^!p:: Pause    ; Pause script with Ctrl+Alt+P
^!s:: Suspend  ; Suspend script with Ctrl+Alt+S
^!r:: Reload   ; Reload script with Ctrl+Alt+R

; Key-mapping
; *** space
space:: Send("{space}")
^space:: Send("^{space}")
#space:: Send("#{space}")
^#space:: Send("^#{space}")
!space:: Send("!{space}")
^!space:: Send("^!{space}")

; ; *** space + [] (windows virtual desktop switcher)
space & [:: send("^#{left}")
space & ]:: send("^#{right}")

; If the User has entere
; * means that it will only trigger itself
; $ means that
#HotIf GetKeyState("Space", "P") ; Retrieve the current status of the "Space" key
; Key Remappings
$*n::end ;remap
$*u::home ;remap
$*m::`
; Map h, i, j, k to Up, Down, Right, and Left for nagivation

$*k::Up
$*j::Down
$*h::Left
$*l::Right

; Sending (Emulators, not actual key remapping)
; Mapping some important keystroke to places where is nearest to the hand
$*q:: Send("{!}")
$*a:: Send("{@}")
$*e:: Send("{$}")
$*r:: Send("{^}") ; raised to the power of

    $*t::Send("{&}")
    $*i::Send("{_}") ; underline
     
    $*,::Send("{~}") ; remap ~ by pressing ,
    $*o::Send("{\}") 
   
    ; Some sendings
    $*w::Send("^{Right}")
    $*b::Send("^{Left}")

    
    f & w::Send("+^{Right}")
    f & b::Send("+^{Left}")
    
    d::Send("{Delete}")
    
#HotIf ; reset the condition, end the script