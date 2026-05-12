# Language Manual

# 1. Program

### a. a program file consists of a module with a heading declaration of module
```
module ModuleName
```

### b. a module may contain two types of elementary declarations following the declaration of module
- `structure` declaration
- `procedure` declaration

### c. all declarations inside a module are module-scoped outside

# 2. Primitives

### a. primitive types consist of integer, float, and boolean standards 
- integer - `int8`, `int16`, `int32`, `int64`
- float - `flt32`, `flt64`
- boolean - `bln`

# 3. Literals

### a. literal constants consist of integer, decimal, and boolean formats
- integer - `^(0|[-+]?[1-9][0-9]*)$`
- decimal - `^(0|[-+]?[1-9][0-9]*.[0-9]+)$`
- boolean - `^(true|false)$`

# 4. Names

### a. all names are formatted strictly with letters, no digits, no symbols
`^([a-zA-Z]+)$`

# 5. Expressions

### a. expressions are strictly scoped with brackets and are evalualted in pre-fix order
```
[operation operand operand]
```

### b. expressions support arithmetic, bitwise arithmetic, comparison and logic operations
- arithmetic (in numeral, out numeral) - add, sub, mul, div, mod
- bitwise (in integer, out integer) - and, or, xor, not
- comparison (in numeral, out boolean) - lt, le, gt, ge, eq, ne
- logic (in boolean, out boolean) - and, or, xor, not

### c. expression operands can be either a name, a literal, or another nested expression

# 6. Records

### a. records are fields of variable declarations used both in structure and procedure declarations
```
record
    variableOne : typeOne
    variableTwo : typeTwo
```

### c. variable type can either be a primitive, a structure definition, a procedure template, an array of the first two, or a point of the first two
```
record
    variableInt     : int32
    variableFlt     : flt32
    variableBln     : bln
    variableMyType  : MyType
    variableProc    : procedure(myInt : int32, myFlt : flt32, myBln : out bln)
    variableArray   : array of int32 sized 16
    variablePoint   : point to MyType
```

# 7. Structures

### a. structure template consists of keyword structure and a name
```
structure StructureName
```

### b. structure declaration names a new typing through structure template for either a record declaration or an already existing typing
```
structure StructureName
record
    variableInt : int32
finish

structure MyOtherStructure as array of int32 sized 16
```

### c. structure declaration should end with keyword finish in case of naming a record declaration

# 8. Procedures

### a. procedure template consists of keyword procedure, a name, and paramaters declaration
```
procedure ProcedureName(paramOne : typeOne, paramTwo : out typeTwo)
```

### b. 

## Pointer Allocation

Allocate memory:

```
LOAD node WITH NEW POINT
```

Assign null:

```
LOAD node WITH NIL POINT
```

Check for null with expression:

```
[nil node]
```

---


# 5. Assignment

All mutation is performed using the LOAD statement.

```
LOAD variable WITH expression
```

## Writing Through Pointers

Dereferencing is explicit:

```
LOAD int32 AT node.value WITH 10
```

Rules:

- `node.value` produces a pointer to the field.
- `LOAD Type AT pointer WITH value` writes into memory.
- Dereferencing NIL causes a runtime error.

## Arrays

```
LOAD array AT index WITH value
```

Out-of-bounds access is a runtime error.

---

# 6. Procedures

Procedure structure:

```
PROCEDURE Example(a : int32, OUT result : int32)
RECORD
    temp : int32
SCHEME
    LOAD temp WITH [add a 1]
    LOAD result WITH temp
FINISH
```

Rules:

- All OUT parameters must be assigned before the procedure finishes.
- Local variables are declared in the RECORD block.

---

# 7. Control Flow (Temporary)

Control flow uses labeled blocks inside procedure SCHEME.

```
SCHEME Loop
    ... statements ...
FINISH Loop
```

Execution normally flows from top to bottom.

## DROP

```
DROP Loop IF condition
```

If condition is true (non-zero), execution jumps to the statement after FINISH Loop.

## LIFT

```
LIFT Loop IF condition
```

If condition is true, execution jumps to the first statement inside SCHEME Loop.

Rules:

- Labels must be lexically enclosing.
- You cannot jump into a block from outside.

---
end of manual
