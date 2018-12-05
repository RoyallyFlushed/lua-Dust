--[[
    Lua Dust; Lua Library
    
    Author; RoyallyFlushed
    Date; 04.12.18
    
    Version; 1.01.2.13
    
    
    ------------------------------------------------------------------------------------------------------------------------
    Command Properties:
    
        Name: Displays command name
        Desc: Small description of command
        Key: A key used to access the function if it is locked
        Active: Whether or not a command is accessible
        Type: Whether or not the function returns something
        Meta: Whether or not the metatable is connected to it (Allows function to be called by calling the command table)
        Args: Array containing all function arguments
        Function: The function attached to the command
        
        
        NOTES:
        
        - self.key in mt used to not trigger function metatable so that return values are returned to caller

--]]

local mt = {
    __call = function(self, ...)
        if self['Function'] ~= nil then
            if self.Type == 'return' then
                --// return function handler - on call
                return self.Function[self.Key](...) or nil
            elseif self.Type == 'void' then
                --// void function handler - on call
                self.Function[self.Key](...)
            end
        end
    end;
    
    __newindex = function(self, index, value) end;
}

library = {
    --// Lua Dust Command Library
    Name = 'Dust - Lua Library';
    Version = 'LuaDust.lua Library; Module; 1.01.2.13';
    Author = 'RoyallyFlushed';
    
    TestFunction = {
        Name = 'Test Function';
        Desc = 'Tests that the library works correctly';
        Key = '85bak4';
        Active = true;
        Type = 'void';
        Meta = true;
        Args = {};
        Function = {['85bak4'] = function(self, ...)
            if self.TestFunction.Active then
                local success, result = pcall(function() return self.TestFunction.Name end)
                if success then
                    print (result..' successfully ran')
                else
                    print 'Lua Dust encountered a problem'
                end
            end
        end};
    };

    info = {
        Name = 'Info Function';
        Desc = 'Displays all information about this library';
        Key = '2nbh32';
        Active = true;
        Type = 'void';
        Meta = true;
        Args = {};
        Function = {['2nbh32'] = function(...)
            if library.info.Active then
                local info = '--------------------------------------------------------------------------------------------------\nDust Library\n\n'
                local count = 0
                
                for i,v in next, library do
                    if (type(v) == 'table') and ((v['Meta'] and v['Active']) or not v['Meta']) then
                        info = info..'  v '..v.Name..'   :   '..v.Desc..'\n'
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
            end
        end}
    };
    
    Out = {
        Name = 'Print Function';
        Desc = 'Outputs the arguments parsed';
        Key = '0JHbf3';
        Active = true;
        Type = 'void';
        Meta = true;
        Args = {'(tuple) Items'};
        Function = {['0JHbf3'] = function(self, ...)
            if self.Out.Active then
                print(...)
            end
        end};
    };

    --// Math Operations
    Math = {
        Name = 'Dust Math Library';
        Desc = 'Subcategory for dust math operations';
        
        Add = {
            Name = 'Add Function';
            Desc = 'Adds the arguments together and returns the answer';
            Key = '0gh4Gd';
            Active = true;
            Type = 'return';
            Meta = true;
            Args = {'(tuple) (number) Numbers'};
            Function = {['0gh4Gd'] = function(self, ...)
                if self.Add.Active then
                    local ans = 0
                    for i,v in next, {...} do
                        ans = ans + v
                    end
                    return ans
                end
            end};
        };
    };

    --// Table Operations
    Table = {
        Name = 'Dust Table Library';
        Desc = 'Subcategory for table operations';
        
        Out = {
            Name = 'Table Output Function';
            Desc = 'Outputs all the values of in a given table with the given separator';
            Key = '0ghe5g';
            Active = true;
            Type = 'return';
            Meta = true;
            Args = {'(table) Table'; '(string) Separator'};
            Function = {['0ghe5g'] = function(self, Table, Separator)
                if self.Out.Active then
                    if not Separator then Separator = ',' end
                    local String = ''
                    for i,v in next, Table do
                        String = i ~= #Table and String..v..Separator or String..v
                    end
                    return String
                end
            end};
        };
    
        Merge = {
            Name = 'Table Merge Function';
            Desc = 'Concatenates given tables into one and returns as a table';
            Key = '5bgj3g';
            Active = true;
            Type = 'return';
            Meta = true;
            Args = {'(table) Table1'; '(table) Table2'};
            Function = {['5bgj3g'] = function(self, Table1, Table2)
                if self.Merge.Active then
                    local newTable = {}
                    
                    for i,v in ipairs(Table1) do
                        newTable[#newTable+1] = v
                    end
                    
                    for i,v in ipairs(Table2) do
                        newTable[#newTable+1] = v
                    end
                    
                    return newTable
                end
            end};
        };
    
        Add = {
            Name = 'Table Add Function';
            Desc = 'Adds all the numbers in an array and returns the value';
            Key = '94qa3k';
            Active = true;
            Type = 'return';
            Meta = true;
            Args = {'(table) Array'};
            Function = {['94qa3k'] = function(self, Array)
                if self.Add.Active then
                    Total = 0
                    for i,v in ipairs(Array) do
                        Total = Total + v
                    end
                    return Total
                end
            end};
        };
    
    };

    --// String Operations
    String = {
        Name = 'Dust String Library';
        Desc = 'Subcategory for dust string operations';
        
        Split = {
            Name = 'String Split Function';
            Desc = 'Splits a string argument and returns as an array';
            Key = '03v5hg';
            Active = true;
            Type = 'return';
            Meta = true;
            Args = {'(string) String'; '(string) Separator'};
            Function = {['03v5hg'] = function(self, String, Separator)
                if self.Split.Active then
                    if not Separator then Separator = ' ' end
                    local Array = {}
                    for selection in String:gmatch('[^'..Separator..']+') do
                        Array[#Array+1] = selection
                    end
                    return Array
                end
            end};
        };
    
    };
}

function ConnectMetatable(Table)
    if not getmetatable(Table) then setmetatable(Table, mt) end
    for i,v in next, Table do
        if type(v) == 'table' then
            setmetatable(v, mt)
            if v['Function'] ~= nil then
                --// Manual Function Calling Handler
                setmetatable(v.Function, {__call = function(self, ...) if v.Active then error('Attempt to run function manually') end end})
            end
            ConnectMetatable(v)
        end
    end
end

ConnectMetatable(library)
print('----------------------------------------------------\nLua Dust successfully added into environment!\n'..library.Version..'\n----------------------------------------------------\n')

return library
