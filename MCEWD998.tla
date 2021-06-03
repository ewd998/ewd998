------------------------------- MODULE MCEWD998 -------------------------------
EXTENDS EWD998

(***************************************************************************)
(* Bound the otherwise infinite state space that TLC has to check.         *)
(***************************************************************************)
StateConstraint ==
  /\ \A i \in Node : counter[i] < 3 /\ pending[i] < 3
  /\ token.q < 3

=============================================================================