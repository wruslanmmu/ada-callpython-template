-- File   : main_ada_xxxxxxx.adb
-- Date   : Sun 07 Mar 2021 06:00:42 PM +08
-- Author : wruslandr@gmail.com
-- Version: 3.0 Sat 13 Mar 2021 06:32:20 PM +08
-- Version: 2.0 Fri 12 Mar 2021 07:24:15 AM +08
-- Version: 1.0 Sun 07 Mar 2021 06:00:42 PM +08
-- ========================================================

-- IMPORT STANDARD ADA PACKAGES
with Ada.Text_IO;   -- use  Ada.Text_IO;
with Ada.Real_Time; -- use  Ada.Real_Time;

-- IMPORT USER-DEFINED ADA PACKAGES 
-- (LOOKS FOR CORRESPONDING NAMED .ads FILE)
with pkg_ada_datetime_stamp;
with pkg_ada_realtime_delays;

-- ========================================================
procedure main_ada_xxxxxxx
-- ========================================================
--	with SPARK_Mode => on
is 
   -- RENAME STANDARD ADA PACKAGES FOR CONVENIENCE
   package ATIO   renames Ada.Text_IO;
   package ART    renames Ada.Real_Time;
      
   -- RENAME USER-DEFINED ADA PACKAGES FOR CONVENIENCE
   package PADTS  renames pkg_ada_datetime_stamp;
   package PARD   renames pkg_ada_realtime_delays;
      
   -- PPOCEDURE-WIDE VARIABLE DEFINITIONS
   startClock, finishClock   : ART.Time;  
   startTestClock, finishTestClock : ART.Time;
   deadlineDuration : ART.Time_Span;

-- ========================================================   
begin  -- FOR procedure main_ada_xxxxxxx
   startClock := ART.Clock; PADTS.dtstamp;
   ATIO.Put_Line ("STARTED: main Bismillah 3 times WRY");
   ATIO.New_Line;

   -- CODE BEGINS HERE
   -- =====================================================
   -- UNDERRUN TEST
   -- deadlineDuration :=  ART.To_Time_Span(0.030);  -- number in seconds 
   -- OVERRUN TEST
   deadlineDuration :=  ART.To_Time_Span(0.028);  -- number in seconds
   
   startTestClock  := ART.Clock;
   PARD.exec_delay_msec (29);     -- This is to simulate some process running
   finishTestClock := ART.Clock;
   PARD.exec_checktiming_overrun_underrun (startTestClock, finishTestClock, deadlineDuration);
   
   
   
   
   
   -- CODE ENDS HERE
   -- =====================================================
   ATIO.New_Line; PADTS.dtstamp;
   ATIO.Put ("ENDED: main Alhamdulillah 3 times WRY. ");
   finishClock := ART.Clock;
   PARD.exec_display_execution_time(startClock, finishClock); 
-- ========================================================   
end main_ada_xxxxxxx;
-- ========================================================
