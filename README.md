# Nrf51_Led_Demo_Ada

## Building

1. Download [GNAT GPL from Adacore](http://libre.adacore.com/download/configurations) for ARM

2. `git clone https://github.com/nocko/Nrf51_Led_Demo_Ada.git`

3. Edit Pin number in `src/main.adb` if needed (default is 12)

4. `gprbuild`

5. Load the binary onto your board as you would normally.

6. ...

7. Blinking lights

## Credits

zfp-nrf51 is a lightly modified zfp-lm3s with much of the heavy
lifting done by [svd2ada](https://github.com/AdaCore/svd2ada) and the
bootstrap code from the Nordic nRF51 SDK version 10.0.
