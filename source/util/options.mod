MODULE options;

IMPORT
    Args,
    errors, format, stream;

TYPE
    OptionsDataDesc* = RECORD
        source*, target* : stream.File;
    END;
    OptionsData* = POINTER TO OptionsDataDesc;

PROCEDURE CreateSetup*(VAR setup : OptionsData) : errors.Error;
VAR
    error                   : errors.Error;
    message                 : ARRAY 256 OF CHAR;
    sourcePath, targetPath  : ARRAY 128 OF CHAR;

BEGIN

    NEW(setup);

    IF Args.argc # 3
    THEN
        RETURN errors.Pipe(NIL, "options", "error in usage: ./alpha <source> <target>");
    END;

    Args.Get(1, sourcePath);
    Args.Get(2, targetPath);
    
    error := stream.OpenOld(setup.source, sourcePath);

    IF error # NIL
    THEN
        format.Clear(message);
        format.AppendStr(message, "couldn't open the source file");

        RETURN errors.Pipe(error, "options", message);
    END;
    
    error := stream.OpenNew(setup.target, targetPath);

    IF error # NIL
    THEN
        format.Clear(message);
        format.AppendStr(message, "couldn't open the target file");

        RETURN errors.Pipe(error, "options", message);
    END;

    RETURN NIL;

END CreateSetup;

PROCEDURE CloseSetup*(VAR setup : OptionsData);
BEGIN

    stream.CloseOld(setup.source);
    stream.CloseNew(setup.target);

END CloseSetup;

END options.
