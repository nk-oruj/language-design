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
    fromSym*        = 38;

TYPE
    SymbolDesc* = RECORD
        id*             : INTEGER;
        value*          : ARRAY 64 OF CHAR;
        spanA*          : LONGINT;
        spanB*          : LONGINT;
    END;
    Symbol* = POINTER TO SymbolDesc;

PROCEDURE^ ScanSymbol*(VAR symbol : Symbol; source : stream.File);

PROCEDURE StartSymbol(VAR symbol : Symbol; source : stream.File);
BEGIN

    symbol.spanA := Files.Pos(source.rider);
    format.Clear(symbol.value);

END StartSymbol;

PROCEDURE FinishSymbol(VAR symbol : Symbol; source : stream.File; id : INTEGER);
BEGIN

    symbol.id := id;
    symbol.spanB := Files.Pos(source.rider);

END FinishSymbol;

PROCEDURE ScanNominal(VAR token : CHAR; VAR symbol : Symbol; source : stream.File);
VAR
    first : CHAR;

BEGIN

    first := token;

    WHILE (((token >= "A") & (token <= "Z")) OR ((token >= "a") & (token <= "z")))
    DO
        format.AppendChr(symbol.value, token);
        Files.Read(source.rider, token);
    END;

    IF ((token >= "0") & (token <= "9"))
    THEN
        format.AppendChr(symbol.value, token);
        FinishSymbol(symbol, source, invalidSym);
        RETURN;
    END;

    stream.RevertByte(source);
    FinishSymbol(symbol, source, nameSym);

    CASE first OF
        | "a":
            IF format.Equal(symbol.value, "add") THEN FinishSymbol(symbol, source, addSym); RETURN; END;
            IF format.Equal(symbol.value, "and") THEN FinishSymbol(symbol, source, andSym); RETURN; END;
        | "c":
            IF format.Equal(symbol.value, "call") THEN FinishSymbol(symbol, source, callSym); RETURN; END;
        | "d":
            IF format.Equal(symbol.value, "drop") THEN FinishSymbol(symbol, source, dropSym); RETURN; END;
            IF format.Equal(symbol.value, "div") THEN FinishSymbol(symbol, source, divSym); RETURN; END;
        | "e":
            IF format.Equal(symbol.value, "eq") THEN FinishSymbol(symbol, source, eqSym); RETURN; END;
        | "f":
            IF format.Equal(symbol.value, "finish") THEN FinishSymbol(symbol, source, finishSym); RETURN; END;
            IF format.Equal(symbol.value, "from") THEN FinishSymbol(symbol, source, fromSym); RETURN; END;
        | "g":
            IF format.Equal(symbol.value, "gets") THEN FinishSymbol(symbol, source, getsSym); RETURN; END;
            IF format.Equal(symbol.value, "ge") THEN FinishSymbol(symbol, source, geSym); RETURN; END;
            IF format.Equal(symbol.value, "gt") THEN FinishSymbol(symbol, source, gtSym); RETURN; END;
        | "i":
            IF format.Equal(symbol.value, "if") THEN FinishSymbol(symbol, source, ifSym); RETURN; END;
        | "l":
            IF format.Equal(symbol.value, "load") THEN FinishSymbol(symbol, source, loadSym); RETURN; END;
            IF format.Equal(symbol.value, "lift") THEN FinishSymbol(symbol, source, liftSym); RETURN; END;
            IF format.Equal(symbol.value, "le") THEN FinishSymbol(symbol, source, leSym); RETURN; END;
            IF format.Equal(symbol.value, "lt") THEN FinishSymbol(symbol, source, ltSym); RETURN; END;
        | "m":
            IF format.Equal(symbol.value, "module") THEN FinishSymbol(symbol, source, moduleSym); RETURN; END;
            IF format.Equal(symbol.value, "mul") THEN FinishSymbol(symbol, source, mulSym); RETURN; END;
        | "n":
            IF format.Equal(symbol.value, "ne") THEN FinishSymbol(symbol, source, neSym); RETURN; END;
            IF format.Equal(symbol.value, "not") THEN FinishSymbol(symbol, source, notSym); RETURN; END;
        | "o":
            IF format.Equal(symbol.value, "or") THEN FinishSymbol(symbol, source, orSym); RETURN; END;
        | "p":
            IF format.Equal(symbol.value, "procedure") THEN FinishSymbol(symbol, source, procedureSym); RETURN; END;
        | "r":
            IF format.Equal(symbol.value, "record") THEN FinishSymbol(symbol, source, recordSym); RETURN; END;
        | "s":
            IF format.Equal(symbol.value, "scheme") THEN FinishSymbol(symbol, source, schemeSym); RETURN; END;
            IF format.Equal(symbol.value, "sets") THEN FinishSymbol(symbol, source, setsSym); RETURN; END;
            IF format.Equal(symbol.value, "sub") THEN FinishSymbol(symbol, source, subSym); RETURN; END;
            IF format.Equal(symbol.value, "shr") THEN FinishSymbol(symbol, source, shrSym); RETURN; END;
            IF format.Equal(symbol.value, "shl") THEN FinishSymbol(symbol, source, shlSym); RETURN; END;
        | "w":
            IF format.Equal(symbol.value, "with") THEN FinishSymbol(symbol, source, withSym); RETURN; END;
        | "x":
            IF format.Equal(symbol.value, "xor") THEN FinishSymbol(symbol, source, xorSym); RETURN; END;
    ELSE
        FinishSymbol(symbol, source, nameSym);
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

PROCEDURE ScanComment(VAR token : CHAR; VAR symbol : Symbol; source : stream.File);
BEGIN

    format.AppendChr(symbol.value, token);
    FinishSymbol(symbol, source, lparenSym);

    Files.Read(source.rider, token);
    IF token # "*"
    THEN
        stream.RevertByte(source);
        RETURN;
    END;

    WHILE TRUE
    DO
        Files.Read(source.rider, token);
        IF token = "*"
        THEN
            Files.Read(source.rider, token);
            IF token = ")"
            THEN
                ScanSymbol(symbol, source);
                RETURN;
            ELSIF source.rider.eof
            THEN
                StartSymbol(symbol, source);
                FinishSymbol(symbol, source, eofSym);
                RETURN;
            END;
        ELSIF source.rider.eof
        THEN
            StartSymbol(symbol, source);
            FinishSymbol(symbol, source, eofSym);
            RETURN;
        END;
    END;

END ScanComment;

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
            ScanComment(token, symbol, source);

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
