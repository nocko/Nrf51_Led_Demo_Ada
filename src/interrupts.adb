with Interfaces;
with System;

package body Interrupts is
   
   procedure Enable (I : Interrupt) is
      use Interfaces;
      ISER : Interfaces.Unsigned_32;
      pragma Volatile (ISER);
      for ISER'Address use System'To_Address(16#E000_E100#);
   begin
      ISER := Shift_Left(1, Interrupt'Pos(I));
   end;
   
   procedure Set_Priority (I : Interrupt; P : IRQ_Priority) is
      use Interfaces;
      IPR : array(0 .. 3) of Interfaces.Unsigned_32;
      for IPR'Address use System'To_address(16#E000_E400#);
      pragma Volatile (IPR);
      
      subtype IPR_Reg_Number is Integer range 0 .. 3;
      subtype IPR_Field_Number is Integer range 0 .. 3;
      subtype Priority_Value is Unsigned_32 range 0 .. 192;
      
      Reg_Num : IPR_Reg_Number;
      Field_Num : IPR_Field_Number;
      Prio : Priority_Value;
   begin
      Reg_Num := Interrupt'Pos(I) / 4;
      Field_Num := Interrupt'Pos(I) mod 4;
      Prio := IRQ_Priority'Pos(P) * 64;
      IPR(Reg_Num) := IPR(Reg_Num) or Shift_Left(Prio, Field_Num*8);
   end;
end;
