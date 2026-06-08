# Language Manual

## Names

```regexp
^[_a-z][_a-zA-Z0-9]+$
```
- All names are preferred to be in snake case.

## Literals

### Integers

```regexp
^(0|[-+]?[1-9][0-9]*)$
```

### Decimals

```regexp
^(0|[-+]?[1-9][0-9]*.[0-9]+)$
```

### Booleans*

```regexp
^(true|false)$
```

## Module

- A source file represents a module.
- All declared names share a single namespace under the module.

```text
module ...

import
    ...

structure ...
record
    ...
finish

symbol
    ...

static
    ...
    
procedure ... (...)
define
    ...
scheme
    ...
finish
```

---

## Imports

```text
import
    SYSTEM
    graphics
```

- Imported names are referenced through qualification.

```text
SYSTEM.MIN_INT64
graphics.clear_screen
```

---

## Structures

- Compile-time semantic declarations of types with records.

```text
structure point
record
    x: flt32
    y: flt32
finish
```

---

## Symbols

- Compile-time semantic declarations of constants.

```text
symbol
    max_players: int32 1024
    pi_digits: int32 314159
```

Restrictions:

- Must use unit types.
- Values must be literals.
- No expressions.

No runtime storage generated. The values are pasted directly inside the instructions.

---

## Statics

Run-time declarations of module-scoped variables. (bss section)

```
static
    my_int: int32
    my_message: array 128 of int8
```

---

## Procedures

Run-time declarations of executable code. (text section)

```text
procedure my_procedure (...)
define
    ...
scheme
    ...
finish
```

---

## Types

### Unit Types (Primitives)

#### Signed Integers

```text
int8, int16, int32, int64
```

#### Unsigned integers

```text
uint8, uint16, uint32, uint64
```

#### Floats

```text
flt32, flt64
```

#### Boolean

```text
bln
```

---

### Record Types

- Defined through structures.

```text
structure point
record
    x: flt32
    y: flt32
finish
```

- Usage

```text
point
```

- Properties 
    * Fixed layout.
    * Fixed size.
    * Not assignable as a whole.
    * Not passable by value.

- there is no type aliasing system and only record can receive names through structure declarations.

---

### Array Types

```text
array 16 of int32
array 1024 of point
```

- Properties
    * Fixed layout.
    * Fixed size.
    * Not assignable as a whole.
    * Not passable by value.

---

### Reference Types

#### Unit references

```text
ref int32
```

#### Record references

```text
ref point
```

#### Array references

```text
ref array of int32
```

#### Procedure references

```text
ref procedure (...)
```

---

## Types (Continuation)

### Record Field Selection

- Field selection from a record yields the type of the field.

```text
structure point
record
    x: flt32
    y: flt32
finish

...

my_point: point

...

my_point (is point)
my_point.x (is flt32)
```

- Field selection from a record reference yields the reference to field with its type.

```text
my_point_ref: ref point

...

my_point (is ref point)
my_point.x (is ref flt32)
```

---

### Array Element Selection

- Element selection from an array yields the type of the element.

```text
index: int64
my_array: array 16 of int32

...

my_array (is array 16 of int32)
my_array[index] (is int32)
```

- Element selection from an array reference yields reference to the element with its type.

```text
index: int64
my_array_ref: ref array of int32

...

my_array (is ref array of int32)
my_array[index] (is ref int32)
```

---

### Procedure Parameters

- Allowed types for procedure parameters

#### Unit Parameters

```text
..., value: int32, ...
```

#### Unit Reference parameters

```text
..., value: ref int32, ...
```

#### Record Reference parameters

```text
..., value: ref point, ...
```

#### Array Reference parameters

```text
..., values: ref array of int32, ...
```

#### Procedure Reference parameters

```text
..., callback: ref procedure (...), ...
```

## Procedures

### Procedure Variables Block

- Variables to be put in stack and to be used throughout procedure execution are declared initially in a `define` block.

```text
define
    my_local_int: int32
    my_local_arr: array 32 of flt64
    ...
```

---

### Procedure Statements Block

- Then the procedure statements are declared in a `scheme` block after.

```text
scheme
    my_local_int: load 0
    my_local_arr[0]: load 0
    ...
finish
```

---

## Expressions

- Expressions use prefix notation.

```text
[add 1 2]
```

- Expressions are written within brackets and can be nested.

```text
[mul [add 1 2] 5]
```

### Operations

#### Arithmetic Operations

```text
add, sub, mul, div, mod
```

```text
int, int to int
flt, flt to flt
```

---

#### Bitwise Operations

```text
and, or, xor, not, shr, shl
```

```text
int(, int) to int
```

---

#### Boolean Operations

```text
and, or, xor, not
```

```text
bln(, bln) to bln
```

---

#### Comparison Operations

```text
eq, ne, ge, gt, le, lt
```

```text
int, int to bln
flt, flt to bln
```

---

#### Reference Operations

```text
ref variable
```

- Produces a reference.

```text
val pointer
```

- Reads a value from a reference.

```text
len values
```

- obtains lengths of arrays and referenced arrays with appropriate compile-time solutions.

---

## Statements

### Assignments

#### Load

- Assigns value to local storage.

```text
counter: int32
```

```text
counter: load 0
```

```text
counter: load [add counter 1]
```

---

#### Pass

- Assigns value to storage through references.

```text
sum: ref int32
```

```text
sum: pass 100
```

```text
sum: pass [add [val sum] 1]
```

---

### Invocations

#### Exec

```text
procedure some_procedure (value: int32, result: ref int32)

...

my_value: int32
my_result: int32

...

some_procedure: exec (my_value, ref my_result)
```

- Expressions can't be put in parameter fields (*except ref usage which doesn't count as expression)

---

### Control Flow

```text
scheme loop
    ...
finish loop
```

- Control flow uses named scheme blocks inside procedure scheme blocks.
- Named scheme blocks can be nested.
- Two other statements are allowed to be used inside with its name.

---

## Drop

- Exits the scheme block with the given name.

```text
loop: drop
```

- Allows conditional usage

```text
loop: drop if [ge index count]
```

---

## Redo

- Restarts the execution of the scheme block with the given name.

```text
loop: redo
```

- Allows conditional usage

```text
loop: redo if [lt index count]
```

---

# Example

```text
module my_module

import
    SYSTEM

structure point
record
    x: flt32
    y: flt32
finish

procedure array_sum (arr: ref array of int64, sum: ref int64)
define
    index: int64
scheme
    index: load 0
    scheme loop
        loop: drop if [ge index [len arr]]
        sum: pass [add [val sum] [val arr index]]
        index: load [add index 1]
        loop: redo
    finish loop
finish

procedure array_max (arr: ref array of int64, max: ref int64)
define
    index: int64
    element: int64
scheme
    max: pass SYSTEM.MIN_INT64
    index: load 0

    scheme loop
        loop: drop if [ge index [len arr]]
        element: load [val arr index]

        scheme check
            check: drop if [ge max element]
            max: pass element
        finish check

        index: load [add index 1]
        loop: redo
    finish loop
finish

procedure string_freq (string: ref array of uint8, frequencies: ref array of int64)
define
    index: uint64
    char: uint8
scheme
    scheme check
        check: drop if [ne [len frequencies] 256]

        index: load 0
        scheme loop
            loop: drop if [ge index 256]
            frequencies[index]: pass 0
            index: load [add index 1]
            loop: redo
        finish loop

        index: load 0
        scheme loop
            loop: drop if [ge index [len string]]
            char: load [val string index]
            frequencies[char]: pass [add [val frequencies char] 1]
            index: load [add index 1]
            loop: redo
        finish loop
    finish check
finish

procedure point_add (a: ref point, b: ref point, result: ref point)
scheme
    result.x: pass [add [val a.x] [val b.x]]
    result.y: pass [add [val a.y] [val b.y]]
finish

procedure binary_search (arr: ref array of int64, value: int64, index: ref int64)
define
    left_index: int64
    right_index: int64
scheme
    left_index: load 0
    right_index: load [sub [len arr] 1]

    scheme loop
        index: pass [div [add left_index right_index] 2]

        scheme check
            scheme less_case
                less_case: drop if [gt value [val arr [val index]]]
                right_index: load [val index]
                check: drop
            finish less_case
            scheme right_case
                left_index: load [val index]
            finish right_case
        finish check

        loop: redo if [ne value [val arr [val index]]]
    finish loop
finish
```

---

# Outstanding Questions

The following areas are not yet fully specified:

* Null reference semantics.
* String type design.
* Explicit type aliases.
* Procedure reference invocation rules.
* Integer promotion rules.
* Implicit conversions.
* Bounds checking policy.
* Forward structure declarations.
* Circular structure references.
* Module visibility/export rules.
* Exact runtime representation of `ref array of T`.
