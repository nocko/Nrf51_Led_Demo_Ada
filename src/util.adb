with Interfaces;
with Interrupts;
with System.Machine_Code;
with Nrf51;
with Nrf51.Clock;

package body Util is
   use Interfaces;
   use Nrf51;
   RTC_Clock_Freq : constant Integer := 10#32768#;
   Delay_Timer_Prescaler : constant := 0;
   
   function MS_To_Ticks (Milliseconds : Natural) return UInt24 is
   begin
      return UInt24(((Float(RTC_Clock_Freq) / Float(Delay_Timer_Prescaler + 1)) / 1000.0) * Float(Milliseconds));
   end;
     
   procedure Delay_Init is
   begin
      declare
	 use Nrf51.Clock;
	 EVENTS_LFCLKSTARTED : Nrf51.Word renames 
	   Nrf51.Clock.Clock_Periph.EVENTS_LFCLKSTARTED;
	 TASKS_LFCLKSTART : Nrf51.Word renames
	   Nrf51.Clock.Clock_Periph.TASKS_LFCLKSTART;
	 LFCLKSRC : Nrf51.Clock.LFCLKSRC_Register renames
	   Nrf51.Clock.Clock_Periph.LFCLKSRC;
      begin
	 if EVENTS_LFCLKSTARTED /= 1 then
	    LFCLKSRC.SRC := Xtal;
	    TASKS_LFCLKSTART := 1;
	    loop
	       -- Waiting for the LF Oscillator to start
	       exit when EVENTS_LFCLKSTARTED = 1;
	    end loop;
	 end if;
      end;
      declare
	 PRESCALER : PRESCALER_PRESCALER_Field renames 
	   Nrf51.RTC.RTC1_Periph.PRESCALER.PRESCALER;
	 TASKS_STOP : Nrf51.Word renames
	   Nrf51.RTC.RTC1_Periph.TASKS_STOP;
	 TASKS_CLEAR : Nrf51.Word renames
	   Nrf51.RTC.RTC1_Periph.TASKS_CLEAR;
	 INTENSET : Nrf51.RTC.INTENSET_Register renames
	   Nrf51.RTC.RTC1_Periph.INTENSET;
	 use Interrupts;
      begin
	 PRESCALER := Delay_Timer_Prescaler;
	 TASKS_STOP := 1;
	 TASKS_CLEAR := 1;
	 INTENSET.COMPARE.Arr(0) := Set;
	 --  Interrupts.Set_Priority(RTC1_IRQ, IRQ_Prio_Low);
	 Interrupts.Enable(RTC1_IRQ);
      end;
   end;
   
   procedure WFI is
      use System.Machine_Code;
   begin
      Asm (Template => "wfi", Volatile => True);
      return;
   end;
   
   procedure Delay_MS (Milliseconds : Natural) is
      TASKS_START : Nrf51.Word renames Nrf51.RTC.RTC1_Periph.TASKS_START;
      CC0 : UInt24 renames Nrf51.RTC.RTC1_Periph.CC(0).COMPARE;
   begin
      CC0 := MS_To_Ticks(Milliseconds);
      Delay_Active := True;
      TASKS_START := 1;
      loop
	 WFI;
	 exit when Delay_Active = False;
      end loop;
   end;
   
   procedure RTC1_IRQHandler is
      TASKS_STOP : Nrf51.Word renames Nrf51.RTC.RTC1_Periph.TASKS_STOP;
      TASKS_CLEAR : Nrf51.Word renames Nrf51.RTC.RTC1_Periph.TASKS_CLEAR;
      EVENTS_COMPARE : EVENTS_COMPARE_Registers renames Nrf51.RTC.RTC1_Periph.EVENTS_COMPARE;
   begin
      Delay_Active := False;
      TASKS_STOP := 1;
      TASKS_CLEAR := 1;
      EVENTS_COMPARE(0) := 0;
   end;
end;
