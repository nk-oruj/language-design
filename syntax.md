```ebnf

(* module *)

module                  := __module, __NAME_SET_MODULE, moduleElements, __finish, __NAME_SET_MODULE, __eof;
moduleElements          := { moduleElements };
moduleElement           := procedure;

(* procedure *)

procedure               := __procedure, __NAME_SET_PROCEDURE, [ record ], scheme, __finish;

(* record *)

record                  := __record, recordElements;
recordElements          := { recordElement };
recordElement           := __NAME_SET_VARIABLE, [ prepos ], type;

(* scheme *)

scheme                  := __scheme, schemeElements;
schemeElements          := { schemeElement };
schemeElement           := load | call | frame;

(* statements *)

load                    := __load, __NAME_GET_VARIABLE, __with, expression;

call                    := __call, reference, [ recordLoad, __finish ];
reference               := __NAME_GET_PROCEDURE, [ __of, __NAME_GET_MODULE ];
recordLoad              := __record, recordLoadElements;
recordLoadElements      := { recordLoadElement };
recordLoadElement       := __NAME_GET_PARAMETER, prepos, __NAME_GET_VARIABLE;

frame                   := __scheme, __NAME_SET_FRAME, frameElements, __finish, __NAME_SET_FRAME;
frameElements           := { frameElement };
frameElement            := schemeElement | lift | drop;

lift                    := __lift, __NAME_GET_FRAME, [ __if, condition ];
drop                    := __drop, __NAME_GET_FRAME, [ __if, condition ];

(* expression *)

expression              := __lparen, expression_content, _rparen;
expression_content      := __NAME_GET_VARIABLE | literal | operation;

operation               := operator, expression, expression;
operator                := __or | __xor | __and | __not |
                           __add | __sub | __mul | __div |
                           __shr | __shl |
                           __eq | __ne | __ge | __gt | __le | lt;

(* elements *)

prepos                  := __gets | __sets;
literal                 := __integer | __float;
type                    := __lbracket, __NAME_GET_TYPE, __rbracket;


(* context *)

__NAME_SET_MODULE       := __name;
__NAME_GET_MODULE       := __name;

__NAME_SET_PROCEDURE    := __name;
__NAME_GET_PROCEDURE    := __name;

__NAME_SET_VARIABLE     := __name;
__NAME_GET_VARIABLE     := __name;

__NAME_GET_PARAMETER    := __name;
__NAME_GET_TYPE         := __name;

__NAME_SET_FRAME        := __name;
__NAME_GET_FRAME        := __name;

(* symbols *)

__invalid               := "";
__eof                   := "\0";

__lparen                := "(";
__rparen                := ")";
__lbracket              := "[";
__rbracket              := "]";

__name                  := ( "A"..."Z" | "a...z" ) { "A"..."Z" | "a...z" };
__integer               := "0" | "1"..."9", { "0"..."9" };
__float                 := ( "0" | "1"..."9", { "0"..."9" } ) [ ".", ("0" | { "0"..."9" }, "1"..."9" ) ];

__procedure             := "procedure";
__module                := "module";
__record                := "record";
__scheme                := "scheme";
__finish                := "finish";
__gets                  := "gets";
__sets                  := "sets";
__load                  := "load";
__with                  := "with";
__call                  := "call";
__lift                  := "lift";
__drop                  := "drop";
__add                   := "add";
__sub                   := "sub";
__mul                   := "mul";
__div                   := "div";
__shr                   := "shr";
__shl                   := "shl";
__eq                    := "eq";
__ne                    := "ne";
__ge                    := "ge";
__gt                    := "gt";
__le                    := "le";
__lt                    := "lt";
__or                    := "or";
__xor                   := "xor";
__and                   := "and";
__not                   := "not";
__if                    := "if";
__of                    := "of";

```
