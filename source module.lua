
--[[
    Lua Dust; Lua Library
    
    Author; RoyallyFlushed
    Date; 04.12.18
    
    Version; 1.03.2.03
    
    
    ------------------------------------------------------------------------------------------------------------------------
    Command Properties:
    
        Name: Displays command name
        Desc: Small description of command
        Active: Whether or not a command is accessible
        Type: Whether or not the function returns something
        Meta: Whether or not the metatable is connected to it (Allows function to be called by calling the command table)
        Args: Array containing all function arguments
        Function: The function attached to the command
        
        
        NOTES:
        
        - Include Meta tag into table and set to false to hide from Info command
        - Run function by calling command table to invoke metamethods, run function directly to run raw
        
        - Apply readonly table to each table within the dictionary and connect metamethods to the original table

--]]

--// Callback function for validation purposes
local function Run(self, func, ...)
    --// Command Function Handler - On Call
    if self.Active then
        return func(...)
    end
end

local mt = {
    
    __call = function(self, ...)
        if self['Function'] ~= nil then
            return Run(self, self.Function, ...) or nil
        end
    end;
    
    __newindex = function(self, index, value) 
        error'Attempt to edit read-only table!'
    end;
    
}

library = {
    --// Lua Dust Command Library
    Name = 'Dust - Lua Library';
    Version = 'LuaDust.lua Library; Module; 1.03.2.03';
    Author = 'RoyallyFlushed';
    
    TestFunction = {
        Name = 'Test Function';
        Desc = 'Tests that the library works correctly';
        Active = true;
        Type = 'void';
        Meta = true;
        Args = {};
        Function = function(self, ...)
            local success, result = pcall(function() return self.TestFunction.Name end)
            
            if success then
                print (result..' successfully ran')
            else
                print 'Lua Dust encountered a problem'
            end
        end;
    };

    Info = {
        Name = 'Info Function';
        Desc = 'Displays all information about this library';
        Active = true;
        Type = 'void';
        Meta = true;
        Args = {};
        Function = function(...)
            local info = '--------------------------------------------------------------------------------------------------\nDust Library\n'
            local count = 0
            
            for i,v in next, library do
                if (type(v) == 'table') and (v['Meta'] and v['Active']) then
                    info = info..'\n  v '..v.Name..'   :   '..v.Desc..'\n'
                    count = v['Function'] and count + 1 or count
                    for _,k in next, v do
                        if (type(k) == 'table') and (k['Function'] ~= nil) and (k['Active']) then
                            info = info..'      > '..k.Name..'    :    '..k.Desc..'\n'
                            count = count + 1
                        end
                    end
                end
            end
            
            info = info..'\nTotal Commands:     '..count..'\n--------------------------------------------------------------------------------------------------\n'
            print(info)
        end;
    };
    
    Out = {
        Name = 'Print Function';
        Desc = 'Outputs the arguments parsed';
        Active = true;
        Type = 'void';
        Meta = true;
        Args = {'(tuple) Items'};
        Function = function(self, ...)
            print(...)
        end;
    };

    --// Math Operations
    Mth = {
        Name = 'Dust Math Library';
        Desc = 'Subcategory for dust math operations';
        Active = true;
        Meta = true;
        
        Add = {
            Name = 'Math Add Function';
            Desc = 'Adds the arguments together and returns the answer';
            Active = true;
            Type = 'return';
            Meta = true;
            Args = {'(tuple) (number) Numbers'};
            Function = function(self, ...)
                local ans = 0
                
                for i,v in next, {...} do
                    ans = ans + v
                end
                
                return ans
            end;
        };
    
        Factorial = {
            Name = 'Math Factorial Function'; 
            Desc = 'Mathematical Algorithm to calculate the factorial of any given number';
            Active = true;
            Type = 'return';
            Meta = true;
            Args = {'(number) Number'};
            Function = function(self, num)
                local ans = 1
                
                for i = 1, num do
                    ans = ans*i
                end
                
                return ans
            end;
        };
    };

    --// Table Operations
    Tbl = {
        Name = 'Dust Table Library';
        Desc = 'Subcategory for table operations';
        Active = true;
        Meta = true;
        
        Release = {
            Name = 'Table Release Function';
            Desc = 'Returns all the values in a given table with the given separator as a string';
            Active = true;
            Type = 'return';
            Meta = true;
            Args = {'(table) Table'; '(string) Separator'};
            Function = function(self, Table, Separator)
                return library.command_repository:release(Table, Separator)
            end;
        };
    
        Out = {
            Name = 'Table Output Function';
            Desc = 'Outputs all the values in a given table with the given separator';
            Active = true;
            Type = 'void';
            Meta = true;
            Args = {'(table) Table'; '(string) Separator'};
            Function = function(self, Table, Separator)
                print(library.command_repository:release(Table, Separator))
            end;
        };
    
        Merge = {
            Name = 'Table Merge Function';
            Desc = 'Concatenates given tables into one and returns as a table';
            Active = true;
            Type = 'return';
            Meta = true;
            Args = {'(table) Table1'; '(table) Table2'};
            Function = function(self, Table1, Table2)
                local newTable = {}
                
                for i,v in ipairs(Table1) do
                    newTable[#newTable+1] = v
                end
                
                for i,v in ipairs(Table2) do
                    newTable[#newTable+1] = v
                end
                
                return newTable
            end;
        };
    
        Add = {
            Name = 'Table Add Function';
            Desc = 'Adds all the numbers in an array and returns the value';
            Active = true;
            Type = 'return';
            Meta = true;
            Args = {'(table) Array'};
            Function = function(self, Array)
                local Total = 0
                
                for i,v in ipairs(Array) do
                    Total = Total + v
                end
                
                return Total
            end;
        };
    
        Pop = {
            Name = 'Table Pop Function';
            Desc = 'Removes the last item in an array and returns the array';
            Active = true;
            Type = 'return';
            Meta = true;
            Args = {'(table) Array'};
            Function = function(self, Array)
                local newArray = {}
                
                for i,v in next, Array do
                    if i ~= #Array then
                        newArray[i] = v
                    end
                end
                
                return newArray
            end;
        };
    
        Readonly = {
            Name = 'Table Readonly Function';
            Desc = 'Converts a given table into a readonly table and returns the new table';
            Active = true;
            Type = 'return';
            Meta = true;
            Args = {'(table) Table'};
            Function = function(self, Table)
                return setmetatable({}, {
                    __index = Table;
                    
                    __newindex = function(t, i, v)
                        error('Attempt to set value of readonly table', 3)
                    end;
                    
                    __metatable = false;
                })
            end;    
        };
    
    };

    --// String Operations
    Str = {
        Name = 'Dust String Library';
        Desc = 'Subcategory for dust string operations';
        Active = true;
        Meta = true;
        
        Split = {
            Name = 'String Split Function';
            Desc = 'Splits a string argument and returns as an array';
            Active = true;
            Type = 'return';
            Meta = true;
            Args = {'(string) String'; '(string) Separator'};
            Function = function(self, String, Separator)
                if (not Separator)  or (#(Separator) < 1) then Separator = ' ' end
                local Array = {}
                
                for selection in String:gmatch('[^'..Separator..']+') do
                    Array[#Array+1] = selection
                end
                
                return Array
            end;
        };
    
        Slice = {
            Name = 'String Slice Function';
            Desc = 'Slices the string into sections based on the given section size and returns as an array';
            Active = true;
            Type = 'return';
            Meta = true;
            Args = {'(string) Text'; '(int) Size'};
            Function = function(self, String, Size)
                local Array = {}
                local tempArray = {}
                
                if not Size then Size = 1 end
                
                for i = 1, #(String) do
                    tempArray[#tempArray+1] = String:sub(i, i)
                    
                    if (#tempArray >= Size) or (i == #(String)) then
                        local str = ''
                        for _,k in next, tempArray do
                            str = str..k
                        end
                        Array[#Array+1] = str
                        
                        tempArray = {}
                    end
                end
                
                return Array
            end;
        };
    
    };

    command_repository = {
        --// Library for storing duplicate source code or other stuff
        Active = true;
        Meta = false;
        
        release = {
            --// Repository for Release Command used by Out command
            Active = true;
            Meta = false;
            Function = function(self, Table, Separator)
                local String = ''
                if (not Separator) or (#(Separator) < 1) then Separator = ',' end
                
                for i,v in next, Table do
                    String = i ~= #Table and String..v..Separator or String..v
                end
                
                return String
            end
        };
    
    };

}

function ConnectMetatable(Table)
    if not getmetatable(Table) then setmetatable(Table, mt) end
    for i,v in next, Table do
        if type(v) == 'table' then
            setmetatable(v, mt)
            ConnectMetatable(v)
        end
    end
end

ConnectMetatable(library)
print('----------------------------------------------------\nLua Dust successfully added into environment!\n'..library.Version..'\n\n'..[[
Use the '.Info()' function on the library
to see the full list of available commands
----------------------------------------------------]]..'\n')

return library
