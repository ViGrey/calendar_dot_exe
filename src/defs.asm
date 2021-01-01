SCREEN_START        = 0
SCREEN_CALENDAR     = 1

CALENDAR_GREGORIAN  = 0
CALENDAR_JULIAN     = 1
CALENDAR_ROMAN      = 2 ; Assume Macrobius quirks

ERA_BC  = 0
ERA_AD  = 1

MONTH_JANUARY     = 0
MONTH_FEBRUARY    = 1
MONTH_MARCH       = 2
MONTH_APRIL       = 3
MONTH_MAY         = 4
MONTH_JUNE        = 5
MONTH_JULY        = 6
MONTH_AUGUST      = 7
MONTH_SEPTEMBER   = 8
MONTH_OCTOBER     = 9
MONTH_NOVEMBER    = 10
MONTH_DECEMBER    = 11

PPU_CTRL                = $2000
PPU_MASK                = $2001
PPU_STATUS              = $2002
PPU_OAM_ADDR            = $2003
PPU_OAM_DATA            = $2004
PPU_SCROLL              = $2005
PPU_ADDR                = $2006
PPU_DATA                = $2007

OAM_DMA                 = $4014
APU_FRAME_COUNTER       = $4017

CALLBACK                = $FFFA

CONTROLLER_1            = $4016
CONTROLLER_2            = $4017

BUTTON_A         = 1 << 7
BUTTON_B         = 1 << 6
BUTTON_SELECT    = 1 << 5
BUTTON_START     = 1 << 4
BUTTON_UP        = 1 << 3
BUTTON_DOWN      = 1 << 2
BUTTON_LEFT      = 1 << 1
BUTTON_RIGHT     = 1 << 0

