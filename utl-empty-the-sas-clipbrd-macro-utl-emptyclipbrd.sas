%let pgm=utl-empty-the-sas-clipbrd-macro-utl-emptyclipbrd;

%stop_submission;

Empty the sas clipbrd macro utl emptyclipbrd

github
https://tinyurl.com/2bc6chpz
https://github.com/rogerjdeangelis/utl-empty-the-sas-clipbrd-macro-utl-emptyclipbrd

CONTENTS
  1 SAS DOSUBL EMPTY CLIPBRD
  2 utl_emptyclipbrd macro

SOAPBOX ON

I could not get the first 2 simple methods below to work
consistently.

1. cmd.exe
   x "echo off | clip";

2. Powershell
   %utl_psbegin;
   parmcards4;
   Set-Clipboard -Value ""
   ;;;;
   %utl_psend;

3  This sas only solution worked
   consitently

   %macro utl_emptyclipbrd;
     %dosubl('
     filename _clp clipbrd;
     data _null_;
      file _clp;
      put;
     run;quit;
     filename _clp clear;;
   ');
   %mend utl_emptyclipbrd;

   %emptyClipbrd;

The property of file emptiness is different
between window files and the sas and windows clipboards.
Typically 0 byte windows files contain no data, emptiness is
determine strictly by examining file meta data.
SAS Clipbrd has no system-specific file attributes available.
Emptiness

Automating clipboard clearing from SAS without any external
tools or system calls is not feasible. The recommended and simplest
approach always involves using Windows system commands or external.

SAS is not able to set window file metat data for the sas clipboard?

SOAPBOX OFF

/**************************************************************************************************************************/
/* INPUT                         | PROCESS                                  | OUTPUT                                      */
/* =====                         | =======                                  | ======                                      */
/* CLIPBRD NOT EMPTY             | 1 SAS DOSUBL EMPTY CLIPBRD               | CLIPBRD IS EMPTY                            */
/*                               | ==========================               |                                             */
/* * load clipbrd ;              |                                          | CONTENTS ARE INSIDE BRACKETS []             */
/* filename _clp clipbrd;        | %macro utl_emptyclipbrd;                 |                                             */
/* data _null_;                  |   %dosubl('                              | EMPTY META DATA FLAG NOT SET                */
/*  file _clp;                   |   filename _clp clipbrd;                 | EVEN THOUGH THE CLIPBRD IS EMPTY            */
/*  put "CLIPBRD NOT EMPTY";     |   data _null_;                           |                                             */
/* run;quit;                     |    file _clp;                            |                                             */
/* filename _clp clear;;         |    put;                                  | CHECK IF EMPTY WINDOWS IN SENSE             */
/*                               |   run;quit;                              |                                             */
/* * CHECK CLIPBRD;              |   filename _clp clear;;                  | NOT EMPTY WINDOW FILE                       */
/*                               | ');                                      |                                             */
/* filename _clp clipbrd;        | %mend utl_emptyclipbrd;                  |                                             */
/* data _null_;                  |                                          |                                             */
/*  infile _clp;                 | %utl_emptyClipbrd;                       |                                             */
/*  input;                       |                                          |                                             */
/*  put _infile_ $hex16;         | *SHOW THAT CLIPBRD IS EMPTY;             |                                             */
/* run;quit;                     |                                          |                                             */
/* filename _clp clear;          | filename _clp clipbrd;                   |                                             */
/*                               | data _null_;                             |                                             */
/* CLIPBRD NOT EMPTY             |  infile _clp;                            |                                             */
/*                               |  input;                                  |                                             */
/*                               |  put "CONTENTS IS INSIDE BRACKETS        |                                             */
/*                               |  " "[" _infile_ "]" ;                    |                                             */
/*                               | run;quit;                                |                                             */
/*                               | filename _clp clear;                     |                                             */
/*                               |                                          |                                             */
/*                               | *Not empty in windows sense              |                                             */
/*                               | Note if we test for window emptiness     |                                             */
/*                               | Paul Dorfman;                            |                                             */
/*                               |                                          |                                             */
/*                               | filename _clp clipbrd;                   |                                             */
/*                               | data _null_ ;                            |                                             */
/*                               |  infile _clp end = empty ;               |                                             */
/*                               |  call symputx("empty"                    |                                             */
/*                               |   ,put(empty,1.)); * 1 if empty;         |                                             */
/*                               | run;quit;                                |                                             */
/*                               |                                          |                                             */
/*                               | %put %sysfunc(                           |                                             */
/*                               |     ifc(&empty                           |                                             */
/*                               |     ,FILE IS EMPTY                       |                                             */
/*                               |     ,FILE NOT EMPTY));                   |                                             */
/*                               |                                          |                                             */
/*                               | %put &=empty;                            |                                             */
/*                               |                                          |                                             */
/*                               | 2 UTL_EMPTYCLIPBRD MACRO (SEE BELOW)     |                                             */
/**************************************************************************************************************************/

/*                   _
(_)_ __  _ __  _   _| |_
| | `_ \| `_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
*/

* load clipbrd ;
filename _clp clipbrd;
data _null_;
 file _clp;
 put "CLIPBRD NOT EMPTY";
run;quit;
filename _clp clear;;

* CHECK CLIPBRD;

filename _clp clipbrd;
data _null_;
 infile _clp;
 input;
 put _infile_ $hex16;
run;quit;
filename _clp clear;

/**************************************************************************************************************************/
/*  CONTENTS OF CLIPBRD                                                                                                   */
/*                                                                                                                        */
/*  CLIPBRD NOT EMPTY                                                                                                     */
/**************************************************************************************************************************/

%macro utl_emptyclipbrd;
  %dosubl('
  filename _clp clipbrd;
  data _null_;
   file _clp;
   put;
  run;quit;
  filename _clp clear;;
');
%mend utl_emptyclipbrd;

%utl_emptyClipbrd;

/*--- SHOW THAT CLIPBRD IS EMPTY ---*/

filename _clp clipbrd;
data _null_;
 infile _clp;
 input;
 put "CONTENTS IS INSIDE BRACKETS
 " "[" _infile_ "]" ;
run;quit;
filename _clp clear;

filename _clp clipbrd;
data _null_ ;
 infile _clp end = empty ;
 call symputx("empty"
  ,put(empty,1.)); * 1 if empty;
run;quit;

%put %sysfunc(
    ifc(&empty
    ,FILE IS EMPTY
    ,FILE NOT EMPTY));

%put &=empty;

/*---
SAS checks the file nmeta data to detemine if empty
Not empty in windows sense
Note if we test for window emptiness
Paul Dorfman
---*/

/**************************************************************************************************************************/
/* CHECK CONTENTS OF FILE                                                                                                 */
/* FILE IS EMPTY                                                                                                          */
/*                                                                                                                        */
/* CONTENTS IS INSIDE BRACKETS []                                                                                         */
/*                                                                                                                        */
/* FILE IS NOT EMPTY USING META DATA PROPERTIES                                                                           */
/*                                                                                                                        */
/* FILE NOT EMPTY                                                                                                         */
/**************************************************************************************************************************/

/*___         _   _                       _              _ _       _             _
|___ \  _   _| |_| |  ___ _ __ ___  _ __ | |_ _   _  ___| (_)_ __ | |__  _ __ __| |
  __) || | | | __| | / _ \ `_ ` _ \| `_ \| __| | | |/ __| | | `_ \| `_ \| `__/ _` |
 / __/ | |_| | |_| ||  __/ | | | | | |_) | |_| |_| | (__| | | |_) | |_) | | | (_| |
|_____| \__,_|\__|_|_\___|_| |_| |_| .__/ \__|\__, |\___|_|_| .__/|_.__/|_|  \__,_|
                  |___|            |_|        |___/         |_|
*/

filename ft15f001 "c:/oto/utl_emptyClipbrd.sas";
parmcards4;
%macro utl_emptyclipbrd/des="empty the sas clipbrd";
  %dosubl('
  filename _clp clipbrd;
  data _null_;
   file _clp;
   put;
  run;quit;
  filename _clp clear;;
');
%mend utl_emptyclipbrd;
;;;;
run;quit;

/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/
