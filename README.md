# **Calendar\_dot\_EXE**

**_"Calendar_dot_EXE" was created by Vi Grey and is licensed under the BSD 2-Clause License._**

## **DESCRIPTION**

A Calendar for the Julian and Gregorian calendar systems that works for years 999999 BC to AD 999999.

------
## **RUNNING THE NES ROM ON AN EMULATOR**

This NES ROM will run on essentially any NES emulator that can run Ice Climber or Donkey Kong (NROM-128), as this ROM uses the same ROM Mapper type as Ice Climber and Donkey Kong.

------
## **BUILDING THE NES ROM SOURCE CODE**

### Build Platforms:
- \*BSD
- Linux
- macOS
- Windows

### NES ROM Build Dependencies:
- **asm6** (You'll probably have to build asm6 from source.  **Make sure the asm6 binary is named `asm` and that the binary is executable and accessible in your PATH**. The source code can be found at http://3dscapture.com/NES/asm6.zip)
- **gmake** (make) (if building on \*BSD, Linux, or macOS)

### Build NES ROM on \*BSD, Linux, or macOS:
From a terminal, go to the the main directory of this project (the directory this README.md file exists in).  You can then build the NES ROM with the following command.

```sh
make
```

The resulting NES ROM will be located at `bin/build/calendar_dot_exe.nes`

### Build NES ROM on Windows:
If you are using Windows, in the command prompt (make sure to have asm6 on your system as `asm.exe`), go to the the `src` directory of this project (the `src` directory that is in the same directory this README.md file exists in).  You can then build the NES ROM with the following command.

```bat
mkdir ..\bin\build & asm.exe calendar_dot_exe.asm ..\bin\build\calendar_dot_exe.nes
```

Replace the `asm.exe` command with the path to your `asm6` executable.  You can either have the `asm.exe` file in the `src` directory or have it in the global **PATH**.

The resulting NES ROM will be located at `bin\build\calendar_dot_exe.nes` from the main directory.


### Clean Build Environment on Linux:
If you used `make` to build the NES ROM, you can run the following command while in the main directory of this project (the directory this README.md file exists in) to clean up the build environment.
```sh
make clean
```

------
## **CONTROLS**

### Title Screen Controls:

* **LEFT**/**RIGHT** - Move cursor left/right
* **UP**/**DOWN** - Cycle through values where cursor is
* **A**/**START** - Show Calendar screen of the selected calendar
* **KONAMI CODE (UP UP DOWN DOWN LEFT RIGHT LEFT RIGHT B A)** - Unlock Parker A, Parker B, and Parker C "hidden" calendar systems

### Calendar Screen Controls:

* **LEFT** - Change calendar to 1 month back
* **RIGHT** - Change calendar to 1 month forward
* **UP** - Change calendar to 1 year forward
* **DOWN** - Change calendar to 1 year back
* **B**/**START** - Go back to Title screen, with current calendar as the pre-populated calendar data


------

## **CALENDAR SYSTEMS**

Each calendar system in this project assumes a 7 day week and extend backwards in time to well before these calendar systems existed.  It is known that the Romans used an 8 day week, but that is not in the scope of this project.

The Parker A, Parker B, and Parker C calendar systems are the calendar systems described by Matt Parker (Stand-up Maths) in the following YouTube video and are "hidden" behind the Konami Code (Up Up Down Down Left Right Left Right B A) on the title screen: https://www.youtube.com/watch?v=qkt_wmRKYNQ

### Julian Calendar Rules:

* If the era is AD
  * Years that are multiples of 4 are leap years (e.g. AD 8, AD 1900, AD 2020)
  * All other years are not leap years
* If the era is BC
  * Years that are 1 more than a multiple of 4 are leap years (e.g. 9 BC, 21 BC, 33 BC)
  * All other years are not leap years

### Gregorian Calendar Rules:

* If the era is AD
  * Years that are multiples of 4 are leap years (e.g. AD 8, AD 1584, AD 2020)
    * **UNLESS** the year is a multiple of 100 (e.g. AD 100, AD 600, AD 2200)
      * **UNLESS** the year is a multiple of 400 (e.g. AD 400, AD 1600, AD 2000)
  * All other years are not leap years
* If the era is BC
  * Years that are 1 more than a multiple of 4 are leap years (e.g. 9 BC, 21 BC, 33 BC)
    * **UNLESS** the year is 1 more than a multiple of 100 (e.g. 101 BC, 601 BC, 2201 BC)
      * **UNLESS** the year is 1 more than a multiple of 400 (e.g. 1 BC, 401 BC, 2001 BC)
  * All other years are not leap years

### Roman Calendar Rules:

* Dates before October 1582 follow the Julian calendar rules
* Dates after October 1582 follow the Gregorian calendar rules
* October 1582 begins by following the Julian calendar rules
* The day after October 4th is October 15th

##### Roman Calendar Quirks: (Scaliger's interpretation of Macrobius's description of errors in the implementation of the Julian Calendar)

* Starting 42 BC until (inclusive) 9 BC, leap years occur every 3 years instead of 4 (e.g. 42 BC, 39 BC, ..., 9 BC)
* To correct the sync issue of calculating leap years incorrectly, there were no leap years from 8 BC to AD 5

### Parker A Calendar Rules:

* If era is AD
  * Years that are multiples of 4 are leap years (e.g. AD 8, AD 1584, AD 2020)
    * **UNLESS** the year is a multiple of 100 (e.g. AD 100, AD 600, AD 2200)
      * **UNLESS** the year is a multiple of 400 (e.g. AD 400, AD 1600, AD 2000)
        * **UNLESS** the year ends in 2800, 5600, or 8400 (e.g. AD 8400, AD 15600, AD 992800)
  * All other years are not leap years
* If era is BC
  * Years that are 1 more than a multiple of 4 are leap years (e.g. 9 BC, 21 BC, 33 BC)
    * **UNLESS** the year is 1 more than a multiple of 100 (e.g. 101 BC, 601 BC, 2201 BC)
      * **UNLESS** the year is 1 more than a multiple of 400 (e.g. 1 BC, 401 BC, 2001 BC)
        * **UNLESS** the year ends in 1601, 4401, or 7201 (e.g. 7201 BC, 14401 BC, 991601 BC)
  * All other years are not leap years

### Parker B Calendar Rules:

* If the era is AD
  * Years that are multiples of 4 are leap years (e.g. AD 8, AD 1900, AD 2020)
    * **UNLESS** the year is a multiple of 128 (e.g. AD 129, AD 1025, AD 2048)
  * All other years are not leap years
* If the era is BC
  * Years that are 1 more than a multiple of 4 are leap years (e.g. 9 BC, 21 BC, 33 BC)
    * **UNLESS** the year is 1 more than a multiple of 128 (e.g. 129 BC, 1025 BC, 2049 BC)
  * All other years are not leap years

### Parker C Calendar Rules:

* If the era is AD
  * Years that are multiples of 4 are leap years (e.g. AD 8, AD 1900, AD 2020)
    * **UNLESS** the year is a multiple of 128 (e.g. AD 129, AD 1025, AD 2048)
      * **UNLESS** the year is a multiple of 625024 (e.g. AD 625024)
  * All other years are not leap years
* If the era is BC
  * Years that are 1 more than a multiple of 4 are leap years (e.g. 9 BC, 21 BC, 33 BC)
    * **UNLESS** the year is 1 more than a multiple of 128 (e.g. 129 BC, 1025 BC, 2049 BC)
      * **UNLESS** the year is 1 more than a multiple of 625024 (e.g. 1 BC, 625025 BC)
  * All other years are not leap years

------
## **LICENSE**
```
Copyright (C) 2020-2021, Vi Grey
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions
are met:

    1. Redistributions of source code must retain the above copyright
       notice, this list of conditions and the following disclaimer.
    2. Redistributions in binary form must reproduce the above copyright
       notice, this list of conditions and the following disclaimer in the
       documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY AUTHOR AND CONTRIBUTORS ``AS IS'' AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
ARE DISCLAIMED. IN NO EVENT SHALL AUTHOR OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
SUCH DAMAGE.
```
