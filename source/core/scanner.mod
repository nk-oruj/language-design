MODULE scanner;
(* atropos *)

IMPORT
    Files,
    format, stream;

CONST
    invalidSym*     = 0;
    eofSym*         = 1;

    lparenSym*      = 2;
    rparenSym*      = 3;
    lbracketSym*    = 4;
    rbracketSym*    = 5;

    nameSym*        = 6;
    integerSym*     = 7;
    floatSym*       = 8;

    procedureSym*   = 9;
    moduleSym*      = 10;
    recordSym*      = 11;
    schemeSym*      = 12;
    finishSym*      = 13;
    getsSym*        = 14;
    setsSym*        = 15;
    loadSym*        = 16;
    withSym*        = 17;
    callSym*        = 18;
    liftSym*        = 19;
    dropSym*        = 20;
    addSym*         = 21;
    subSym*         = 22;
    mulSym*         = 23;
    divSym*         = 24;
    shrSym*         = 25;
    shlSym*         = 26;
    eqSym*          = 27;
    neSym*          = 28;
    geSym*          = 29;
    gtSym*          = 30;
    leSym*          = 31;
    ltSym*          = 32;
    orSym*          = 33;
    xorSym*         = 34;
    andSym*         = 35;
    notSym*         = 36;
    ifSym*          = 37;
    ofSym*          = 38;

TYPE
    SymbolDesc* = RECORD
        id*             : INTEGER;
        spanStart*      : LONGINT;
        spanEnd*        : LONGINT;
        spanSize*       : LONGINT;
        value*           : ARRAY 64 OF CHAR;
    END;
    Symbol* = POINTER TO SymbolDesc;

PROCEDURE StartSymbol(VAR symbol : Symbol; source : stream.File);
BEGIN

    symbol.spanStart := Files.Pos(source.rider);
    format.Clear(symbol.value);

END StartSymbol;

PROCEDURE FinishSymbol(VAR symbol : Symbol; source : stream.File; id : INTEGER);
BEGIN

    symbol.id := id;
    symbol.spanEnd := Files.Pos(source.rider);
    symbol.spanSize := symbol.spanEnd - symbol.spanStart;

END FinishSymbol;

PROCEDURE ScanName*(VAR symbol : Symbol; source : stream.File);
VAR
    token : CHAR;

BEGIN

    REPEAT
        format.AppendChr(symbol.value, token);
        Files.Read(source.rider, token);
    UNTIL ~(((token >= "a") & (token <= "z")) OR ((token >= "A") & (token <= "Z")));

    FinishSymbol(symbol, source, nameSym);

END ScanName;

PROCEDURE ScanSymbol*(VAR symbol : Symbol; source : stream.File);
VAR
    token : CHAR;

BEGIN

    NEW(symbol);

    (* passing through control characters *)
    REPEAT
        IF source.rider.eof
        THEN
            StartSymbol(symbol, source);
            FinishSymbol(symbol, source, eofSym);
            RETURN;
        END;

        Files.Read(source.rider, token);
    UNTIL token > 20X;

    StartSymbol(symbol, source);

    IF (((token >= "a") & (token <= "z")) OR ((token >= "A") & (token <= "Z")))
    THEN
        stream.RevertByte(source);
        ScanName(symbol, source);
        stream.RevertByte(source);
        RETURN;
    END;

    format.AppendChr(symbol.value, token);
    FinishSymbol(symbol, source, invalidSym);
    RETURN;

END ScanSymbol;

END scanner.
