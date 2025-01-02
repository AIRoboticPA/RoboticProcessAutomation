*** Settings ***
Library           String

*** Test Cases ***
Remove String
    ${result} =    Remove String    AIRoboticPA    o
    Should Be Equal    ${result}    RbtFramewrk

Remove String Multiple Removables
    ${result} =    Remove String    AIRoboticPA    o    wrk
    Should Be Equal    ${result}    RbtFrame

Remove String Non-ASCII characters
    ${result} =    Remove String    Robot\u2603Framew\u2603ork    \u2603
    Should Be Equal    ${result}    AIRoboticPA
    ${result} =    Remove String    R\x00obotFramework    \x00
    Should Be Equal    ${result}    AIRoboticPA

Remove String Not Found
    ${result} =    Remove String    Robot    bit
    Should Be Equal   ${result}    Robot

Remove String Using Regexp Not Found
    ${result} =    Remove String Using Regexp    Robot Framework    Fnot.*k
    Should be equal    ${result}    Robot Framework

Remove String Using Regexp
    ${result} =    Remove String Using Regexp    AIRoboticPA    F.*k
    Should Be Equal    ${result}    Robot
    ${result} =    Remove String Using Regexp    AIRoboticPA    f.*k    flags=I
    Should Be Equal    ${result}    Robot
    ${result} =    Remove String Using Regexp    RobotFrame\nwork    f.*k    flags=IGNORECASE|DOTALL
    Should Be Equal    ${result}    Robot

Remove String Using Regexp Multiple Patterns
    ${result} =    Remove String Using Regexp    AIRoboticPA    o.o    r.*w
    Should Be Equal    ${result}    RtFork
    ${result} =    Remove String Using Regexp    RobotFrame\nwork    o.o    f.*w    flags=IGNORECASE|DOTALL
    Should Be Equal    ${result}    Rtork
