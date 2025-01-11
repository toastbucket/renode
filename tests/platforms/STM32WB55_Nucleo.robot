*** Variables ***
${UART}                       sysbus.usart1

*** Test Cases ***
Run Zephyr Boot
    Execute Command           include @scripts/single-node/stm32wb55_nucleo.resc

    Create Terminal Tester    ${UART}

    Start Emulation

    Wait For Line On Uart     Booting Zephyr OS

Run Blink Uart Status
    Execute Command           include @scripts/single-node/stm32wb55_nucleo.resc

    Create Terminal Tester    ${UART}

    Start Emulation

    Wait For Line On Uart     LED state: OFF
    ${timeInfo}=              Execute Command   emulation GetTimeSourceInfo
    Should Contain            ${timeInfo}       Elapsed Virtual Time: 00:00:00

    Wait For Line On Uart     LED state: ON
    ${timeInfo}=              Execute Command   emulation GetTimeSourceInfo
    Should Contain            ${timeInfo}       Elapsed Virtual Time: 00:00:02

    Wait For Line On Uart     LED state: OFF
    ${timeInfo}=              Execute Command   emulation GetTimeSourceInfo
    Should Contain            ${timeInfo}       Elapsed Virtual Time: 00:00:04

Run Blink Led Status
    Execute Command           include @scripts/single-node/stm32wb55_nucleo.resc
    Create Terminal Tester    ${UART}
    Create Led Tester         sysbus.gpioPortB.led_blue

    Wait For Line On Uart     LED state: OFF

    # durations are in microseconds
    Assert Led Is Blinking    testDuration=8  onDuration=2  offDuration=2  tolerance=0.001
