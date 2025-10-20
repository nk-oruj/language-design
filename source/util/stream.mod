MODULE stream;

IMPORT
    Files,
    errors, format;

TYPE
    FileDesc = RECORD
        content    : Files.File;
        rider      : Files.Rider;
    END;
    File* = POINTER TO FileDesc;

PROCEDURE OpenOld*(VAR file : File; path : ARRAY OF CHAR) : errors.Error;
VAR
    message : ARRAY 256 OF CHAR;

BEGIN

    NEW(file);

    file.content := Files.Old(path);

    IF file.content = NIL
    THEN
        format.Clear(message);
        format.AppendStr(message, "file not found at ");
        format.AppendChr(message, CHR(34));
        format.AppendStr(message, path);
        format.AppendChr(message, CHR(34));

        RETURN errors.Pipe(NIL, "stream", message);
    END;

    Files.Set(file.rider, file.content, 0);

    RETURN NIL;

END OpenOld;

PROCEDURE OpenNew*(VAR file : File; path : ARRAY OF CHAR) : errors.Error;
VAR
    message : ARRAY 256 OF CHAR;

BEGIN

    NEW(file);

    file.content := Files.New(path);
    
    IF file.content = NIL
    THEN
        format.Clear(message);
        format.AppendStr(message, "can't open file at ");
        format.AppendChr(message, CHR(34));
        format.AppendStr(message, path);
        format.AppendChr(message, CHR(34));
        RETURN errors.Pipe(NIL, "stream", message);
    END;

    Files.Set(file.rider, file.content, 0);

    RETURN NIL;

END OpenNew;

PROCEDURE CloseOld*(VAR file : File);
BEGIN

    Files.Close(file.content);

END CloseOld;

PROCEDURE CloseNew*(VAR file : File);
BEGIN

    Files.Register(file.content);
    Files.Close(file.content);

END CloseNew;

PROCEDURE ReadByte*(file : File; VAR token : CHAR);
BEGIN

    Files.Read(file.rider, token);

END ReadByte;

PROCEDURE RevertByte*(file : File);
VAR
    pos : LONGINT;

BEGIN

    pos := Files.Pos(file.rider);
    
    IF pos > 0
    THEN
        Files.Set(file.rider, file.content, pos - 1);
    END;

END RevertByte;

PROCEDURE GetPosition*(file : File; VAR value : LONGINT);
BEGIN

    value := Files.Pos(file.rider);

END GetPosition;

PROCEDURE IsEOF*(file : File) : BOOLEAN;
BEGIN

    RETURN file.rider.eof;

END IsEOF;

END stream.
