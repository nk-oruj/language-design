MODULE files;

IMPORT
    Files,
    errors;

TYPE
    FileDesc* = RECORD
        source  : Files.File;
        rider   : Files.Rider;
    END;
    File* = POINTER TO FileDesc;

PROCEDURE OpenOld(VAR file : File; path : ARRAY OF CHAR) : errors.Error;
VAR
    file : File;

BEGIN
    NEW(file);
    file.source := Files.Old(path);
    
END;

END files.
