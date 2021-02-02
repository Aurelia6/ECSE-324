#include <stdio.h> 
#include <stdlib.h>

#include "./drivers/inc/LEDs.h"
#include "./drivers/inc/slider_switches.h"
#include "./drivers/inc/HEX_displays.h"
#include "./drivers/inc/pushbuttons.h"
#include "./drivers/inc/HPS_TIM.h"
#include "./drivers/inc/address_map_arm.h"
#include "./drivers/inc/int_setup.h"
#include "./drivers/inc/ISRs.h"

int main(){
    int ASCII = 48; //from ASCII table

//2.1 - Drivers for slider switches and LEDS

    while(1){
        write_LEDs_ASM(read_slider_switches_ASM()); //while the sliders are "on", the linked LEDS are lighting
    }

//2.2 - HEX displays and push buttons - Write the value {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, A, b, C, d, E, F} on HEX display
/*
    int SW3_SW0 = 0xF;
 
	while(1){
		int slider_value = read_slider_switches_ASM();
       		 write_LEDs_ASM(slider_value);
       
        	int SW9 = 512;
        
		if(slider_value & SW9){
			HEX_clear_ASM(HEX0);
			HEX_clear_ASM(HEX1);
			HEX_clear_ASM(HEX2);
			HEX_clear_ASM(HEX3);
			HEX_clear_ASM(HEX4);
			HEX_clear_ASM(HEX5);
		}
		else{
			HEX_flood_ASM(HEX4);
			HEX_flood_ASM(HEX5);
			char val = (SW3_SW0 & slider_value);
            val = val + ASCII;
			int PB = (SW3_SW0 & read_PB_data_ASM());
			
			HEX_write_ASM(PB, val); //write the specified value (chosen from the slider switches) in the specified location (chosen from the push buttons)
		}
	}
*/
//3.1 - HPS timer driver - not graded
/*
	int count0 = 0, count1 = 0, count2 = 0, count3 = 0;     // initialize timer parameters

    // Time and push button counters
	HPS_TIM_config_t hps_tim;
 
	hps_tim.tim = TIM0|TIM1|TIM2|TIM3;
	hps_tim.timeout = 1000000;
	hps_tim.LD_en = 1;
	hps_tim.INT_en = 1;
	hps_tim.enable = 1;
 
	HPS_TIM_config_ASM(&hps_tim);
 
	while (1) {
        int slider_value = read_slider_switches_ASM();
		write_LEDs_ASM(slider_value);

		if (HPS_TIM_read_INT_ASM(TIM0)) {
			HPS_TIM_clear_INT_ASM(TIM0);
			if (++count0 == 16){
				count0 = 0;
            }
		HEX_write_ASM(HEX0, (count0 + ASCII)); //modified using the ASCII values
		}
 
		if (HPS_TIM_read_INT_ASM(TIM1)) {
			HPS_TIM_clear_INT_ASM(TIM1);
			if (++count1 == 16){
				count1 = 0;
            }
			HEX_write_ASM(HEX1, (count1 + ASCII)); //modified using the ASCII values
		}
 
		if (HPS_TIM_read_INT_ASM(TIM2)) {
			HPS_TIM_clear_INT_ASM(TIM2);
			if (++count2 == 16){
				count2 = 0;
            }
		HEX_write_ASM(HEX2, (count2 + ASCII)); //modified using the ASCII values
		}
 
		if (HPS_TIM_read_INT_ASM(TIM3)) {
			HPS_TIM_clear_INT_ASM(TIM3);
			if (++count3 == 16){
				count3 = 0;
            }
			HEX_write_ASM(HEX3, (count3 + ASCII)); //modified using the ASCII values
		}
    }
*/
//3.2 - Stopwatch - synchronous
/*
    // Time counter - TIM0
	HPS_TIM_config_t hps_tim;
	
	hps_tim.tim = TIM0;
	hps_tim.timeout = 10000;
	hps_tim.LD_en = 1;
	hps_tim.INT_en = 1;
	hps_tim.enable = 1;

	HPS_TIM_config_ASM(&hps_tim);

	HPS_TIM_config_t hps_tim_PB;
    
    //Push button counter - TIM1
	hps_tim_PB.tim = TIM1;
	hps_tim_PB.timeout = 5000;
	hps_tim_PB.LD_en = 1;
	hps_tim_PB.INT_en = 1;
	hps_tim_PB.enable = 1;

	HPS_TIM_config_ASM(&hps_tim_PB);

    //
	int milli_second = 0;
	int second = 0;
	int minute = 0;
	int t_start = 0;

	while(1){	
		if (HPS_TIM_read_INT_ASM(TIM0) && t_start) {
			HPS_TIM_clear_INT_ASM(TIM0);

			milli_second += 10;          // Timer is for 10 milliseconds
			if (milli_second >= 1000) {  // milli_second is within its range (1000)
				milli_second -= 1000;    // reset
				second++;               // when 1000 milliseconds are over, a second is added
				
				if (second >= 60) {     // second is within its range (60)
					second -= 60;       // reset
					minute++;           // when 60 seconds are over, a minute is added
 
					if (minute >= 60) { // minute is within its range (60)
						minute = 0;     // reset
					// we could keep going with the hours in the range (24), but we cannot print it on the HEX display anymore
					}
				}
			}
			//Convert digit to ASCII
			HEX_write_ASM(HEX0, ((milli_second % 100) / 10) + ASCII);   // millisecond 2nd most significant bit
			HEX_write_ASM(HEX1, (milli_second / 100) + ASCII);          // millisecond most significant bit
			HEX_write_ASM(HEX2, (second % 10) + ASCII);                 // second 2nd most significant bit
			HEX_write_ASM(HEX3, (second / 10) + ASCII);                 // second most significant bit
			HEX_write_ASM(HEX4, (minute % 10) + ASCII);                 // minute 2nd most significant bit
			HEX_write_ASM(HEX5, (minute / 10) + ASCII);                 // minute most significant bit
		}
 
		if (HPS_TIM_read_INT_ASM(TIM1)) {                  //Timer to read push buttons
			HPS_TIM_clear_INT_ASM(TIM1);
			int pushB = 0xF & read_PB_data_ASM();
			if ((pushB & 1) && (!t_start)) {               //Start timer
				t_start = 1;
			} else if ((pushB & 2) && (t_start)) {         //Stop timer
				t_start = 0;
			} else if (pushB & 4) {                        //Reset timer
				milli_second = 0;
				second = 0;
				minute = 0;
				t_start = 0; //Stop timer
				
				//Set every number to 0
				HEX_write_ASM(HEX0, ASCII);
				HEX_write_ASM(HEX1, ASCII);
				HEX_write_ASM(HEX2, ASCII);
				HEX_write_ASM(HEX3, ASCII);
				HEX_write_ASM(HEX4, ASCII);
				HEX_write_ASM(HEX5, ASCII);
                
			}
		}
	}
 */
// Part 4 - Interrupts - asynchronous
/*
	int_setup(2,(int[]){73, 199 }); 		                // case 73 and 199 are used from int_setup
	
	enable_PB_INT_ASM(PB0 | PB1 | PB2); 		            // enables the pushbuttons (ORR)

	HPS_TIM_config_t hps_tim; 				                // initializes timer

	hps_tim.tim = TIM0; 					                // one timer used
	hps_tim.timeout = 10000;				                // incrementing by milliseconds
	hps_tim.LD_en = 1;
	hps_tim.INT_en = 1;
	hps_tim.enable = 1;

	HPS_TIM_config_ASM(&hps_tim); 			                // initializes timer assembler

	int milli_second = 0;
	int second = 0;
	int minute = 0;
	int t_start=0;
	
	while (1) { 								            
		if (t_start && hps_tim0_int_flag) { 	            // if flag and timer are equal (1), first pb pressed
			milli_second += 10; 						    // timer starts
			hps_tim0_int_flag = 0;				            // flag reset to 0

			if (milli_second >= 1000) {
				milli_second -= 1000;
				second++;
				if (second >= 60) {
					second -= 60;
					minute++;
					if (minute >= 60) {			            // when minute surpasses 60, no more displays
						minute = 0; 				        // reset to 0
					}
				}
			}

			HEX_write_ASM(HEX0, ((milli_second % 100) / 10) + ASCII);  // millisecond 2nd most significant bit
			HEX_write_ASM(HEX1, (milli_second / 100) + ASCII);         // millisecond most significant bit
			HEX_write_ASM(HEX2, (second % 10) + ASCII);                // second 2nd most significant bit
			HEX_write_ASM(HEX3, (second / 10) + ASCII);                // second most significant bit
			HEX_write_ASM(HEX4, (minute % 10) + ASCII);                // minute 2nd most significant bit
			HEX_write_ASM(HEX5, (minute / 10) + ASCII);                // minute most significant bit
		}

		if (push_int_flag > 0){	                            // if the pushbutton flag is raised
			if(push_int_flag == 1)                          // if first button pressed, start timer
				t_start = 1;
			else if(push_int_flag == 2)                     // if second button pressed
				t_start = 0;			                    // timer paused
			else if((push_int_flag == 4)){                  // if third button pressed, reset
				milli_second = 0;
				second = 0;
				minute = 0;
				//all displays reset to display 0
				HEX_write_ASM(HEX0, ASCII);                    
				HEX_write_ASM(HEX1, ASCII);
				HEX_write_ASM(HEX2, ASCII);
				HEX_write_ASM(HEX3, ASCII);
				HEX_write_ASM(HEX4, ASCII);
				HEX_write_ASM(HEX5, ASCII);
			}
			push_int_flag = 0;
		}
	}
*/
    return 0;
}





