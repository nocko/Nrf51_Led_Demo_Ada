with Nrf51.RTC;

package Util is
   use Nrf51.RTC;
   procedure Delay_Init;
   procedure Delay_MS (Milliseconds : Natural);
   procedure RTC1_IRQHandler;
   pragma Export (C, RTC1_IRQHandler, "RTC1_IRQHandler");
private
   Delay_Active : Boolean := False;
end;
