
-- IMPORT STANDARD ADA PACKAGES
with Ada.Text_IO;   -- use  Ada.Text_IO;
with Ada.Real_Time; -- use  Ada.Real_Time;
-- with Interfaces;

-- IMPORT USER-DEFINED ADA PACKAGES 
-- (LOOKS FOR CORRESPONDING NAMED .ads FILE)
with pkg_ada_datetime_stamp;
with pkg_ada_realtime_delays;
with pkg_ada_callpython_module;

-- ========================================================
procedure main_ada_callpython_module 
-- ========================================================
is   
   -- IMPORT STANDARD ADA PACKAGES
-- RENAME STANDARD ADA PACKAGES FOR CONVENIENCE
   package ATIO   renames Ada.Text_IO;
   package ART    renames Ada.Real_Time;
      
   -- RENAME USER-DEFINED ADA PACKAGES FOR CONVENIENCE
   package PADTS  renames pkg_ada_datetime_stamp;
   package PARD   renames pkg_ada_realtime_delays;
   package PACPM  renames pkg_ada_callpython_module;
   
   -- VARIABLE DECLARATIONS
   startClock, finishClock   : ART.Time;  
      

   Module : PACPM.Module;
   
   A : Integer := 10;
   B : Integer := 2;
   Result : Integer;
   
-- ========================================================   
begin  -- FOR procedure MAIN
   startClock := ART.Clock; PADTS.dtstamp;
   ATIO.Put_Line ("STARTED: main Bismillah 3 times WRY");
   ATIO.New_Line;
   
   -- CODE BEGINS HERE
   -- =====================================================
   PACPM.Initialize;

   ATIO.Put_Line ("executing Python directly from Ada:");
   PACPM.Execute_String ("print 'Hello from Python!'");

   ATIO.New_Line;
   ATIO.Put_Line ("loading external Python module and calling functions from that module:");
   Module := PACPM.Import_File ("python_module");   -- THE PY file 
   PACPM.Call (Module, "hello");
   
   ATIO.New_Line;
   ATIO.Put_Line ("asking Python to add two integers:");
   Result := PACPM.Call (Module, "add", A, B);
   
   ATIO.Put_Line ("Ada got result from Python:" & Integer'Image (Result));
   
   ATIO.New_Line;
   ATIO.Put_Line ("we can try other operations, too:");
   
   Result := PACPM.Call (Module, "sub", A, B);
   ATIO.Put_Line ("subtract:" & Integer'Image (Result));
   
   Result := PACPM.Call (Module, "mul", A, B);
   ATIO.Put_Line ("multiply:" & Integer'Image (Result));
   
   Result := PACPM.Call (Module, "div", A, B);
   ATIO.Put_Line ("divide  :" & Integer'Image (Result));
   
   PACPM.Close_Module (Module);

   PACPM.Finalize;
   
   -- CODE ENDS HERE
   -- =====================================================
   ATIO.New_Line; PADTS.dtstamp;
   ATIO.Put ("ENDED: main Alhamdulillah 3 times WRY. ");
   finishClock := ART.Clock;
   PARD.exec_display_execution_time(startClock, finishClock); 
   
-- ========================================================   
end main_ada_callpython_module;
-- ========================================================

