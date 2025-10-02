MODULE alpha;

IMPORT
    Files, Out,
    format, errors, options, scanner;
    (*parser;*)

VAR
    error           : errors.Error;
    setup           : options.OptionsData;
    symbol          : scanner.Symbol;
    symbolMessage   : ARRAY 256 OF CHAR;
BEGIN

    (* options parsing *)
    error := options.CreateSetup(setup);
    IF error # NIL
    THEN
        errors.Raise(error, "meta");
        RETURN;
    END;

    NEW(symbol);

    REPEAT
        scanner.ScanSymbol(symbol, setup.source);
        format.Clear(symbolMessage);

        format.AppendStr(symbolMessage, "ID: ");
        format.AppendInt(symbolMessage, symbol.id);
        format.AppendStr(symbolMessage, " VALUE: ");
        format.AppendChr(symbolMessage, CHR(34));
        format.AppendStr(symbolMessage, symbol.value);
        format.AppendChr(symbolMessage, CHR(34));
        format.AppendStr(symbolMessage, " POS: ");
        format.AppendInt(symbolMessage, symbol.spanStart);
        format.AppendStr(symbolMessage, " SIZE: ");
        format.AppendInt(symbolMessage, symbol.spanSize);
        Out.String(symbolMessage); Out.Ln;
        
    UNTIL symbol.id = scanner.eofSym;

    (* program parsing *)
    (* error := parser.Parse(setup.sourceRider, setup.targetRider);
    IF error # NIL
    THEN
        errors.Raise(error, "error");
        RETURN;
    END; *)

    (* closing options setup *)
    options.CloseSetup(setup);
END alpha.
