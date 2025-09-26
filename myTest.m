module [test]

extern structure [test]
record
    [myProp] : structure
    record
        [propA] : [integer]
        [propB] : [integer]
    finish
finish

extern structure [tost]
record
    [propA] : [integer]
    [propB] : [integer]
finish

finish [test]