#include <msp430.h>
#include <stdlib.h>


unsigned int Rotate_Left(unsigned int value,int shift );
unsigned int Rotate_Right(unsigned int value,int shift );
void Fast_Delay( );
void Slow_Delay( );

int main(void)
{
    WDTCTL = WDTPW | WDTHOLD;	// Stop watchdog timer
	
    P1DIR = 0xFF;
    P2DIR = 0x00;
    static const int pattern = 0x38;
    unsigned static int mask = 0;
    unsigned static int Result = 0;
    static const int write = 0x01;
    static const int rotate = 0x02;
    static const int speed = 0x04;
    static int Wcommand = 0;
    static int Rcommand = 0;
    static int Scommand = 0;


    while(1)
    {

    	mask = P2IN & pattern;

    	Wcommand = P2IN & write;
    	Rcommand = P2IN & rotate;
    	Scommand = P2IN & speed;
    	Result = mask;

    	if (Wcommand == write)
    	{
    		P1OUT = mask;
    	}
    	else
    	{
    		while(Wcommand == 0)
    		{
    			if (Rcommand == rotate)
    			{
    				Result = Rotate_Left(Result, 1);
    			}
    			else
    				 Result = Rotate_Right(Result, 1);

    			if(Scommand == speed)
    			{
    				Fast_Delay( );
    			}
    			else
    				Slow_Delay( );

    			P1OUT = Result;

    			Wcommand = P2IN & write;
    			Rcommand = P2IN & rotate;
    			Scommand = P2IN & speed;
    		}
    	}
    }

	return 0;
}


unsigned int Rotate_Left( unsigned int value,int shift )
{
	static unsigned int result;

	result = (( value << shift)| ( value >> 7 ));

	return result;
}

unsigned int Rotate_Right( unsigned int value,int shift )
{
	static unsigned int result;

	result = (( value >> shift)| ( value << 7 ));

	return result;
}


void Fast_Delay( )
{

	static int Inner = 1;
	static int Outer = 1;

	for(Outer = 1;Outer >= 0; Outer--)
	{
		for( Inner =5000; Inner >= 0; Inner--)
		{

		}
	}
	return;
}


void Slow_Delay( )
{

	static int Inner = 1;
	static int Outer = 1;

	for(Outer = 15;Outer >= 0; Outer--)
	{
		for( Inner =5000; Inner >= 0; Inner--)
		{

		}
	}
	return;
}


