% vim:ft=prolog
% Use: p1 --o input --o input (p1 Answer).

MODULE p1.

% Linear input relation: square

% square : int -> int -> int -> int -> int -> o.
% square Id Top Right Bottom Left.

% row : int -> list int -> list int -> list int -> o.
row L nil nil nil.
row L (T::Tops) (I::Ids) (B::Bottoms) :- square I T R B L, row R Tops Ids Bottoms.

% rows : list int -> list int -> list (list int) -> o.
rows Above nil nil.
rows Above (L::Lefts) (I::Ids) :- row L Above I Below, rows Below Lefts Ids.

% list_of_length : int -> list A -> o.
list_of_length 0 nil.
list_of_length N (_::Tail) :- N >= 0, M is N - 1, list_of_length M Tail.

% whole_thing : list (list int) -> o.
whole_thing Ids :- list_of_length 12 Top, list_of_length 12 Left, rows Top Left Ids.

% head, last : list A -> A -> o.
head (X::_) X.
last (X::nil) X.
last (_::Rest) X :- last Rest X.

% p1 : int -> o.
p1 Answer :-
  whole_thing Ids,
  write ok, nl,
  head Ids FirstRow, last Ids LastRow,
  head FirstRow A, last FirstRow B,
  head LastRow C, last LastRow D,
  Answer is A * B * C * D.
