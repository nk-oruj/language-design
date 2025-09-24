```ebnf

(* module *)

module              := __module, __NAME_MODULE, moduleElements, __finish, __NAME_MODULE, __eof
moduleElements      := { procedure }

(* procedure *)

procedure           := __procedure, __NAME_PROCEDURE, recordDeclare, scheme, __finish

(* record *)

recordDeclare       := __record, { recordDeclareRow }
recordDeclareRow    := __NAME_VARIABLE, __colon, [ prepos ], type

recordAssign        := __record, { recordAssignRow }
recordAssignRow     := __NAME_VARIABLE, __colon, prepos, __NAME_VARIABLE

(* scheme *)

scheme              := __scheme, schemeElements
schemeElements      := { assignment | switch | call }

(* statements *)

assignment          := __assign, __NAME_VARIABLE, __with, expression

switch              := __switch, __NAME_FRAME, switchElements, __finish, __NAME_FRAME
switchElements      := { assignment | switch | call | lift | drop }

lift                := __lift, __NAME_FRAME, [ __if, condition ]
drop                := __drop, __NAME_FRAME, [ __if, condition ]

call                := __call, reference, recordAssign, __finish

(* expression *)


condition :=
expression :=


(* elements *)

prepos              := __gets | __sets
type                := __integer | __float
reference           := [ __NAME_MODULE,  __period], __NAME_PROCEDURE

(* context *)

__NAME_MODULE       := __name
__NAME_PROCEDURE    := __name
__NAME_VARIABLE     := __name
__NAME_FRAME        := __name

(* symbols *)

__eof               := "\0"
__name              := ( "A"..."Z" | "a...z" ) { "A"..."Z" | "a...z" }
__integer           := "1"..."9", { "0"..."9" }
__float             := "1"..."9", { "0"..."9" } [ ".", { "0"..."9" }, "1"..."9" ]
__module            := "module"
__finish            := "finish"
__procedure         := "procedure"
__record            := "record"
__colon             := ":"
__gets              := "gets"
__sets              := "sets"
__scheme            := "scheme"
__assign            := "assign"
__with              := "with"
__switch            := "switch"
__lift              := "lift"
__if                := "if"
__drop              := "drop"
__call              := "call"
__type_integer      := "integer"
__type_float        := "float"     
__period            := "."

```
