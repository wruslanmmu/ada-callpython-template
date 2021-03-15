
with pkg_ada_call_python_module;
with Ada.Text_IO;

-- ========================================================
procedure main_ada_call_python_module is
-- ========================================================
   package ATIO   renames Ada.Text_IO;
   package PACPM  renames pkg_ada_call_python_module;

   Module : PACPM.Module;
   
   A : Integer := 10;
   B : Integer := 2;
   Result : Integer;
   
begin

   PACPM.Initialize;

   ATIO.Put_Line ("executing Python directly from Ada:");
   PACPM.Execute_String ("print 'Hello from Python!'");

   ATIO.New_Line;
   ATIO.Put_Line ("loading external Python module and calling functions from that module:");
   Module := PACPM.Import_File ("python_module");
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
   
-- ========================================================   
end main_ada_call_python_module;
-- ========================================================

