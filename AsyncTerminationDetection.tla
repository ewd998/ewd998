safdhsahu


---------------------- MODULE AsyncTerminationDetection ---------------------
\* * TLA+ is an expressive language and we usually define operators on-the-fly.
 \* * That said, the TLA+ reference guide "Specifying Systems" (download from:
 \* * https://lamport.azurewebsites.net/tla/book.html) defines a handful of
 \* * standard modules.  Additionally, a community-driven repository has been
 \* * collecting more modules (http://modules.tlapl.us). In our spec, we are
 \* * going to need operators for natural numbers.
EXTENDS Naturals, TLC

Foo ==
    TLCGet("level") < 10

\* * A constant is a parameter of a specification. In other words, it is a
 \* * "variable" that cannot change throughout a behavior, i.e., a sequence
 \* * of states. Below, we declares N to be a constant of this spec.
 \* * We don't know what value N has or even what its type is; TLA+ is untyped and
 \* * everything is a set. In fact, even 23 and "frob" are sets and 23="frob" is 
 \* * syntactically correct.  However, we don't know what elements are in the sets 
 \* * 23 and "frob" (nor do we care). The value of 23="frob" is undefined, and TLA+
 \* * users call this a "silly expression".
CONSTANT N

\* * We should declare what we assume about the parameters of a spec--the constants.
 \* * In this spec, we assume constant N to be a (positive) natural number, by
 \* * stating that N is in the set of Nat (defined in Naturals.tla) without 0 (zero).
 \* * Note that the TLC model-checker, which we will meet later, checks assumptions
 \* * upon startup.
ASSUME NIsPosNat == N \in Nat \ {0}

Node == 0 .. N-1

VARIABLE active, network, terminationDetected
vars == <<active, network, terminationDetected>>

terminated ==
    \A n \in Node: ~active[n] /\ network[n] = 0

TypeOK ==
    /\ active \in [ Node -> BOOLEAN ]
    /\ network \in [ Node -> Nat ]
    /\ terminationDetected \in BOOLEAN 

Init ==
    /\ active \in [ Node -> BOOLEAN ]
    /\ network \in [ Node -> 0..3 ]
    /\ terminationDetected \in {FALSE, terminated}

\* wakeup
RecvMsg(rcv) ==
    /\ network[rcv] > 0
    /\ network' = [ m \in Node |-> IF rcv = m THEN network[m] - 1 ELSE network[m] ]
    /\ active' = [ m \in Node |-> IF rcv = m THEN TRUE ELSE active[m] ]
    /\ UNCHANGED terminationDetected

Terminate(n) ==
    /\ active' = [ m \in Node |-> IF n = m THEN FALSE ELSE active[m] ]
    /\ UNCHANGED network
    /\ \/ terminationDetected' = terminated'
       \/ UNCHANGED terminationDetected

SendMsg(snd, rcv) ==
    /\ active[snd] = TRUE
    /\ network' = [ network EXCEPT ![rcv] = @ + 1 ]
    /\ UNCHANGED <<active, terminationDetected>>

Next ==
    \E n,m \in Node:
        \/ Terminate(n)
        \/ RecvMsg(n)
        \/ SendMsg(n,m)

Spec ==
    Init /\ [][Next]_vars

THEOREM Spec => []TypeOK

Safe ==
    \* /\ IF terminationDetected THEN terminated ELSE TRUE
    (terminationDetected => terminated)

THEOREM Spec => Safe

Live ==
    \* [](terminated => <>terminationDetected)
    terminated ~> terminationDetected

THEOREM Spec => Live

---------

Constraint ==
    \A n \in Node: network[n] < 3

=============================================================================
\* Modification History
\* Created Sun Jan 10 15:19:20 CET 2021 by Stephan Merz @muenchnerkindl