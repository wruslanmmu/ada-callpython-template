
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
      
   ModuleDir  : String := "src/mod-python/"; 
   ModuleName_01 : String := "python_module_01";  -- No need .py suffix
   ModuleName_02 : String := "python_module_02";  -- No need .py suffix
     
   Module_01 : PACPM.Module;
   Module_02 : PACPM.Module;
   
   A : Integer := 10;
   B : Integer := 2;
   Result : Integer;
   
-- ========================================================   
begin  -- FOR procedure MAIN
   startClock := ART.Clock; PADTS.dtstamp;
   ATIO.Put_Line ("STARTED: main Bismillah 3 times WRY");
   ATIO.New_Line;
   
   -- CODE BEGINS HERE
   ATIO.Put_Line ("-- =====================================================");
   PACPM.Initialize;

   ATIO.Put_Line ("Ada executing Python directly (in Ada environment)");
   
   ATIO.Put_Line ("Executing... print 'Bismillah 3 times WRY'");
   ATIO.Put ("Return from python: ");
   PACPM.Execute_String ("print 'Bismillah 3 times WRY'");

   ATIO.New_Line;
   ATIO.Put_Line ("Executing... PACPM.Execute_String (""import numpy"") ");
   PACPM.Execute_String ("import numpy as np");
  
   ATIO.Put_Line ("Executing... PACPM.Execute_String (""import scipy"") ");
   PACPM.Execute_String ("import scipy");
   
   ATIO.Put_Line ("Executing... PACPM.Execute_String (""import matplotlib"") ");
   PACPM.Execute_String ("import matplotlib");
      
   ATIO.Put_Line ("This invokes the matplotlib GUI and display a plot");
   PACPM.Execute_String ("import matplotlib.pyplot as plt");
   
   PACPM.Execute_String ("x = np.arange(0.0, 10.0, 0.1)");
   PACPM.Execute_String ("y = np.sin(x)");
   PACPM.Execute_String ("plt.plot(x, y)");   
   PACPM.Execute_String ("plt.show()");
   PACPM.Execute_String ("plt.close()");
   PACPM.Execute_String ("plt.pause(3)"); -- Allow enough time for GUI closing
      
   ATIO.New_Line;
   ATIO.Put_Line ("-- =====================================================");
   ATIO.Put_Line ("Loading external Python module and calling functions from that module:");
   ATIO.Put_Line ("Loading module from file  : " & ModuleDir & ModuleName_01 & ".py");
   
   Module_01 := PACPM.Import_File (ModuleName_01);   -- The python file without .py
    
   ATIO.New_Line;
   PACPM.Call (Module_01, "hello");
   
   ATIO.New_Line;
   ATIO.Put_Line ("asking Python to add two integers:");
   Result := PACPM.Call (Module_01, "add", A, B);
   
   ATIO.Put_Line ("Ada got result from Python:" & Integer'Image (Result));
   
   ATIO.New_Line;
   ATIO.Put_Line ("we can try other operations, too:");
   
   Result := PACPM.Call (Module_01, "sub", A, B);
   ATIO.Put_Line ("subtract:" & Integer'Image (Result));
   
   Result := PACPM.Call (Module_01, "mul", A, B);
   ATIO.Put_Line ("multiply:" & Integer'Image (Result));
   
   Result := PACPM.Call (Module_01, "div", A, B);
   ATIO.Put_Line ("divide  :" & Integer'Image (Result));
   
   PACPM.Close_Module (Module_01);
   PACPM.Finalize;
   
   ATIO.New_Line;
   ATIO.Put_Line ("-- =====================================================");
   PACPM.Initialize;
   ATIO.Put_Line ("Loading external Python module and calling functions from that module:");
   ATIO.Put_Line ("Loading module from file  : " & ModuleDir & ModuleName_02 & ".py");
   Module_02 := PACPM.Import_File (ModuleName_02);   -- The python file without .py
   
   ATIO.New_Line;
   PACPM.Call (Module_02, "hello");
   ATIO.New_Line;
   
   PACPM.Close_Module (Module_02);
   PACPM.Finalize;
   ATIO.Put_Line ("-- =====================================================");
   
   -- CODE ENDS HERE
   -- =====================================================
   ATIO.New_Line; PADTS.dtstamp;
   ATIO.Put ("ENDED: main Alhamdulillah 3 times WRY. ");
   finishClock := ART.Clock;
   PARD.exec_display_execution_time(startClock, finishClock); 
   
-- ========================================================   
end main_ada_callpython_module;
-- ========================================================

