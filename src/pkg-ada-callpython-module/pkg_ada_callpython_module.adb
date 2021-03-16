with Interfaces.C;
with Ada.Text_IO;

-- ========================================================
package body pkg_ada_callpython_module is
-- ========================================================

   package IFaceC  renames Interfaces.C;
   package ATIO    renames Ada.Text_IO;
   
   subtype PyObject is System.Address;

   procedure Py_SetProgramName (Name : in IFaceC.char_array);
   pragma Import (C, Py_SetProgramName, "Py_SetProgramName");

   procedure Py_Initialize;
   pragma Import (C, Py_Initialize, "Py_Initialize");

   procedure Py_Finalize;
   pragma Import (C, Py_Finalize, "Py_Finalize");
    
   function PyRun_SimpleString (Command : in IFaceC.char_array) return IFaceC.int;
   pragma Import (C, PyRun_SimpleString, "PyRun_SimpleString");
    
   procedure Py_IncRef (Obj : in PyObject);
   pragma Import (C, Py_IncRef, "Py_IncRef");
    
   procedure Py_DecRef (Obj : in PyObject);
   pragma Import (C, Py_DecRef, "Py_DecRef");
    
   function PyInt_AsLong (I : in PyObject) return IFaceC.long;
   pragma Import (C, PyInt_AsLong, "PyInt_AsLong");
      
   function PyString_FromString (Str : in IFaceC.char_array) return PyObject;
   pragma Import (C, PyString_FromString, "PyString_FromString");
    
   function PyImport_Import (Obj : in PyObject) return PyObject;
   pragma Import (C, PyImport_Import, "PyImport_Import");
   
   function PyObject_GetAttrString (Obj : in PyObject; Name : in IFaceC.char_array) return PyObject;
   pragma Import (C, PyObject_GetAttrString, "PyObject_GetAttrString");
   
   function PyObject_CallObject (Obj : in PyObject; Args : in PyObject) return PyObject;
   pragma Import (C, PyObject_CallObject, "PyObject_CallObject");
   
   procedure PyErr_Print;
   pragma Import (C, PyErr_Print, "PyErr_Print");
    
   --
   -- ===================================================== 
   procedure Initialize (Program_Name : in String := "") is
   begin
      if Program_Name /= "" then
         declare
            C_Name : IFaceC.char_array := IFaceC.To_C (Program_Name);
            Program_Name_Ptr : access IFaceC.char_array := new IFaceC.char_array'(C_Name);
         begin
            Py_SetProgramName (Program_Name_Ptr.all);
         end;
      end if;
       
      Py_Initialize;
      
      --  Below: workaround for the following issue:
      --  http://stackoverflow.com/questions/13422206/how-to-load-a-custom-python-module-in-c

      Execute_String ("import sys");
      Execute_String ("sys.path.append('src/mod-python')");
            
   end Initialize;
   
   -- ===================================================== 
   procedure Finalize is
   begin
      Py_Finalize;
   end Finalize;
   
   -- ===================================================== 
   procedure Execute_String (Script : in String) is
      Dummy : IFaceC.int;
   begin
      Dummy := PyRun_SimpleString (IFaceC.To_C (Script));
   end Execute_String;
    
   -- ===================================================== 
   function Import_File (File_Name : in String) return Module is
      
      PyFileName : PyObject := PyString_FromString (IFaceC.To_C (File_Name));
      M : PyObject := PyImport_Import (PyFileName);
      
      use type System.Address;
   begin
      Py_DecRef (PyFileName);
      if M = System.Null_Address then
         ATIO.Put_Line ("Filed to load module from file: src/mod-python/" & File_Name & ".py");
         
         --PyErr_Print;
         raise Interpreter_Error with "Cannot load module from file " & File_Name;
      else   
         ATIO.Put_Line ("Successfully loaded module: src/mod-python/" & File_Name & ".py");
      end if;
       
      return Module (M);
   end Import_File;
   
   -- =====================================================
   procedure Close_Module (M : in Module) is
   begin
      Py_DecRef (PyObject (M));
   end Close_Module;

   -- =====================================================
   --  HELPERS for use from all overloaded Call subprograms
   -- =====================================================
   function Get_Symbol (M : in Module; Function_Name : in String) return PyObject is
      
      PyModule : PyObject := PyObject (M);
      F : PyObject := PyObject_GetAttrString (PyModule, IFaceC.To_C (Function_Name));
      use type System.Address;
   
   begin
      if F = System.Null_Address then
         --PyErr_Print;
         raise Interpreter_Error with "Cannot find function " & Function_Name;
      end if;
      
      return F;
   end Get_Symbol;
   
   -- =====================================================
   function Call_Object (F : in PyObject; Function_Name : in String; PyParams : in PyObject) return PyObject is
      PyResult : PyObject;
      use type System.Address;
   begin
      PyResult := PyObject_CallObject (F, PyParams);
      if PyResult = System.Null_Address then
         raise Interpreter_Error with "Operation " & Function_Name & " did not return expected result";
      end if;
      
      return PyResult;
   end Call_Object;      

   -- =====================================================
   --  PUBLIC OPERATIONS
   -- =====================================================
   procedure Call (M : in Module; Function_Name : in String) is
      F : PyObject := Get_Symbol (M, Function_Name);
      Result : PyObject;
   begin
      Result := PyObject_CallObject (F, System.Null_Address);
      Py_DecRef (Result);
   end Call;

   -- =====================================================
   function  Call (M : in Module; Function_Name : in String; A : in Integer; B : Integer) return Integer is
      F : PyObject := Get_Symbol (M, Function_Name);
      
      function Py_BuildValue (Format : in IFaceC.char_array; A : in IFaceC.int; B : in IFaceC.int) return PyObject;
      pragma Import (C, Py_BuildValue, "Py_BuildValue");

      PyParams : PyObject;
      PyResult : PyObject;
      Result : aliased IFaceC.long;
      
      use type IFaceC.int;
      
   begin
      PyParams := Py_BuildValue (IFaceC.To_C ("ii"), IFaceC.int (A), IFaceC.int (B));
      PyResult := Call_Object (F, Function_Name, PyParams);
      Result := PyInt_AsLong (PyResult);
      Py_DecRef (PyParams);
      Py_DecRef (PyResult);

      return Integer (Result);
   end Call;

-- ========================================================   
end pkg_ada_callpython_module;
-- ========================================================

