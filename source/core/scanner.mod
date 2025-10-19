MODULE scanner;
(* atropos *)

IMPORT
    Files, Out,
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
    floaterSym*     = 8;

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
    fromSym*          = 38;

TYPE
    SymbolDesc* = RECORD
        id*             : INTEGER;
        spanStart*      : LONGINT;
        spanEnd*        : LONGINT;
        spanSize*       : LONGINT;
        value*          : ARRAY 64 OF CHAR;
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
    symbol.spanSize := symbol.spanEnd - symbol.spanStart + 1;

END FinishSymbol;

PROCEDURE ScanNominal(VAR token : CHAR; VAR symbol : Symbol; source : stream.File);
BEGIN

    CASE token OF
        ""
    ELSE
    END;

END ScanNominal;

PROCEDURE ScanNumeral(VAR token : CHAR; VAR symbol : Symbol; source : stream.File);
VAR
    last : CHAR;

BEGIN

    IF token = "0"
    THEN
        format.AppendChr(symbol.value, token);
        Files.Read(source.rider, token);
        
        IF (((token >= "a") & (token <= "z")) OR ((token >= "A") & (token <= "Z")) OR ((token >= "0") & (token <= "9")))
        THEN
            format.AppendChr(symbol.value, token);
            FinishSymbol(symbol, source, invalidSym);
            RETURN;
        ELSIF token = "."
        THEN
            format.AppendChr(symbol.value, token);
        ELSE
            stream.RevertByte(source);
            FinishSymbol(symbol, source, integerSym);
            RETURN;
        END;    
    ELSE
        WHILE (token >= "0") & (token <= "9")
        DO
            format.AppendChr(symbol.value, token);
            Files.Read(source.rider, token);
        END;
 
        IF (((token >= "a") & (token <= "z")) OR ((token >= "A") & (token <= "Z")))
        THEN
            format.AppendChr(symbol.value, token);
            FinishSymbol(symbol, source, invalidSym);
            RETURN;
        ELSIF token = "."
        THEN
            format.AppendChr(symbol.value, token);
        ELSE
            stream.RevertByte(source);
            FinishSymbol(symbol, source, integerSym);
            RETURN;
        END;    
    END;

    Files.Read(source.rider, token);

    IF token = "0"
    THEN
        format.AppendChr(symbol.value, token);
        Files.Read(source.rider, token);
            
        IF (((token >= "a") & (token <= "z")) OR ((token >= "A") & (token <= "Z")))
        THEN
            format.AppendChr(symbol.value, token);
            FinishSymbol(symbol, source, invalidSym);
            RETURN;
        ELSIF ((token >= "0") & (token <= "9"))
        THEN
            format.AppendChr(symbol.value, token);
        ELSE
            stream.RevertByte(source);
            FinishSymbol(symbol, source, floaterSym);
            RETURN;
        END;
    END;     

    last := "0";

    WHILE ((token >= "0") & (token <= "9"))
    DO
        last := token;
        format.AppendChr(symbol.value, token);
        Files.Read(source.rider, token);        
    END;

    IF (((token >= "a") & (token <= "z")) OR ((token >= "A") & (token <= "Z")))
    THEN
        format.AppendChr(symbol.value, token);
        FinishSymbol(symbol, source, invalidSym);
        RETURN;
    ELSE
        IF last = "0"
        THEN 
            stream.RevertByte(source);
            FinishSymbol(symbol, source, invalidSym);
            RETURN;
        ELSE
            stream.RevertByte(source);
            FinishSymbol(symbol, source, floaterSym);
            RETURN;
        END;
    END;

END ScanNumeral;

PROCEDURE ScanSymbol*(VAR symbol : Symbol; source : stream.File);
VAR
    token : CHAR;

BEGIN

    (* pass over through control characters *)
    REPEAT
        IF source.rider.eof
        THEN
            StartSymbol(symbol, source);
            FinishSymbol(symbol, source, eofSym);
            RETURN;
        END;

        Files.Read(source.rider, token);
    UNTIL token > 20X;

    (* start symbol processing *)
    StartSymbol(symbol, source);

    (* determine type of the symbol *)
    CASE token OF
        | "A".."Z",
          "a".."z":
            (* process nominal symbols *)
            ScanNominal(token, symbol, source);

        | "0".."9":
            (* process numeral symbols *)
            ScanNumeral(token, symbol, source);

        | "[":
            format.AppendChr(symbol.value, token);
            FinishSymbol(symbol, source, lbracketSym);

        | "]":
            format.AppendChr(symbol.value, token);
            FinishSymbol(symbol, source, rbracketSym);

        | "(":
            format.AppendChr(symbol.value, token);
            FinishSymbol(symbol, source, lparenSym);

        | ")":
            format.AppendChr(symbol.value, token);
            FinishSymbol(symbol, source, rparenSym);
    ELSE
        (* process invalid symbols *)
        format.AppendChr(symbol.value, token);
        FinishSymbol(symbol, source, invalidSym);
    END;

END ScanSymbol;

END scanner.
