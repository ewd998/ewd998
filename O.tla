Run `tlapm O.tla` on the terminal to verify the 
theorems below with TLAPS.

---- MODULE O ----

CONSTANT O(_)

\* THEOREM T1 == O(1) /\ O(2) <=> \E i \in {1,2}: O(i)  OBVIOUS
THEOREM T2 == O(1) /\ O(2) <=> \A i \in {1,2}: O(i)  OBVIOUS
THEOREM T3 == O(1) \/ O(2) <=> \E i \in {1,2}: O(i)  OBVIOUS
\* THEOREM T4 == O(1) \/ O(2) <=> \A i \in {1,2}: O(i)  OBVIOUS


------------------
\* Implication

CONSTANT
    P, \* It's raining
    Q  \* The street is wet (street is not in a tunnel!)

\* If it rains (P), the street is wet (Q)
THEOREM TRUE => TRUE <=> TRUE  OBVIOUS
\* It cannot be that it rains, but the street is dry
THEOREM TRUE => FALSE <=> FALSE  OBVIOUS
\* The street might be wet, even without rain (somebody spilled some water)
THEOREM FALSE => TRUE <=> TRUE  OBVIOUS
\* No rain and a dry street
THEOREM FALSE => FALSE <=> TRUE  OBVIOUS

\* Contraposition (Street not wet implies no rain).
\* https://en.wikipedia.org/wiki/Contraposition
THEOREM P => Q <=> ~Q => ~P  OBVIOUS
\* Or-and-if.
THEOREM P => Q <=> (~P) \/ Q  OBVIOUS
\* Negated conditionals.
THEOREM ~(P => Q) <=> P /\ (~Q)  OBVIOUS 

------------------
\* Action operators
THEOREM ASSUME NEW ACTION A, NEW VARIABLE v 
PROVE [A]_v <=> A \/ v' = v  OBVIOUS 

\* ExpandENABLED requires TLAPS version greater than 1.4
\* ENABLED A \/ v=v'  is a tautology.
INSTANCE TLAPS

THEOREM ASSUME NEW VARIABLE v
PROVE (ENABLED [FALSE]_v) (*BY ExpandENABLED*)

THEOREM ASSUME NEW VARIABLE v
PROVE (ENABLED [TRUE]_v) (*BY ExpandENABLED*)

THEOREM ASSUME NEW VARIABLE v
PROVE (ENABLED [FALSE]_TRUE) (*BY ExpandENABLED*)

THEOREM ASSUME NEW VARIABLE v
PROVE (ENABLED [TRUE]_TRUE) (*BY ExpandENABLED*)

====
