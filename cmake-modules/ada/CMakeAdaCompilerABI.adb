--I am pretty sure that due to CMake and Ada's object compile destination incompatibility during configuration initialization, this method of determining ABI will never work with CMake 2.8.7 downward.

with Text_Io;
use Text_Io;

procedure CMakeAdaCompilerABI is

default : Boolean := True;

begin

-- Address Size
if default then
    Put("INFO:sizeof_dptr[8]");
else
    Put("INFO:sizeof_dptr[4]");
end if;

-- Application Binary Interface
if default then
    Put("INFO:abi[ELF]");
else
    Put("INFO:abi[ERROR]");
end if;
    Put("ABI Detection");

end CMakeAdaCompilerABI;
