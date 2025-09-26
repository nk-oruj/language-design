MODULE scanner;
(* atropos *)

IMPORT
    Files;
    
(*  *)

CONST
    invalid*    = 0;
    eof*        = 1;    
    lparen*     = 2;
    rparen*     = 3;
    lbracket*   = 4;
    rbracket*   = 5;
    name*       = 6;
    integer*    = 7;
    float*      = 8;
    procedure*  = 9;
    module*     = 10;
    record*     = 11;
    scheme*     = 12;
    finish*     = 13;
    gets*       = 14;
    sets*       = 15;
    load*       = 16;
    with*       = 17;
    call*       = 18;
    lift*       = 19;
    drop*       = 20;
    add*        = 21;
    sub*        = 22;
    mul*        = 23;
    div*        = 24;
    shr*        = 25;
    shl*        = 26;
    eq*         = 27;
    ne*         = 28;
    ge*         = 29;
    gt*         = 30;
    le*         = 31;
    lt*         = 32;
    or*         = 33;
    xor*        = 34;
    and*        = 35;
    not*        = 36;
    if*         = 37;
    of*         = 38;

(*  *)


PROCEDURE riderGoBack(VAR rider : Files.Rider, file : Files.File);
VAR
    pos : INT32;

BEGIN

    pos = Files.Pos(rider);
    
    IF pos > 0
    THEN
        pos := pos - 1;

    Files.Set(rider, file, pos);

END;

PROCEDURE Scan*(VAR symbol : INTEGER; VAR rider : Files.Rider);
VAR
    chr : CHAR;
BEGIN

    (* if control characters, skip through *)
    chr := 0X; WHILE (~rider.eof) & (chr <= " ")
    DO
        Files.Read(rider, chr);
    END;

    (* if end of file, return end of file symbol *)
    IF rider.eof
    THEN
        symbol := eof;
        RETURN;
    END;

    (* if potential comment, process through *)
    IF chr = "#"
    THEN
        WHILE (~rider.eof) & (chr # CHR(10))
        DO
            Files.Read(rider, chr);
        END;

        Scan(symbol, rider);
        RETURN;
    END;

    (* match through these characters *)
    IF chr = CHR(62)
    THEN
        symbol := right;
        RETURN;
    END;

    IF chr = CHR(60)
    THEN
        symbol := left;
        RETURN;
    END;

    IF chr = CHR(43)
    THEN
        symbol := increase;
        RETURN;
    END;

    IF chr = CHR(45)
    THEN
        symbol := decrease;
        RETURN;
    END;

    IF chr = CHR(44)
    THEN
        symbol := input;
        RETURN;
    END;

    IF chr = CHR(46)
    THEN
        symbol := output;
        RETURN;
    END;

    IF chr = CHR(91)
    THEN
        symbol := fjump;
        RETURN;
    END;

    IF chr = CHR(93)
    THEN
        symbol := bjump;
        RETURN;
    END;

    (* if nothing matches, then it's invalid character *)
    symbol := invalid;
    RETURN;

END Scan;

END scanner.
