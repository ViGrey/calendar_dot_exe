.enum $0000
  screen        dsb 1
  dayOffset     dsb 1
  dayDrawOffset dsb 1
  dayDraw       dsb 2
  weekDraw      dsb 1

  tmp           dsb 2
  
  addr          dsb 2

  year          dsb 6
  era           dsb 1
  month         dsb 1
  calendar      dsb 1
  calendarTmp   dsb 1

  yearTmp         dsb 6
  yearEquivalent  dsb 6

  leapYear      dsb 1
  mod           dsb 1

  frames          dsb 1
  updateDisabled  dsb 1
  regionCheck     dsb 1
  needDraw        dsb 1

  controller            dsb 1
  controllerLastFrame   dsb 1

  cursorOffset          dsb 1
.ende

.enum $300
  graphicsControlFlags  dsb 1
  graphicsPointer       dsb 1
  ppuAddr               dsb 2 
  ppuAddrLast           dsb 2 

  graphics              dsb 244
.ende
