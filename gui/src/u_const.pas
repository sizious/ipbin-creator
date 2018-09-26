unit u_const;

interface

const
  //IPBINFILE
  IPBIN_FILE                  : string = 'IP.BIN';

  //SEGA OS
  SEGA_OS_USED_ADDR           : Word = $3E;
  SEGA_OS_USED_TRUE           : string = '0'; //Byte = $30;
  SEGA_OS_USED_FALSE          : string = '1'; //Byte = $31;

  //Extended peripherals
  EXTENDED_PERIPHERALS_ADDR   : Word = $3C;
  MEMORY_CARD_ENABLE 	        : Byte = $08;
  SOUND_INPUT_PERIPHERAL      : Byte = $04;
  VIBRATION_PACK_ENABLE       : Byte = $02;
  OTHERS_ENABLE               : Byte = $01;
  NONE                        : string = #00;

  //VGA Support
  VGA_BOX_SUPPORT_ADDR        : Word = $3D;
  VGA_BOX_SUPPORT_TRUE        : string = '1'; //Byte = $31;
  VGA_BOX_SUPPORT_FALSE       : string = '0'; //Byte = $30;

  //Minimum Buttons
  MOUSE_GUN_KBD_AN_Y2_ADDR    : Word = $38;

  MOUSE_ENABLE                : Byte = $08;
  GUN_ENABLE                  : Byte = $04;
  KEYBOARD_ENABLE             : Byte = $02;
  ANALOG_Y2_ENABLE            : Byte = $01;

  ANALOG_X2_Y1_X1_L_ADDR      : Word = $39;

  ANALOG_X2_ENABLE            : Byte = $08;
  ANALOG_Y1_ENABLE            : Byte = $04;
  ANALOG_X1_ENABLE            : Byte = $02;
  ANALOG_L_ENABLE             : Byte = $01;

  ANALOG_R_BTN2_Z_Y_ADDR      : Word = $3A;

  ANALOG_R_ENABLE             : Byte = $08;
  DIRECT_KEY_BUTTON_2         : Byte = $04;
  BUTTON_Z_ENABLE             : Byte = $02;
  BUTTON_Y_ENABLE             : Byte = $01;

  BTN_X_D_C_BTN1_A_ADDR       : Word = $3B;

  BUTTON_X_ENABLE             : Byte = $08;
  BUTTON_D_ENABLE             : Byte = $04;
  BUTTON_C_ENABLE             : Byte = $02;
  DIRECT_KEY_BUTTON1_A        : Byte = $01;

  //Area Symbols
  AREA_SYMBOL_JAPANESE_ADDR   : Word = $30;
  AREA_SYMBOL_JAPANESE        : Char = 'J';

  AREA_SYMBOL_EUROPE_ADDR     : Word = $32;
  AREA_SYMBOL_EUROPE          : Char = 'E';

  AREA_SYMBOL_USA_ADDR        : Word = $31;
  AREA_SYMBOL_USA             : Char = 'U';

  AREA_SYMBOL_NONE            : Char = ' ';

  //Other (date, version, etc)
  VERSION_ADDR                : Word = $4A;
  MEDIA_ID_ADDR               : Word = $20;
  MEDIA_TYPE_ADDR             : Word = $25;
  PRODUCT_ID_ADDR             : Word = $40;
  DATE_ADDR                   : Word = $50;
  BOOTSTRAP_ADDR              : Word = $60;
  MANUFACTURER_NAME_ID_ADDR   : Word = $70;
  APPLICATION_TITLE_ADDR      : Word = $80;

implementation

//No code...

end.
