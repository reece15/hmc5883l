NOTE: AVR Code addresses are word addresses
All other addresses (including ones in FLASH) are byte addresses

Area                               Addr   Size   Decimal Bytes (Attributes)
--------------------------------   ----   ----   ------- ----- ------------
                             lit   00E4   0074 =    116. bytes (rel,con,rom)

       Addr  Global Symbol
      -----  --------------------------------
       00E4  __lit_start
       0158  __lit_end

Area                               Addr   Size   Decimal Bytes (Attributes)
--------------------------------   ----   ----   ------- ----- ------------
                           idata   0158   0005 =      5. bytes (rel,con,rom)

       Addr  Global Symbol
      -----  --------------------------------
       0158  __idata_start
       015D  __idata_end

Area                               Addr   Size   Decimal Bytes (Attributes)
--------------------------------   ----   ----   ------- ----- ------------
                            text   015E   1314 =   4884. bytes (rel,con,rom)

       Addr  Global Symbol
      -----  --------------------------------
       00AF  __text_start
       00AF  __start
       00D1  _exit
       00D2  _delay_1us
       00D8  _delay_nus
       00E6  _delay_1ms
       00F0  _delay_nms
       00FE  _I2C_Write
       013B  _I2C_Read
       0189  _LCD_init
       019E  _LCD_en_write
       01A4  _LCD_write_command
       01C2  _LCD_write_data
       01E0  _LCD_set_xy
       01EF  _LCD_write_string
       0204  _LCD_write_char
       0210  _conversion
       0253  _display_angle
       02ED  _main
       02FE  push_arg4
       0300  push_arg2
       0303  mod16u
       0305  div16u
       0306  xdiv16u
       031F  elpm32
       0333  pop_xgset00FC
       033A  push_xgsetF0FC
       033C  push_xgset30FC
       033E  push_xgset00FC
       0340  push_xgset003C
       0345  push_xgset300C
       034A  pop_xgset300C
       034F  push_xgsetF000
       0354  pop_xgsetF000
       0359  push_xgsetF00C
       0360  pop_xgsetF00C
       0367  push_xgset303C
       036E  pop_xgset303C
       0375  neg32
       037E  lsl32
       038A  fpsub
       038C  fpadd
       038D  fpadd_alt
       03F2  fpadd1
       03FC  fpadd1x
       0409  fpadd2
       0414  fpadd2x
       0422  fpsub2
       042D  fpint
       0459  uint2fp
       045B  int2fp
       0464  ulong2fp
       0466  long2fp
       0479  fpdiv1
       0482  fpdiv2
       048C  fpdiv1x
       0498  fpdiv2x
       0529  unpacks
       0531  tstR16_R19
       0539  unpacku
       054E  normalize_and_pack
       057C  pack
       0586  fpneg
       058D  fpneg2
       0593  saveR8toR25
       05A2  restoreR8toR25
       05B1  fpmule
       0601  fpmule1
       060B  fpmule2
       0616  fpmule1x
       0623  fpcmp
       0630  fpcmp1
       063B  fpcmp2
       0647  _satan
       06B8  _xatan
       0719  _asinf
       07C3  _atan2f
       0888  _frexpf
       08F4  _sqrtf
       0A39  __text_end

Area                               Addr   Size   Decimal Bytes (Attributes)
--------------------------------   ----   ----   ------- ----- ------------
                            data   0200   0005 =      5. bytes (rel,con,ram)

       Addr  Global Symbol
      -----  --------------------------------
       0200  __data_start
       0200  _display
       0205  __data_end

Area                               Addr   Size   Decimal Bytes (Attributes)
--------------------------------   ----   ----   ------- ----- ------------
                             bss   0205   0002 =      2. bytes (rel,con,ram)

       Addr  Global Symbol
      -----  --------------------------------
       0205  _errno
       0205  __bss_start
       0207  __bss_end

Area                               Start  End    Decimal Bytes (Attributes)
--------------------------------   ----   ----   ------- ----- ------------
                          vector   0000   0004 =      4. bytes (abs,ovr,rom)

Files Linked      [ module(s) ]

C:\iccv7avr\lib\crtatmega.o	[ crtatmega.s ]
AVR_GY-27.o	[ AVR_GY ]
<library>	[ asave.s, div16u.s, elpm32.s, gpop3.s, gpush.s, gpushx.s, gpushy.s, gpushz.s, gpusha.s, lneg.s, lsl32.s ]
[ fpadd.s, fpadd1.s, fpadd1x.s, fpadd2.s, fpadd2x.s, fpsub2.s, fpint.s, int2fp.s, fpdiv_new.s, fputil.s ]
[ fpmule.s, fpmule1.s, fpmule2.s, fpmule1x.s, fpcmp.s, fpcmp1.s, fpcmp2.s, asinf.s, atan2f.s, frexpf.s ]
[ sqrtf.s, errno.s ]

User Global Definitions

ram_end = 0x21ff
hwstk_size = 0x1e

User Base Address Definitions

func_lit = 0xe4
data = 0x200
eeprom:0.4096

