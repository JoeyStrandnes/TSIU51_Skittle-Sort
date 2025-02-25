//////// TSIU51 SKITTLE SORT ////////////////////////////////////////////////
//////// ATMEGA16A CONFIG ///////////////////////////////////////////////////
//CPU CLOCK 8 MHz
//BOOT FUSE 64 ms
//////// RBG_SENSOR STATIC REGISTERS ////////////////////////////////////////
.equ RGB_ENABLE =0x00
.equ RGB_ATIME = 0x01
.equ RGB_WTIME = 0x03
.equ RGB_AILTL = 0x04
.equ RGB_AILTH = 0x05
.equ RGB_AIHTL = 0x06
.equ RGB_AIHTH = 0x07
.equ RGB_PERS  = 0x0C
.equ RGB_CONFIG = 0x0D
.equ RGB_CONTROL = 0x0F
.equ RGB_ID = 0x12
.equ RGB_STATUS = 0x13
.equ RGB_CDATAL = 0x14
.equ RGB_CDATAH = 0x15
.equ RGB_RDATAL = 0x16
.equ RGB_RDATAH = 0x17
.equ RGB_GDATAL = 0x18
.equ RGB_GDATAH = 0x19
.equ RGB_BDATAL = 0x1A
.equ RGB_BDATAH = 0x1B

.equ RGB_COMMAND_BIT = 0x80
.equ RGB_AUTO_INC_BIT = 0b00100000
//////// RGB-SENSOR USER CONFIG ////////////////////////////////////////
.equ ATIME_VALUE = 0xD0 // NUMBER OF INTEGRATION CYCLES = 256-ATIME_VALUE (0xFF+1 -ATIME_VALUE) WITH EACH CYCLE TAKING 2.5 ms 
.equ GAIN_VALUE  = 0x00 //00=1X, 01=4X, 10=16X, 11=60X
//////// COLOR COMPARE CONFIG /////////////////////////////////////////
.equ PRECISION   = 64  //SCALES UP OUR REFERENCE-CLEARVALUES FOR MATH REASONS. CLEARDATA*PRECISION SHOULD BE AS CLOSE TO 16 BIT WITHOUT OVERFLOWING
.equ PRECISION_EXP = 6  // EXPONENT OF PRECISION IN BASE 2
.equ CLEAR_DIFF_DIV = 8  // SCALES DOWN OUR CLEAR-DIFFERENCE BY THIS NUMBER TO GIVE IT LESS INFLUENCE ON OVERALL DIFFERENCE
.equ CLEAR_DIFF_DIV_EXP = 3 // EXPONENT OF CLEAR_DIFF_DIV IN BASE 2
//////// COLOR ALIAS //////////////////////////////////////////////////
.equ NUMBER_OF_COLORS = 6 //5 or 6, depends on if we want NO_SKITTLE
.equ RED_SKITTLE    = 0
.equ GREEN_SKITTLE  = 1
.equ ORANGE_SKITTLE = 2
.equ YELLOW_SKITTLE = 3
.equ PURPLE_SKITTLE = 4
.equ NO_SKITTLE     = 5
//////// TWI USER CONFIG ////////////////////////////////////////////////
.equ TWI_BITRATE   = 32  //100kHz
.equ TWI_PRESCALAR = 0 //100kHz
//////// TWI SLAVE ADDR /////////////////////////////////////////////////
.equ RGB_SLAVE_ADDR = 0x29
.equ MCU_SLAVE_ADDR = 0x69
//////// TWI TWSR HANDLING CODES ////////////////////////////////////////	
.equ TWSR_TWI_START = 0x08
.equ TWSR_TWI_REP_START		= 0x10
.equ TWSR_MT_SLA_ACK		= 0x18
.equ TWSR_MT_SLA_NACK		= 0x20 //PROBLEM
.equ TWSR_MT_DATA_ACK		= 0x28
.equ TWSR_MT_DATA_NACK		= 0x30 //PROBLEM
.equ TWSR_ARBITRATION_LOST	= 0x38 //PROBLEM

.equ TWSR_MR_SLA_ACK		= 0x40
.equ TWSR_MR_SLA_NACK		= 0x48 //PROBLEM
.equ TWSR_MR_DATA_ACK		= 0x50
.equ TWSR_MR_DATA_NACK		= 0x58
//////// LCD CONSTANTS /////////////////////////////////////////////////
.equ RS = 0
.equ RW = 1
.equ E = 2
.equ Clear_Display = 0b00000001
.equ Return_Home   = 0b00000010
.equ Second_Line_Address = 0b11000000
//////// SKITTLE REFERENCE VALUES /////////////////////////////////////
// ALL CLEAR-VALUE*PRECISION MUST BE WITHIN 16bit
// REFERENCE VALUES MEASURED WITH: GAIN_VALUE = 0x00, ATIME_VALUE = 0xD0
//RED:
	.equ RED_CLEAR = 679
	.equ RED_RED = 232
	.equ RED_GREEN = 222
	.equ RED_BLUE = 200

//GREEN:
	.equ GREEN_CLEAR = 708
	.equ GREEN_RED = 226
	.equ GREEN_GREEN = 248
	.equ GREEN_BLUE = 211

//ORANGE:
	.equ ORANGE_CLEAR = 733
	.equ ORANGE_RED = 261
	.equ ORANGE_GREEN = 239
	.equ ORANGE_BLUE = 211

//YELLOW:
	.equ YELLOW_CLEAR = 763
	.equ YELLOW_RED = 267
	.equ YELLOW_GREEN = 261
	.equ YELLOW_BLUE = 217

//PURPLE:
	.equ PURPLE_CLEAR = 674
	.equ PURPLE_RED = 218
	.equ PURPLE_GREEN = 226
	.equ PURPLE_BLUE = 205

//NO_SKITTLE:
	.equ NO_SKITTLE_CLEAR = 651
	.equ NO_SKITTLE_RED = 208
	.equ NO_SKITTLE_GREEN = 220
	.equ NO_SKITTLE_BLUE = 198
//////// MEMORY LAYOUT //////////////////////////////////////////////
	.dseg
	.org 0x0060 //SRAM_START
//////// LATEST CRGB-VALUES /////////////////////////////////////////
CDATAL:	.byte 1
CDATAH:	.byte 1
RDATAL:	.byte 1
RDATAH:	.byte 1
GDATAL:	.byte 1
GDATAH:	.byte 1
BDATAL:	.byte 1
BDATAH:	.byte 1

//////// LATEST SKITTLE DIFFERENCES ///////////////////////////////////
RED_SKITTLE_DIFF:
	.byte 2
GREEN_SKITTLE_DIFF:
	.byte 2
ORANGE_SKITTLE_DIFF:
	.byte 2
YELLOW_SKITTLE_DIFF:
	.byte 2
PURPLE_SKITTLE_DIFF:
	.byte 2
NO_SKITTLE_DIFF:
	.byte 2
//////// COLOR OF LATEST SKITTLE SORTED ///////////////////////////////////
// 0 = RED, 1 = GREEN, 2 = ORANGE, 3 = YELLOW, 4 = PURPLE, 5 = NO_SKITTLE
LATEST_SKITTLE_COLOR:
	.byte 1
//////// NUMBER OF SKITTLES SORTED ////////////////////////////////////////
RED_N:
	.byte 1
GREEN_N:
	.byte 1
ORANGE_N:
	.byte 1
YELLOW_N:
	.byte 1
PURPLE_N:
	.byte 1
NO_SKITTLE_N:
	.byte 1
//////// CURRENT TWI SLAVE //////////////////////////////////////////////
CURRENT_SLAVE:
	.byte 1
	.cseg
//END OF MEMORY LAYOUT
//////// RESET/INTERRUPT VECTORS ////////////////////////////////////////
.org 0
	jmp	BOOT
.org INT0ADDR
	jmp	ISR_INT0	
/////////////////////////////////////////////////////////////////////////
.org 0x02A
BOOT://FUSE IS SET TO 64 ms STARTUP 

	ldi	r16, HIGH(RAMEND)
	out	SPH, r16
	ldi	r16, LOW(RAMEND)
	out	SPL, r16

	ldi	YH,HIGH(SRAM_START)
	ldi	YL,LOW(SRAM_START) 
	ldi	r16, 28 //NUMBER OF BYTES IN SRAM
	call	INIT_CLEAR_SRAM // CLEAR N BYTES FROM Y POINTER
	call	INT0_INIT
	call	TWI_INIT
	call	LCD_INIT
	call	RGB_INIT
	call	UPDATE_DISPLAY
	sei 
	jmp MAIN

///////////////////////////////////////////////////////////////////

MAIN:	
	rjmp	MAIN

///////////////////////////////////////////////////////////////////
ISR_INT0:
	push	r16
	in	r16, SREG
	push	r16

	call	RGB_DELAY_INTEGRATION
	call	RGB_DELAY_INTEGRATION //EXTRA DELAY TO BE SURE DATA IS VALID
	call	READ_ALL_8_RGB_REGISTERS_INTO_SRAM 
	call	COMPARE
	call	COLOR_MATCH
	call	UPDATE_NUMBER_OF_SKITTLES
	call	UPDATE_DISPLAY
	call	SEND_SKITTLE_COLOR_TO_SLAVE

	pop	r16
	out	SREG, r16
	pop	r16
	reti
///////////////////////////////////////////////////////////////////
COMPARE:
	push	XH
	push	XL
	push	YH
	push	YL
	push	ZH
	push	ZL
	push	r16

	ldi	YH, HIGH(RED_SKITTLE_DIFF)
	ldi	YL, LOW(RED_SKITTLE_DIFF) 
	ldi	r16, 2*NUMBER_OF_COLORS
	call	INIT_CLEAR_SRAM //CLEAR OLD DIFFERENCES

	ldi	ZH, HIGH(REF_VALUES*2)
	ldi	ZL, LOW(REF_VALUES*2)
	ldi	XH, HIGH(RED_SKITTLE_DIFF)
	ldi	XL, LOW(RED_SKITTLE_DIFF)
	ldi	r16, NUMBER_OF_COLORS //LOOP COUNTER
COMPARE_NEXT_SKITTLE:

	ldi	YH, HIGH(CDATAL)
	ldi	YL, LOW(CDATAL)
	call	COMPUTE_REFERENCE_DIFFERENCE
	call	SCALE_DOWN_DIFFERENCE 

	ldi	YH, HIGH(RDATAL)
	ldi	YL, LOW(RDATAL)
	call	GET_RGB_DIFFERENCE

	ldi	YH, HIGH(GDATAL)
	ldi	YL, LOW(GDATAL)
	call	GET_RGB_DIFFERENCE

	ldi	YH, HIGH(BDATAL)
	ldi	YL, LOW(BDATAL)
	call	GET_RGB_DIFFERENCE

	adiw	XH:XL, 2 //RED_SKITTLE_DIFF -> GREEN_SKITTLE_DIFF ...
	adiw	ZH:ZL, 8 //RED_SKITTLE REFERENCE VALUES -> GREEN_SKITTLE REFERENCE VALUES ...
	
	dec	r16
	brne	COMPARE_NEXT_SKITTLE

	pop	r16
	pop	ZL
	pop	ZH
	pop	YL
	pop	YH
	pop	XL
	pop	XH
	ret
///////////////////////////////////////////////////////////////////
SCALE_DOWN_DIFFERENCE:
	push	XH
	push	XL
	push	r16
	push	r17
	push	r18

	ld	r16, X+
	ld	r17, X+
	ldi	r18, CLEAR_DIFF_DIV_EXP //DIV BY 2^r18
SCALE_DOWN_DIFFERENCE_LOOP:
	clc
	ror	r17
	ror	r16
	dec	r18
	brne	SCALE_DOWN_DIFFERENCE_LOOP
	st	-X, r17
	st	-X, r16

	pop	r18
	pop	r17
	pop	r16
	pop	XL
	pop	XH
	ret
///////////////////////////////////////////////////////////////////
GET_RGB_DIFFERENCE:
	push	r16
	ldd	r16, Y+0 
	push	r16 //PUSH RGBDATAL
	ldd	r16, Y+1 
	push	r16 //PUSH RGBDATAH

	call	NORMALIZE_RGB_DATA 
	call	COMPUTE_REFERENCE_DIFFERENCE 

	pop	r16 //POP RGBDATAH
	std	Y+1, r16 
	pop	r16 //POP RGBDATAL
	std	Y+0, r16 
	pop	r16 
	ret
///////////////////////////////////////////////////////////////////
// RELIES ON:
// Z POINTER ON CLEAR VALUE OF SKITTLECOLOR IN LOOKUPTABLE.
// Y POINTER ON R,G OR B IN SRAM
NORMALIZE_RGB_DATA:
	push	ZH
	push	ZL
	push	r14
	push	r15
	push	r16
	push	r17
	push	r18
	push	r19
	push	r20
	push	r21
	push	r22
	push	r23

	lpm	r16, Z+ //LOAD CLEAR VALUE FROM LOOKUP TABLE INTO FIRST MULTIPLIER
	lpm	r17, Z  //LOAD CLEAR VALUE FROM LOOKUP TABLE INTO FIRST MULTIPLIER	
	ldi	r18, LOW(PRECISION) //LOAD PRECISION CONSTANT INTO SECOND MULTIPLIER
	ldi	r19, HIGH(PRECISION)//LOAD PRECISION CONSTANT INTO SECOND MULTIPLIER
	call	MULTI16 //WANT MULTIPLIERS IN r19:r18 AND r17:r16. RESULT IN r21:r20:r19:r18

	mov	r16, r18 //MOVE SCALED UP CLEAR VALUE INTO DIVIDEND
	mov	r17, r19 //MOVE SCALED UP CLEAR VALUE INTO DIVIDEND
	lds	r18, CDATAL  //LOADS THE CLEAR-VALUE FROM SRAM INTO DIVISOR
	lds	r19, CDATAH  //LOADS THE CLEAR-VALUE FROM SRAM INTO DIVISOR
	call	div16u //RESULT IN R17:R16. REMAINDER IN R15:R14
	
	////// QUOTIENT ///////
	//RESULT FROM DIVISION IS IN FIRST MULTIPLIER
	ldd	r18, Y+0 //LOAD RGBDATAL INTO SECOND MULTIPLIER
	ldd	r19, Y+1 //LOAD RGBDATAH INTO SECOND MULTIPLIER
	call	MULTI16 //WANT MULTIPLIERS IN r19:r18 AND r17:r16. RESULT IN r21:r20:r19:r18
	call	DIVIDE_BY_PRECISION  //EXPECTS 32BIT IN r21:r20:r19:r18. RESULT IN r21:r20:r19:r18

	mov	r22, r18 //SAVE QUOTIENT 
	mov	r23, r19 //SAVE QUOTIENT

	////// REMAINDER ///////
	mov	r16, r14 //MOVES REMAINDER INTO MULTIPLIER
	mov	r17, r15 //MOVES REMAINDER INTO MULTIPLIER
	ldd	r18, Y+0 //LOAD RGBDATAL INTO MULTIPLIER
	ldd	r19, Y+1 //LOAD RGBDATAH INTO MULTIPLIER
	call	MULTI16 //WANT MULTIPLIERS IN r19:r18 AND r17:r16. RESULT IN r21:r20:r19:r18
	call	DIVIDE_BY_PRECISION //EXPECTS 32BIT IN r21:r20:r19:r18. RESULT IN r21:r20:r19:r18

	mov	r16, r18 //MOVES RESULT INTO DIVIDEND
	mov	r17, r19 //MOVES RESULT INTO DIVIDEND
	lds	r18, CDATAL //LOADS THE CLEAR-VALUE FROM SRAM INTO DIVISOR
	lds	r19, CDATAH //LOADS THE CLEAR-VALUE FROM SRAM INTO DIVISOR
	call	div16u  //RESULT IN R17:R16. REMAINDER IN R15:R14
	
	add	r22, r16 //ADD RESULT TO QUOTIENT
	adc	r23, r17 //ADD RESULT TO QUOTIENT
	std	Y+0, r22 //STORES THE NORMALIZED RGBDATA BACK INTO SRAM
	std	Y+1, r23 //STORES THE NORMALIZED RGBDATA BACK INTO SRAM

	pop	r23
	pop	r22
	pop	r21
	pop	r20
	pop	r19
	pop	r18
	pop	r17
	pop	r16
	pop	r15
	pop	r14
	pop	ZL
	pop	ZH
	ret
///////////////////////////////////////////////////////////////////
DIVIDE_BY_PRECISION://EXPECTS 32BIT IN R21:R20:R19:R18 
	push	r22
	push	r23
	ldi	r22, PRECISION_EXP 
	clr	r23 //ZERO
ROTATE_AGAIN:
	clc
	ror	r21
	ror	r20
	ror	r19
	ror	r18

	adc	r18, r23 //ROUND UP
	adc	r19, r23
	adc	r20, r23
	adc	r21, r23

	dec	r22
	brne	ROTATE_AGAIN	
	pop	r23
	pop	r22
	ret
///////////////////////////////////////////////////////////////////
// RELIES ON:
// X POINTER ON SKITTLECOLOR-DIFFERENCE IN SRAM
// Z POINTER ON CLEAR VALUE OF SKITTLECOLOR IN LOOKUPTABLE.
// Y POINTER ON C, R, G OR B IN SRAM
COMPUTE_REFERENCE_DIFFERENCE:	
	push	XH
	push	XL
	push	ZH
	push	ZL
	push	r16
	push	r17
	push	r24
	push	r25
	//ADD OFFSET TO Z POINTER USING Y POINTER
	ldi	r16, LOW(CDATAL)
	ldi	r17, HIGH(CDATAL)
	mov	r24, YL
	mov	r25, YH
	sub	r24, r16
	sbc	r25, r17
	add	ZL, r24 
	adc	ZH, r25 

	lpm	r16, Z+ //LOW BYTE OF REFERENCE-VALUE
	lpm	r17, Z  //HIGH BYTE OF REFERENCE-VALUE
	ldd	r24, Y+0  //LOADS CRGBDATAL
	ldd	r25, Y+1  //LOADS CRGBDATAH

	sub	r24, r16 //COMPUTE DIFFERENCE
	sbc	r25, r17 //COMPUTE DIFFERENCE
	brcc	SAVE_DIFFERENCE
	neg	r24	//GET ABSOLUTE VALUE OF DIFFERENCE IF NEGATIVE
	com	r25 //GET ABSOLUTE VALUE OF DIFFERENCE IF NEGATIVE
SAVE_DIFFERENCE:

	ld	r16, X+ // GET PREVIOUS VALUE IN SRAM
	ld	r17, X+ // GET PREVIOUS VALUE IN SRAM

	add	r16, r24 //ADD TO PREVIOUS DIFFERENCE
	adc	r17, r25 //ADD TO PREVIOUS DIFFERENCE
	brcc	DIFFERENCE_OK
	ldi	r16, 0xFF //SET DIFF TO MAX
	ldi	r17, 0xFF //SET DIFF TO MAX
DIFFERENCE_OK:
	
	st	-X, r17 //STORE NEW DIFFERENCE
	st	-X, r16 //STORE NEW DIFFERENCE

	pop	r25
	pop	r24
	pop	r17
	pop	r16
	pop	ZL
	pop	ZH
	pop	XL
	pop	XH
	ret
///////////////////////////////////////////////////////////////////
COLOR_MATCH:
	push	YH
	push	YL
	push	ZH
	push	ZL
	push	r16
	push	r17
	push	r18
	push	r19
	push	r20

	ldi	ZH, HIGH(RED_SKITTLE_DIFF) 
	ldi	ZL, LOW(RED_SKITTLE_DIFF)
	ldi	YH, HIGH(GREEN_SKITTLE_DIFF)
	ldi	YL, LOW(GREEN_SKITTLE_DIFF)
	ldi	r20, NUMBER_OF_COLORS-1 //NUMBER OF COMPARES
	//Z POINTS TO THE SMALLEST VALUE
COLOR_MATCH_NEXT_SKITTLE:
	ldd	r16, Z+0
	ldd	r17, Z+1
	ldd	r18, Y+0
	ldd	r19, Y+1
	// Z < Y ?
	sub	r16, r18
	sbc	r17, r19
	brmi	Z_POINTER_STAYS 
	brlo	Z_POINTER_STAYS 

	mov	ZH, YH
	mov	ZL, YL
Z_POINTER_STAYS:
	adiw	YH:YL, 2
	dec	r20
	brne	COLOR_MATCH_NEXT_SKITTLE
	// GET OFFSET ALIAS FOR COLOR OF SKITTLE THAT IS CLOSEST
	subi	ZL, LOW(RED_SKITTLE_DIFF) //END POINT - START POINT
	lsr	ZL //SINCE EACH DIFF IS 2 BYTE OFFSET IS HALVED
	sts	LATEST_SKITTLE_COLOR, ZL

	pop	r20
	pop	r19
	pop	r18
	pop	r17
	pop	r16
	pop	ZL
	pop	ZH
	pop	YL
	pop	YH
	ret
///////////////////////////////////////////////////////////////////
INT0_INIT:
	push	r16
	ldi	r16, (1<<ISC01) | (1<<ISC00)
	out	MCUCR, r16
	ldi	r16, (1<<INT0)
	out	GICR, r16
	pop	r16
	ret
///////////////////////////////////////////////////////////////////
INIT_CLEAR_SRAM:
	push	r17
	clr	r17
INIT_CLEAR_SRAM_LOOP:
	st	Y+, r17
	dec	r16
	brne	INIT_CLEAR_SRAM_LOOP
	pop	r17
	ret
///////////////////////////////////////////////////////////////////
RGB_INIT:
	push	r17

	ldi	r17, RGB_SLAVE_ADDR
	sts	CURRENT_SLAVE, r17
	//
	call	TWI_START_PULSE
	call	TWI_SEND_ADDRESS_WRITE
	call	TWI_ERROR_HANDLER

	ldi	r17, RGB_ENABLE | RGB_COMMAND_BIT
	call	TWI_SEND_DATA 

	ldi	r17, 0b00000001 //PON
	call	TWI_SEND_DATA
	call	RGB_DELAY // WAIT 2.5 ms after PON
	//
	call	TWI_START_PULSE
	call	TWI_SEND_ADDRESS_WRITE

	ldi	r17, RGB_ATIME | RGB_COMMAND_BIT
	call	TWI_SEND_DATA 

	ldi	r17, ATIME_VALUE //ATIME
	call	TWI_SEND_DATA
	//
	call	TWI_START_PULSE
	call	TWI_SEND_ADDRESS_WRITE

	ldi	r17, RGB_CONTROL | RGB_COMMAND_BIT
	call	TWI_SEND_DATA 

	ldi	r17, GAIN_VALUE
	call	TWI_SEND_DATA
	//
	call	TWI_START_PULSE
	call	TWI_SEND_ADDRESS_WRITE

	ldi	r17, RGB_ENABLE | RGB_COMMAND_BIT
	call	TWI_SEND_DATA 

	ldi	r17, 0b00000011 //AEN,PON
	call	TWI_SEND_DATA
	//
	call	TWI_STOP_PULSE
	
	pop	r17
	ret
///////////////////////////////////////////////////////////////////
RGB_SHUTDOWN:
	push	r17
	ldi	r17, RGB_SLAVE_ADDR
	sts	CURRENT_SLAVE, r17

	call	TWI_START_PULSE
	call	TWI_SEND_ADDRESS_WRITE

	ldi	r17, RGB_ENABLE
	ori	r17, RGB_COMMAND_BIT
	call	TWI_SEND_DATA 

	ldi	r17, 0b00000000 //TURN OFF
	call	TWI_SEND_DATA
	call	TWI_STOP_PULSE
	pop	r17
	ret
///////////////////////////////////////////////////////////////////
TWI_INIT: //SCL FREQ = MC CPU FREQ/(16+2*TWBR *4^TWPS) 
	push	r16
	ldi	r16, TWI_BITRATE   
	out	TWBR, r16
	ldi	r16, TWI_PRESCALAR 
	out	TWSR, r16
	ldi	r16, (1<<TWEN)
	out	TWCR, r16
	pop	r16
	ret
///////////////////////////////////////////////////////////////////
TWI_READ_DATA_ACK: // READS DATA INTO R17
	push	r16
	ldi	r16, (1<<TWINT) | (1<<TWEN) | (1<<TWEA)
	out	TWCR, r16
	call	TWI_WAIT
	/////ERROR?//////
	in	r17, TWDR
	pop	r16
	ret
///////////////////////////////////////////////////////////////////
TWI_READ_DATA_NACK: // READS DATA INTO R17
	push	r16
	ldi	r16, (1<<TWINT) | (1<<TWEN) 
	out	TWCR, r16
	call	TWI_WAIT
	/////ERROR?//////
	in	r17, TWDR
	pop	r16
	ret
///////////////////////////////////////////////////////////////////
TWI_SEND_DATA: // EXPECTS DATA TO SEND IN R17
	push	r16
	out	TWDR, r17
	ldi	r16, (1<<TWINT) | (1<<TWEN)
	out	TWCR, r16 
	call	TWI_WAIT
	/////ERROR?/////
	pop	r16
	ret
///////////////////////////////////////////////////////////////////
START_CONNECTION:
	call	TWI_START_PULSE
	call	TWI_SEND_ADDRESS_WRITE
	call	TWI_STOP_PULSE
	call	TWI_START_PULSE
	ret
///////////////////////////////////////////////////////////////////
TWI_SEND_ADDRESS_WRITE: // LOOKS IN SRAM FOR CURRENT ADDRESSED SLAVE
	push	r16
	push	r17
	lds	r17, CURRENT_SLAVE
	lsl	r17
	out	TWDR, r17
	ldi	r16, (1<<TWINT) | (1<<TWEN)
	out	TWCR, r16
	call	TWI_WAIT
	/////ERROR?///
	pop	r17
	pop	r16
	ret
///////////////////////////////////////////////////////////////////
TWI_SEND_ADDRESS_READ: // LOOKS IN SRAM FOR CURRENT ADDRESED SLAVE
	push	r16
	push	r17
	lds	r17, CURRENT_SLAVE
	lsl	r17
	ori	r17, 1
	out	TWDR, r17
	ldi	r16, (1<<TWINT) | (1<<TWEN)
	out	TWCR, r16
	call	TWI_WAIT
	/////ERROR?/////
	pop	r17
	pop	r16
	ret
///////////////////////////////////////////////////////////////////
TWI_ERROR_HANDLER:
	push	ZH
	push	ZL
	push	r16
	in	r16, TWSR
	andi	r16, 0xF8
	cpi	r16, TWSR_MT_SLA_NACK
	brne	NEXT_ERROR_CODE1
	ldi	ZH, HIGH(2*ERR_MT_SLA_NACK)
	ldi	ZL, LOW(2*ERR_MT_SLA_NACK)
	call	OUTPUT_DISPLAY_ERROR
	call	THREE_SECOND_DELAY

NEXT_ERROR_CODE1:
	cpi	r16, TWSR_MT_DATA_NACK
	brne	NEXT_ERROR_CODE2
	ldi	ZH, HIGH(2*ERR_MT_DATA_NACK)
	ldi	ZL, LOW(2*ERR_MT_DATA_NACK)
	call	OUTPUT_DISPLAY_ERROR
	call	THREE_SECOND_DELAY

NEXT_ERROR_CODE2:
	cpi	r16, TWSR_MR_SLA_NACK
	brne	NO_ERROR_CODE
	ldi	ZH, HIGH(2*ERR_MR_SLA_NACK)
	ldi	ZL, LOW(2*ERR_MR_SLA_NACK)
	call	OUTPUT_DISPLAY_ERROR
	call	THREE_SECOND_DELAY

NO_ERROR_CODE:
	pop	r16
	pop	ZL
	pop	ZH
	ret
///////////////////////////////////////////////////////////////////
TWI_START_PULSE:
	push	r16
	ldi	r16, (1<<TWINT) | (1<<TWSTA) | (1<<TWEN)
	out	TWCR, r16 //start
	call	TWI_WAIT
	pop	r16
	ret
///////////////////////////////////////////////////////////////////
TWI_STOP_PULSE:
	push	r16
	ldi	r16, (1<<TWINT) | (1<<TWSTO) | (1<<TWEN)
	out	TWCR, r16 //stop
	pop	r16
	ret
///////////////////////////////////////////////////////////////////
TWI_WAIT:
	in	r16, TWCR
	sbrs	r16, TWINT
	rjmp	TWI_WAIT
	ret
///////////////////////////////////////////////////////////////////
RGB_DELAY://2.55 ms delay at 8MHz. This is the time each integration cycle of the RGB-sensor takes worst case.
	push	r16
	push	r17
	ldi	r16, 25
	ldi	r17, 255
RGB_DELAY_LOOP:
	dec	r17
	brne	RGB_DELAY_LOOP
	dec	r16
	brne	RGB_DELAY_LOOP
	pop	r17
	pop	r16
	ret
///////////////////////////////////////////////////////////////////
RGB_DELAY_INTEGRATION:  //NUMBER OF INTEGRATION CYCLES = 256-ATIME_VALUE (0xFF+1-ATIME_VALUE)	
	push	r16
	call	RGB_DELAY //LOOPS ONCE IN ALL CASES
	ldi	r16, 0xFF-ATIME_VALUE
	cpi	r16, 0 //SPECIAL CASE OF ATIME_VALUE == 0xFF
	breq	RGB_DELAY_INTEGRATION_DONE

RGB_DELAY_INTEGRATION_LOOP:
	call	RGB_DELAY
	dec	r16
	brne	RGB_DELAY_INTEGRATION_LOOP

RGB_DELAY_INTEGRATION_DONE:
	pop	r16
	ret
///////////////////////////////////////////////////////////////////
READ_ALL_8_RGB_REGISTERS_INTO_SRAM:
	push	YH
	push	YL
	push	r16
	push	r17

	ldi	r16, RGB_SLAVE_ADDR
	sts	CURRENT_SLAVE, r16

	call	TWI_START_PULSE
	call	TWI_SEND_ADDRESS_WRITE
	call	TWI_ERROR_HANDLER

	ldi	r17, RGB_CDATAL |  RGB_COMMAND_BIT | RGB_AUTO_INC_BIT
	call	TWI_SEND_DATA
	call	TWI_ERROR_HANDLER

	call	TWI_START_PULSE
	call	TWI_SEND_ADDRESS_READ
	call	TWI_ERROR_HANDLER

	ldi	r16, 7 //Number of registers -1
	ldi	YH, HIGH(CDATAL)
	ldi	YL, LOW(CDATAL)

READ_NEXT_RBG_REGISTER:
	call	TWI_READ_DATA_ACK
	st	Y+, r17
	dec	r16
	brne	READ_NEXT_RBG_REGISTER
	
	call	TWI_READ_DATA_NACK //LAST READ WITH A NACK
	st	Y, r17
	call	TWI_STOP_PULSE

	pop	r17
	pop	r16
	pop	YL
	pop	YH
	ret
///////////////////////////////////////////////////////////////////
LCD_INIT:	
	push	r16
	push	r20
	ldi	r16, 0x00
	out	DDRA, r16 // DB0-DB7 set to READMODE as default, will change briefly when writing.
	ldi	r16, 0x07 
	out	DDRB, r16 // PIN0 - RS, PIN1- R/W, PIN2 - E set to WRITEMODE, will not change.

	ldi	r20, 0b00111100 // 2 LINE 5x8 MODE 
	call	LCD_INSTRUCTION_WRITE

	call	RGB_DELAY //REUSING DELAY FUNCTION

	ldi	r20, 0b00001100 // DISPLAY ON, CURSOR OFF, BLINK OFF
	call	LCD_INSTRUCTION_WRITE
	
	call	RGB_DELAY //REUSING DELAY FUNCTION

	ldi	r20, Clear_Display 
	call	LCD_INSTRUCTION_WRITE

	call	RGB_DELAY //REUSING DELAY FUNCTION

	ldi	r20, 0b00000110 // INCREMENT MODE, ENTIRE SHIFT OFF
	call	LCD_INSTRUCTION_WRITE 

	pop	r20
	pop	r16
	ret
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
SEND_SKITTLE_COLOR_TO_SLAVE:
	push	r17
	ldi	r17, MCU_SLAVE_ADDR
	sts	CURRENT_SLAVE, r17
	call	TWI_START_PULSE
	call	TWI_SEND_ADDRESS_WRITE
	call	TWI_ERROR_HANDLER

	lds	r17, LATEST_SKITTLE_COLOR
	cpi	r17, NO_SKITTLE
	brne	SEND_SKITTLE_COLOR
	ldi	r17, PURPLE_SKITTLE 
SEND_SKITTLE_COLOR:
	call	TWI_SEND_DATA
	call	TWI_ERROR_HANDLER
	call	TWI_STOP_PULSE
	pop	r17
	ret
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
UPDATE_NUMBER_OF_SKITTLES:
	push	r16
	push	YH
	push	YL
	//LOADS WHICH SKITTLE TO INC USING ITS POSITION AS OFFSET
	ldi	YH, HIGH(LATEST_SKITTLE_COLOR) //SRAM POSITION AFTER IS RED_N
	ldi	YL, LOW(LATEST_SKITTLE_COLOR)  //SRAM POSITION AFTER IS RED_N
	ld	r16, Y 
	inc	r16
UPDATE_NUMBER_OF_SKITTLES_LOOP:
	adiw	YH:YL, 1 
	dec	r16
	brne	UPDATE_NUMBER_OF_SKITTLES_LOOP	
	ld	r16, Y 
	inc	r16
	cpi	r16, 100
	brne	UNDER_MAX_COUNT
	ldi	r16, 99 //SET TO MAX DISPLAYED
UNDER_MAX_COUNT:
	st	Y, r16
	pop	YL
	pop	YH
	pop	r16
	ret
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
UPDATE_DISPLAY:
	push	r20
	push	YH
	push	YL

	ldi	r20, Clear_Display 
	call	LCD_INSTRUCTION_WRITE

	ldi	r20, 'R'
	call	LCD_DATA_WRITE
	ldi	r20, ':'
	call	LCD_DATA_WRITE
	ldi	YH, HIGH(RED_N)
	ldi	YL, LOW(RED_N)
	call	OUTPUT_DISPLAY_BYTE_TO_BCD

	ldi	r20, ' '
	call	LCD_DATA_WRITE

	ldi	r20, 'G'
	call	LCD_DATA_WRITE
	ldi	r20, ':'
	call	LCD_DATA_WRITE
	ldi	YH, HIGH(GREEN_N)
	ldi	YL, LOW(GREEN_N)
	call	OUTPUT_DISPLAY_BYTE_TO_BCD
	
	ldi	r20, ' '
	call	LCD_DATA_WRITE

	ldi	r20, 'O'
	call	LCD_DATA_WRITE
	ldi	r20, ':'
	call	LCD_DATA_WRITE
	ldi	YH, HIGH(ORANGE_N)
	ldi	YL, LOW(ORANGE_N)
	call	OUTPUT_DISPLAY_BYTE_TO_BCD

	ldi	r20, Second_Line_Address
	call	LCD_INSTRUCTION_WRITE

	ldi	r20, 'Y'
	call	LCD_DATA_WRITE
	ldi	r20, ':'
	call	LCD_DATA_WRITE
	ldi	YH, HIGH(YELLOW_N)
	ldi	YL, LOW(YELLOW_N)
	call	OUTPUT_DISPLAY_BYTE_TO_BCD
	
	ldi	r20, ' '
	call	LCD_DATA_WRITE

	ldi	r20, 'P'
	call	LCD_DATA_WRITE
	ldi	r20, ':'
	call	LCD_DATA_WRITE
	ldi	YH, HIGH(PURPLE_N)
	ldi	YL, LOW(PURPLE_N)
	call	OUTPUT_DISPLAY_BYTE_TO_BCD
	
	ldi	r20, ' '
	call	LCD_DATA_WRITE

	ldi	r20, 'N'
	call	LCD_DATA_WRITE
	ldi	r20, ':'
	call	LCD_DATA_WRITE
	ldi	YH, HIGH(NO_SKITTLE_N)
	ldi	YL, LOW(NO_SKITTLE_N)
	call	OUTPUT_DISPLAY_BYTE_TO_BCD
	
	pop	YL
	pop	YH
	pop	r20
	ret
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
UPDATE_DISPLAY_DEBUG:
	push r20
	push YH
	push YL

	ldi r20, Clear_Display 
	call LCD_INSTRUCTION_WRITE

	ldi r20, 'C'
	call LCD_DATA_WRITE
	ldi r20, ':'
	call LCD_DATA_WRITE
	ldi YH, HIGH(CDATAL)
	ldi YL, LOW(CDATAL)
	ldi r17, 4 //NUMBER OF DIGITS TO PRINT
	call OUTPUT_DISPLAY_BYTE_TO_BCD_MODULAR

	ldi r20, ' '
	call LCD_DATA_WRITE

	ldi r20, 'R'
	call LCD_DATA_WRITE
	ldi r20, ':'
	call LCD_DATA_WRITE
	ldi YH, HIGH(RDATAL)
	ldi YL, LOW(RDATAL)
	ldi r17, 4
	call OUTPUT_DISPLAY_BYTE_TO_BCD_MODULAR
	
	ldi r20, Second_Line_Address
	call LCD_INSTRUCTION_WRITE

	ldi r20, 'G'
	call LCD_DATA_WRITE
	ldi r20, ':'
	call LCD_DATA_WRITE
	ldi YH, HIGH(GDATAL)
	ldi YL, LOW(GDATAL)
	ldi r17, 4
	call OUTPUT_DISPLAY_BYTE_TO_BCD_MODULAR
	
	ldi r20, ' '
	call LCD_DATA_WRITE

	ldi r20, 'B'
	call LCD_DATA_WRITE
	ldi r20, ':'
	call LCD_DATA_WRITE
	ldi YH, HIGH(BDATAL)
	ldi YL, LOW(BDATAL)
	ldi r17, 4
	call OUTPUT_DISPLAY_BYTE_TO_BCD_MODULAR
	
	pop YL
	pop YH
	pop r20
	ret
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
OUTPUT_DISPLAY_BYTE_TO_BCD_MODULAR: //HOW MANY NUMBERS AS ARGUMENT IN R17. WANTS Y POINTER TO LOW BYTE OF NUMBER. WORKS FROM 1-4 DIGITS
	push	r17
	push	r18
	push	r19
	push	r20
	ldd	r18, Y+0
	ldd	r19, Y+1
	cpi	r19, HIGH(10000)
	brsh	NUMBER_TO_BIG
NEXT_BCD:	
	call	GET_BCD_DIGIT //LEAVES NUMBER IN R20
	subi	r20, -48 //ADD ASCII OFFSET
	call	LCD_DATA_WRITE 
	dec	r17
	brne	NEXT_BCD
	rjmp	OUTPUT_DISPLAY_BYTE_TO_BCD_MODULAR_DONE

NUMBER_TO_BIG:
	ldi	r20, 42 //PRINT ASTERIX IF NUMBER WAS TO BIG
	call	LCD_DATA_WRITE 
	dec	r17
	brne	NUMBER_TO_BIG

OUTPUT_DISPLAY_BYTE_TO_BCD_MODULAR_DONE:	
	pop	r17
	pop	r18
	pop	r19
	pop	r20
	ret
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
GET_BCD_DIGIT:
	push	r16
	push	r17
	push	r21 
	//NUMBER OF DIGITS IN R17
	clr	r20
	clr	r21 //ZERO

	ldi	r16, 1
	dec	r17
	breq	GET_DIGIT

	ldi	r16, 10
	dec	r17
	breq	GET_DIGIT

	ldi	r16, 100
	dec	r17
	breq	GET_DIGIT

	ldi	r16, LOW(1000) 
	ldi	r21, HIGH(1000) 
	dec	r17
GET_DIGIT:
	
	sub	r18, r16
	sbc	r19, r21
	brmi	GET_ASCII
	inc	r20 //LOOP COUNTER AND LCD OUTPUT REG
	jmp	GET_DIGIT
GET_ASCII:
	add	r18, r16 //RESTORE
	adc	r19, r21 //RESTORE	

	cpi	r20, 10
	brlo	DIGIT_OK
	ldi	r20, 42-48 //LOAD ASTERIX WITHOUT ASCII OFFSET

DIGIT_OK:
	pop	r21
	pop	r17
	pop	r16
	ret
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
OUTPUT_DISPLAY_BYTE_TO_BCD:
	push	r16
	push	r17
	push	r20
	clr	r17 
	ld	r16, Y
LOOP_AGAIN:
	subi	r16, 10 //LESS THAN 10?
	brmi	DIGITS_DONE
	inc	r17
	jmp	LOOP_AGAIN
	
DIGITS_DONE:
	subi	r16, -10 //RESTORE ONE'S POSITION

	mov	r20, r17 //MOVE TEN'S POSITION INTO LCD-REGISTER
	subi	r20, -48 //ADD ASCII OFFSET
	call	LCD_DATA_WRITE //WRITE TEN'S POSITION

	mov	r20, r16 //MOVE ONE'S POSITION INTO LCD-REGISTER
	subi	r20, -48 //ADD ASCII OFFSET
	call	LCD_DATA_WRITE //WRITE ONE'S POSITION 

	pop	r20
	pop	r17
	pop	r16
	ret
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
OUTPUT_DISPLAY_FROM_FLASH:
	push	ZH
	push	ZL
	push	r20
NEXT_CHAR:
	lpm	r20, Z+
	cpi	r20, 0
	breq	OUTPUT_DISPLAY_FROM_FLASH_DONE
	call	LCD_DATA_WRITE
	rjmp	NEXT_CHAR
OUTPUT_DISPLAY_FROM_FLASH_DONE:
	pop	r20
	pop	ZL
	pop	ZH
	ret
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
OUTPUT_DISPLAY_ERROR: //WANTS Z POINTER TO ERROR MSG
	push	ZH
	push	ZL
	push	r20

	ldi	r20, Clear_Display
	call	LCD_INSTRUCTION_WRITE

	push	ZH
	push	ZL
	ldi	ZH, HIGH(2*ERROR_GENERIC)
	ldi	ZL, LOW(2*ERROR_GENERIC)
	call	OUTPUT_DISPLAY_FROM_FLASH

	lds	r20, CURRENT_SLAVE

	ldi	ZH, HIGH(2*ERROR_RGB_SLAVE)
	ldi	ZL, LOW(2*ERROR_RGB_SLAVE)
	cpi	r20, RGB_SLAVE_ADDR
	breq	OUTPUT_WHICH_SLAVE

	ldi	ZH, HIGH(2*ERROR_MCU_SLAVE)
	ldi	ZL, LOW(2*ERROR_MCU_SLAVE)
	cpi	r20, MCU_SLAVE_ADDR
	breq	OUTPUT_WHICH_SLAVE

	ldi	ZH, HIGH(2*ERROR_GENERIC)
	ldi	ZL, LOW(2*ERROR_GENERIC)

OUTPUT_WHICH_SLAVE:
	call	OUTPUT_DISPLAY_FROM_FLASH

	ldi	r20, Second_Line_Address
	call	LCD_INSTRUCTION_WRITE

	pop	ZL
	pop	ZH
	call	OUTPUT_DISPLAY_FROM_FLASH

	pop	r20
	pop	ZL
	pop	ZH
	ret
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
LCD_INSTRUCTION_WRITE:
	push	r19
	ldi	r19, (0<<E)|(0<<RW)|(0<<RS) 
	out	PORTB, r19 
	call	LCD_WRITE
	pop	r19
	ret
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
LCD_DATA_WRITE:
	push	r19
	ldi	r19, (0<<E)|(0<<RW)|(1<<RS) 
	out	PORTB, r19 
	call	LCD_WRITE
	pop	r19
	ret
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
LCD_WRITE: //RS = 1 IS DATA, RS = 0 IS INSTRUCTION.  FINDS IF INSTR OR DATA IN r19. DATA/INSTRUCTION TO BE WRITTEN IS IN R20
	push	r16
	push	r19
	ldi	r16, 0xFF
	out	DDRA, r16 // PORTA NOW IN WRITE MODE
	out	PORTA, r20 

	ori	r19, (1<<E)
	out	PORTB, r19 //E PULSE STARTS
	nop
	nop
	nop
	andi	r19, 0xFB //FILTER OUT E 
	out	PORTB, r19 //E PULSE STOPS

	ldi	r16, 0x00
	out	DDRA, r16 // PORTA NOW IN READ MODE

	ldi	r16, (1<<RW)
	out	PORTB, r16 // LCD PUT INTO READMODE
	call	LCD_WAIT_IF_BUSY
	pop	r19
	pop	r16
	ret
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
LCD_WAIT_IF_BUSY:
	ldi	r16, (1<<E)|(1<<RW)|(0<<RS)
	out	PORTB, r16 //E PULSE STARTS
	nop
	nop
	nop
	andi	r16, 0xFB //FILTER OUT E 
	out	PORTB, r16 //E PULSE STOPS
	sbic	PINA, 7
	rjmp	LCD_WAIT_IF_BUSY
	ret
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
THREE_SECOND_DELAY:

; Generated by delay loop calculator
; at http://www.bretmulvey.com/avrdelay.html
;
; Delay 24 016 000 cycles
; 3s 2ms at 8.0 MHz
	push r18
	push r19
	push r20
	ldi  r18, 122
	ldi  r19, 214
	ldi  r20, 74
THREE_SECOND_DELAY_LOOP: 
	dec  r20
	brne THREE_SECOND_DELAY_LOOP
	dec  r19
	brne THREE_SECOND_DELAY_LOOP
	dec  r18
	brne THREE_SECOND_DELAY_LOOP

	pop r20
	pop r19
	pop r18
	ret
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
MULTI16: //MULTIPLIER 1 IN R17:R16, MULTIPLIER 2 IN R19:R18
	//RESULT IN R21:R20:R19:R18
	push	r0
	push	r1
	push	r2
	push	r3
	push	r4
	push	r5
	push	r22

	clr	r22 //ZERO
	mul	r17, r19 //MSB1*MSB2
	mov	r4, r0
	mov	r5, r1

	mul	r16, r18 //LSB1*LSB2
	mov	r2, r0
	mov	r3, r1

	mul	r17, r18 //MSB1*LSB2
	add	r3, r0
	adc	r4, r1
	adc	r5, r22 

	mul	r16, r19 //LSB1*MSB2
	add	r3, r0
	adc	r4, r1
	adc	r5, r22 

	mov	r18, r2
	mov	r19, r3
	mov	r20, r4
	mov	r21, r5

	pop	r22
	pop	r5
	pop	r4
	pop	r3
	pop	r2
	pop	r1
	pop	r0
	ret
//////////////// NOT OUR CODE - FROM AVR200 APPNOTE //////////////////////
;***************************************************************************
;*
;* "div16u" - 16/16 Bit Unsigned Division
;*
;* This subroutine divides the two 16-bit numbers 
;* "dd8uH:dd8uL" (dividend) and "dv16uH:dv16uL" (divisor). 
;* The result is placed in "dres16uH:dres16uL" and the remainder in
;* "drem16uH:drem16uL".
;*  
;* Number of words	:19
;* Number of cycles	:235/251 (Min/Max)
;* Low registers used	:2 (drem16uL,drem16uH)
;* High registers used  :5 (dres16uL/dd16uL,dres16uH/dd16uH,dv16uL,dv16uH,
;*			    dcnt16u)
;*
;***************************************************************************

;***** Subroutine Register Variables

.def	drem16uL=r14
.def	drem16uH=r15
.def	dres16uL=r16
.def	dres16uH=r17
.def	dd16uL	=r16
.def	dd16uH	=r17
.def	dv16uL	=r18
.def	dv16uH	=r19
.def	dcnt16u	=r20

;***** Code

div16u:	clr	drem16uL	;clear remainder Low byte
	sub	drem16uH,drem16uH;clear remainder High byte and carry
	ldi	dcnt16u,17	;init loop counter
d16u_1:	rol	dd16uL		;shift left dividend
	rol	dd16uH
	dec	dcnt16u		;decrement counter
	brne	d16u_2		;if done
	ret			;    return
d16u_2:	rol	drem16uL	;shift dividend into remainder
	rol	drem16uH
	sub	drem16uL,dv16uL	;remainder = remainder - divisor
	sbc	drem16uH,dv16uH	;
	brcc	d16u_3		;if result negative
	add	drem16uL,dv16uL	;    restore remainder
	adc	drem16uH,dv16uH
	clc			;    clear carry to be shifted into result
	rjmp	d16u_1		;else
d16u_3:	sec			;    set carry to be shifted into result
	rjmp	d16u_1


////// FLASH TABLES ////////////////////////////////////////////////////////////////////////////////////////////
.org 0x1900 
REF_VALUES:
	.db	LOW(RED_CLEAR),    HIGH(RED_CLEAR),    LOW(RED_RED),    HIGH(RED_RED),    LOW(RED_GREEN),    HIGH(RED_GREEN),    LOW(RED_BLUE),    HIGH(RED_BLUE)
	.db	LOW(GREEN_CLEAR),  HIGH(GREEN_CLEAR),  LOW(GREEN_RED),  HIGH(GREEN_RED),  LOW(GREEN_GREEN),  HIGH(GREEN_GREEN),  LOW(GREEN_BLUE),  HIGH(GREEN_BLUE)
	.db	LOW(ORANGE_CLEAR), HIGH(ORANGE_CLEAR), LOW(ORANGE_RED), HIGH(ORANGE_RED), LOW(ORANGE_GREEN), HIGH(ORANGE_GREEN), LOW(ORANGE_BLUE), HIGH(ORANGE_BLUE)
	.db	LOW(YELLOW_CLEAR), HIGH(YELLOW_CLEAR), LOW(YELLOW_RED), HIGH(YELLOW_RED), LOW(YELLOW_GREEN), HIGH(YELLOW_GREEN), LOW(YELLOW_BLUE), HIGH(YELLOW_BLUE)
	.db	LOW(PURPLE_CLEAR), HIGH(PURPLE_CLEAR), LOW(PURPLE_RED), HIGH(PURPLE_RED), LOW(PURPLE_GREEN), HIGH(PURPLE_GREEN), LOW(PURPLE_BLUE), HIGH(PURPLE_BLUE)
	.db	LOW(NO_SKITTLE_CLEAR), HIGH(NO_SKITTLE_CLEAR), LOW(NO_SKITTLE_RED), HIGH(NO_SKITTLE_RED), LOW(NO_SKITTLE_GREEN), HIGH(NO_SKITTLE_GREEN), LOW(NO_SKITTLE_BLUE), HIGH(NO_SKITTLE_BLUE)

////// ERROR CODE STRINGS //////////////////////////////////////////////////////////////////////////////////////
ERROR_RGB_SLAVE:	.db	"RGB", 0
ERROR_MCU_SLAVE:	.db	"MCU", 0
ERROR_GENERIC:		.db	"ERROR:", 0
ERR_MT_SLA_NACK:	.db	"MT SLA NACK", 0
ERR_MT_DATA_NACK:	.db	"MT DATA NACK", 0
ERR_MR_SLA_NACK:	.db	"MR SLA NACK", 0
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
