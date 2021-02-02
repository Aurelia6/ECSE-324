#include "./drivers/inc/vga.h"
#include "./drivers/inc/ISRs.h"
#include "./drivers/inc/LEDs.h"
#include "./drivers/inc/audio.h"
#include "./drivers/inc/HPS_TIM.h"
#include "./drivers/inc/int_setup.h"
#include "./drivers/inc/wavetable.h"
#include "./drivers/inc/pushbuttons.h"
#include "./drivers/inc/ps2_keyboard.h"
#include "./drivers/inc/HEX_displays.h"
#include "./drivers/inc/slider_switches.h"

/*
// Part 0 - Audio
int main() {
    // 48k samples per second
    // frequency 100Hz = 100 cycles/second
    // 48,000 samples/100 cycles = 480 samples/cycle
    // for samples between [0, 239] - signal = 1
    // for samples > 239 - toggle
    int samples = 0;
    int signal = 0x000FFFFF;                        // when the signal is 1
    while (1) {
        if (audio_write_data_ASM(signal, signal)) { // if the board is receiving data/signal
            samples++;                           // increase counter for samples
            if (samples > 239) { // if samples reaches 240 (half-cycle), reset the counter
                samples = 0;
                if (signal == 0x00000000) { // if signal = 0, change it to 1 (hexadecimal)
                    signal = 0x00FFFFFF;
                } else {          // if signal = 1, change it to 0 (hexadecimal)
                    signal = 0x0000000;
                }
            }
        }
    }
    return 0;
}
*/

// Part 1 and 2 - Make waves and Control waves
//Useful variables
int keysPressed[8] = { };
unsigned int t = 0;
int f = 0;
int volume_BB = 5;
float freqArr[] = { 130.813, 146.832, 164.814, 174.614, 195.998, 220.000,
        246.942, 261.626 };

//Useful Methods
double getSignal(float freq, int time) {
    int amplitude = 1;
    float index = (int) (freq * time) % 48000;
    int index_int = (int) index;
    float diff = index - index_int;
    float compl = 1 - diff;

    double signal = amplitude * (compl) * sine[index_int]
            + amplitude * diff * sine[index_int + 1];
    return signal;
}

double createSignal(int* keysPressed, int time) {
    int counter = 0;
    double totalSignal = 0;

    for (counter = 0; counter < 8; counter++) {
        if (keysPressed[counter] == 1) {
            totalSignal += getSignal(freqArr[counter], time);
        }
    }
    return totalSignal;
}



int main() {
    int_setup(1, (int[] ) { 199 }); // Case 199 (TIM0) is used from int_setup
    HPS_TIM_config_t hps_tim;
    hps_tim.tim = TIM0;
    hps_tim.timeout = 20; // Every 20 microseconds because of 48000Hz
    hps_tim.LD_en = 1;
    hps_tim.INT_en = 1;
    hps_tim.enable = 1;
    HPS_TIM_config_ASM(&hps_tim);

    //Variables
    int time = 0;
    int breaker = 0;
    int position = 0;

    //Volume declared earlier
    double sine = 0.0;
    char inputKey;
    char newKey = 0.0;

    while (1) {
        if (read_ps2_data_ASM(&inputKey)) { //Only execute if non-zero keyboard input
            // A, S, D, F, J, K, L,; --> C, D, E, F, G, A, B, C notes
            switch (inputKey) {  // if key is pressed
            case 0x1C: // A = C note
                if (breaker == 1) { // If key is released mark:
                    keysPressed[0] = 0; // Change Key status
                    breaker = 0; // Update Breaker
                } else {
                    keysPressed[0] = 1; // Otherwise mark key as pressed
                }
                break;

            case 0x1B: // S = D note
                if (breaker == 1) {
                    keysPressed[1] = 0;
                    breaker = 0;
                } else {
                    keysPressed[1] = 1;
                }
                break;

            case 0x23: // D = E note
                if (breaker == 1) {
                    keysPressed[2] = 0;
                    breaker = 0;
                } else {
                    keysPressed[2] = 1;
                }
                break;

            case 0x2B: // F = F note
                if (breaker == 1) {
                    keysPressed[3] = 0;
                    breaker = 0;
                } else {
                    keysPressed[3] = 1;
                }
                break;

            case 0x3B: // J = G note
                if (breaker == 1) {
                    keysPressed[4] = 0;
                    breaker = 0;
                } else {
                    keysPressed[4] = 1;
                }
                break;

            case 0x42: // K = A note
                if (breaker == 1) {
                    keysPressed[5] = 0;
                    breaker = 0;
                } else {
                    keysPressed[5] = 1;
                }
                break;

            case 0x4B: // L = B note
                if (breaker == 1) {
                    keysPressed[6] = 0;
                    breaker = 0;
                } else {
                    keysPressed[6] = 1;
                }
                break;

            case 0x4C: // ; = C note
                if (breaker == 1) {
                    keysPressed[7] = 0;
                    breaker = 0;
                } else {
                    keysPressed[7] = 1;
                }
                break;

            //Volume Controls
            case 0x49: // > = Volume up
                if (breaker == 1) {
                    if (volume_BB < 10) {
                        volume_BB++;
                    }
                    breaker = 0;
                }
                break;

            case 0x41: // < = Volume down
                if (breaker == 1) {
                    if (volume_BB > 0) {
                        volume_BB--;
                    }
                    breaker = 0;
                }
                break;

            case 0xF0: // The break code is the same for all keys
                breaker = 1;
                break;

            default:
                breaker = 0;
            }

        }
        sine = createSignal(keysPressed, time);
        sine = volume_BB * sine;

        if (hps_tim0_int_flag == 1) {                    // if flag is raised
            hps_tim0_int_flag = 0;                       // reset the flag to 0
            if (audio_write_data_ASM(sine, sine) == 1) { // if audio = 1, Only do stuff if there's space in the audio FIFO
                audio_write_data_ASM(sine, sine);
                time++;
            }
        }
    }

    //Reset time and sine wave
    sine = 0;
    if (time >= 47999) {
        time = 0;
    }
    return 0;
}
