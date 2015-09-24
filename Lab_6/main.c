#include <msp430.h>

void ConfigureAdc(void);

int main(void)
{
	static int value=0;
	static int i=0 ;
	static int light = 0;
	static int lightroom = 0;
	static int temp  = 0;
	static int temproom  = 0;
	static int touch = 0;
	static int touchroom = 0;
	static int LedTog = 0;
	static int LedOn = 0;
	static int ADCReading [3];

   WDTCTL = WDTPW + WDTHOLD;                                  // Stop WDT
   P1DIR |=  (BIT4 | BIT5 | BIT6);                            // set bits 4, 5, 6 as outputs
   P1DIR &= (~BIT0 | ~BIT1 | ~BIT2);                            // set bits 0, 1, 2 as inputs

   P2DIR |=  BIT0;							              // set bit 0 as outputs
   ConfigureAdc();
   P1OUT = 0x00;
// reading the initial room values, lightroom, touchroom, temoroom
   for(i=1; i<=5 ; i++)                                       // read all three analog values 5 times each and average
     {
       ADC10CTL0 &= ~ENC;
       while (ADC10CTL1 & BUSY);                              //Wait while ADC is busy
       ADC10SA = (unsigned)&ADCReading[0]; 					  //RAM Address of ADC Data, must be reset every conversion
       ADC10CTL0 |= (ENC | ADC10SC);                          //Start ADC Conversion
       while (ADC10CTL1 & BUSY);							  //Wait while ADC is busy

       light += ADCReading[0]; touch += ADCReading[1]; temp += ADCReading[2];  	// sum  all 5 reading for the three variables
     }
   lightroom = light/5; touchroom = touch/5; temproom = temp/5;          		// Average the 5 reading for the three variables

   for (;;)
   {
	   i = 0; temp = 0; light = 0; touch =0;                     // set all analog values to zsero
	   for(i=1; i<=5 ; i++)                                      // read all three analog values 5 times each and average
	   {
		   ADC10CTL0 &= ~ENC;
		   while (ADC10CTL1 & BUSY);                             //Wait while ADC is busy
		   ADC10SA = (unsigned)&ADCReading[0];                   //RAM Address of ADC Data, must be reset every conversion
		   ADC10CTL0 |= (ENC | ADC10SC);                         //Start ADC Conversion
		   while (ADC10CTL1 & BUSY);                             //Wait while ADC is busy
		   light += ADCReading[0]; touch += ADCReading[1]; temp += ADCReading[2];  // sum all 5 reading for the three variables
	   }
	   light = light/5; touch = touch/5; temp = temp/5;      // Average the 5 reading for the three variables
//-------------------------Student Code---------------------------------------------------

	   //Light controlling LED1 P1.4
	     if(light > lightroom*0.9 && light < lightroom*1.1)
	     {
	    	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 // dead zone, if light between these two limits, do nothing
	     }
	     else
	       {

	    	 if(light >= lightroom*1.1)								// Turn LED1 on
	    	 {
	    		 P1OUT |=  BIT4;
	    	 }

	    	 if(light <= lightroom*0.9)								// Turn LED1 off
	         {
	        	 P1OUT &= ~BIT4;
	         }
	       }

	   //Temperature Controlling LED2 P1.5
	     if(temp > 220 && temp < 226)
	     {
	    	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 // dead zone, if temp between these two limits, do nothing
	     }
	     else
	       {

	    	 if(temp >= 226)										// Turn LED2 on
	    	 {
	    		 P1OUT |=  BIT5;
	    	 }

	    	 if(temp <= 220)										// Turn LED2 off
	         {
	        	 P1OUT &= ~BIT5;
	         }
	       }

	   //Touch Controlling LED3 P2.0, simple on while touching
	     /*if(touch > 300 && touch < 1012)
	     {
	    	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 // dead zone, if touch between these two limits, do nothing
	     }
	     else
	       {

	    	 if(touch >= 1012)										// Turn LED3 off
	    	 {
	    		 P2OUT &= ~BIT0;
	    	 }

	    	 if(touch <= 300)										// Turn LED3 on
	         {
	        	 P2OUT |=  BIT0;
	         }
	       }*/

	   //Touch Controlling LED3 P2.0, toggle for every touch, and when left on it turn off after TimerA interrupt
	     if(touch > 700 && touch < 1012)
	     {
	    	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 // Dead Zone
	     }
	     else
	       {

	    	 if(touch >= 1012 && LedOn==0 && LedTog==0 ) 				//Finger Lifted off
	    	 	 {
	    		 	 LedTog=1;
	    	 	 }

	    	 if(touch >= 1012 && LedOn==1 && LedTog==0 )				//Finger Lifted while on
	         	 {
	        	 	 LedTog=1;
	        	 	 //TA1R=0;
	        	 	 //__enable_interrupt() ;
	         	  }

	         if(touch <= 300 && LedOn==0 && LedTog==0 )
	         	 {
	        	 	 	 	 	 	 	 	 	 	 	 	 	 	 	// Still touching while off
	         	 }

	         if(touch <= 300 && LedOn==1 && LedTog==0 ) 				// Still touching while on
	         	 {

	         	 }

	         if(touch <= 300 && LedOn==0 && LedTog==1 )				// Touch to turn on
	         	 {
	        	 	 LedTog=0;
	        	 	 LedOn=1;
	        	 	 P2OUT |=  (BIT0);
	         	 }

	         if(touch <= 300 && LedOn==1 && LedTog==1 )				//Touch to turn off
	         	 {
	        	 	 LedTog=0;
	        	 	 LedOn=0;
	        	 	 P2OUT &= ~(BIT0);
	         	 }
	       }
//-------------------------Student Code---------------------------------------------------
   }
}

void ConfigureAdc(void)
{
  ADC10CTL1 = INCH_2 | CONSEQ_1;              // A2 + A1 + A0, single sequence
  ADC10CTL0 = ADC10SHT_2 | MSC | ADC10ON;
  while (ADC10CTL1 & BUSY);
  ADC10DTC1 = 0x03;                           // 3 conversions
  ADC10AE0 |= (BIT0 | BIT1 | BIT2);           // ADC10 option select
}

// ADC Interrupt
#pragma vector=ADC10_VECTOR
__interrupt void ADC10_ISR(void)
{
  __bic_SR_register_on_exit(CPUOFF);
}


