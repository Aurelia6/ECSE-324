#include <stdio.h> 
#include <stdlib.h>

#include "./drivers/inc/pushbuttons.h"
#include "./drivers/inc/slider_switches.h"
#include "./drivers/inc/VGA.h"
#include "./drivers/inc/ps2_keyboard.h"

//1. VGA 
//function declaration
void test_char(){
	int x, y;
	char c = 0;

	for (y = 0; y <= 59; y++)
		for (x = 0; x <= 79; x++)
			VGA_write_char_ASM(x, y, c++);
	}

void test_byte(){
	int x, y;
	char c = 0; 

	for (y = 0; y <= 59; y++)
		for (x = 0; x <= 79; x++)
			VGA_write_byte_ASM(x, y, c++);
}

void test_pixel(){
	int x, y;
	unsigned short colour = 0;  

	for (y = 0; y <= 239; y++)
		for (x = 0; x <= 319; x++)
			VGA_draw_point_ASM(x, y, colour++);
}

// main function - VGA
int main(){
	while (1){
		if(PB_data_is_pressed_ASM(PB0)){ //PB0 is pressed - print either bytes or chararacters
			if(read_slider_switches_ASM() != 0 ){ // if any of the slider switches is on (!=0) - print bytes
				test_byte();
			}	
			else if(read_slider_switches_ASM() == 0){ // if all the sliders are off (=0) - print characters
				test_char();
			}
		}
		if(PB_data_is_pressed_ASM(PB1)){ // if PB1 is pressed - print pixels
			test_pixel();
		}
		if(PB_data_is_pressed_ASM(PB2)){ // if PB2 is pressed - clear characters
			VGA_clear_charbuff_ASM();
		}
		if(PB_data_is_pressed_ASM(PB3)){ // if PB3 is pressed - clear pixels
			VGA_clear_pixelbuff_ASM();
		}
	}
	return 0;
}

//main function - ps2_keyboard
/*
int main(){
	int x = 0;
	int y = 0;
	char *data;
	VGA_clear_charbuff_ASM(); // clear the characters if represented on the screen
	VGA_clear_pixelbuff_ASM(); // clear the pixels if represented on the screen
	
	while(1){
		if (read_PS2_data_ASM(data)){ //data is give
			if(*data != 0){ //if data is valid
				VGA_write_byte_ASM(x, y, *data); // write 3 bytes - x, y, data
				x += 3; // x_position is moved by 3
				if (x > 79){
					x = 0;
					y += 1;
				}
				if (y > 59){
					x = 0;
					y = 0;
					VGA_clear_charbuff_ASM();
				}		
			}
		}
	}
	return 0;
}
*/