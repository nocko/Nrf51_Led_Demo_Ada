with nrf51.GPIO;
with Util;

procedure Main is
   use nrf51.GPIO;
   use Util;
   DIRSET : DIRSET_Register renames nrf51.GPIO.GPIO_Periph.DIRSET;
   OUTCLR : OUTCLR_Register renames nrf51.GPIO.GPIO_Periph.OUTCLR;
   OUTSET : OUTSET_Register renames nrf51.GPIO.GPIO_Periph.OUTSET;
begin
   DIRSET.Arr (12) := Set;
   OUTSET.Arr (12) := Set;
   Delay_Init;
   loop
      Delay_MS (1000);
      OUTSET.Arr (12) := Set;
      Delay_MS (1000);
      OUTCLR.Arr (12) := Clear;
   end loop;
end Main;
