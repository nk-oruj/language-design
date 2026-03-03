# Language Manual

## Introduction

This document introduces the core syntax and semantics of the language in design. It is not a formal specification. Instead, it explains how to read and write programs using the fundamental constructs.

The language is designed to be:

- Explicit
- Deterministic
- Structurally clear
- Low‑level but readable

There are no hidden behaviors, implicit conversions, or automatic memory management. Every operation must be written intentionally.

---

# 1. Program Structure

A program file consists of one module.

```
MODULE MyModule
    ... declarations ...
FINISH MyModule
```

A module may contain:

- STRUCTURE declarations
- PROCEDURE declarations

All declarations inside a module are module-scoped.

---

# 2. Primitive Types

The language provides fixed-size numeric types:

- int8, int16, int32, int64
- flt32, flt64

There is no dedicated boolean type.

## Boolean Interpretation

Boolean logic is represented using integers:

- 0x00 is read false
- Any non-zero value is read true

Comparison operators return int8:

- 0xFF for true
- 0x00 for false

Logical operators (and, or, xor, not) operate bitwise and therefore also work for boolean-style values.

---

# 3. Structures and Pointers

Structures are defined in two ways:

```
STRUCTURE NodeDesc
RECORD
    value : int32
    next  : Node
FINISH

STRUCTURE Node AS POINT TO NodeDesc
```

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

# 4. Expressions

Expressions use prefix bracket notation:

```
[add a b]
[mul x [add y 3]]
```

Supported operators:

Arithmetic:

- add, sub, mul, div, mod

Bitwise / Logical:

- and, or, xor, not

Comparison:

- lt, le, gt, ge, eq, ne

Nil check:

- nil

Expressions are evaluated:

- Strictly
- Left-to-right
- Fully (no short-circuiting)

Type mismatches are compile-time errors.

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

# 8. Design Principles

This language follows these principles:

- No implicit memory allocation
- No implicit dereferencing
- No implicit type conversion
- No hidden control flow
- All mutation is explicit

The goal is structural clarity and deterministic execution.

---

End of Manual

