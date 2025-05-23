#@local checklens,n,permAll,permBig,permSml,x,y,moved,p,r,t,l
gap> START_TEST("perm.tst");

# Permutations come in two flavors in GAP, with two TNUMs: T_PERM2 for
# permutations of degree up to 2^16, and T_PERM4 for permutations of degree up
# to 2^32. Here is an example:
gap> TNUM_OBJ((1000,2^16)) = T_PERM2;
true
gap> x:=(1000,2^16+1); TNUM_OBJ(x) = T_PERM4;
(1000,65537)
true

# Note that permutations are not necessarily stored with minimized degree, so
# e.g. the transposition (1,2) can in principle be stored with either TNUM.
gap> TNUM_OBJ((1,2)) = T_PERM2;
true
gap> y:=(1,2)^x; TNUM_OBJ(x) = T_PERM4;
(1,2)
true

# test error handling parsing of permutations
gap> (1,2,0);
Error, Permutation: <expr> must be a positive small integer (not the integer 0\
)
gap> (1,2)(1,2);
Error, Permutation: cycles must be disjoint and duplicate-free
gap> (1,2,3,2);
Error, Permutation: cycles must be disjoint and duplicate-free
gap> (1,2^80);
Error, Permutation: <expr> must be a positive small integer (not a large posit\
ive integer)
#@if 8*GAPInfo.BytesPerVariable = 64
gap> (1,2^40);
Error, Permutation literal exceeds maximum permutation degree
#@fi

# The GAP kernel implements many functions in multiple variants, e.g. to
# compare permutations for equality, there are actually four functions in the
# kernel that deal with the various combinations of types of input arguments.
# Thus, our tests need to take this into account, too.
# #
# For this, we use the elements of Sym(3), once as T_PERM2 and once as T_PERM4.
gap> permSml := [ (), (2,3), (1,2), (1,2,3), (1,3,2), (1,3) ];
[ (), (2,3), (1,2), (1,2,3), (1,3,2), (1,3) ]
gap> n := Length(permSml);
6
gap> IsSet(permSml);
true
gap> permBig := List(permSml, g -> g^x);
[ (), (2,3), (1,2), (1,2,3), (1,3,2), (1,3) ]
gap> IsSet(permBig);
true
gap> permAll := Concatenation(permSml, permBig);;

#
# PrintPerm
#
gap> Print(permSml, "\n");
[ (), (2,3), (1,2), (1,2,3), (1,3,2), (1,3) ]
gap> Print(permSml * (5,99), "\n");
[ ( 5,99), ( 2, 3)( 5,99), ( 1, 2)( 5,99), ( 1, 2, 3)( 5,99), 
  ( 1, 3, 2)( 5,99), ( 1, 3)( 5,99) ]
gap> Print(permSml * (5,999), "\n");
[ (  5,999), (  2,  3)(  5,999), (  1,  2)(  5,999), (  1,  2,  3)(  5,999), 
  (  1,  3,  2)(  5,999), (  1,  3)(  5,999) ]
gap> Print(permSml * (5,9999), "\n");
[ (   5,9999), (   2,   3)(   5,9999), (   1,   2)(   5,9999), 
  (   1,   2,   3)(   5,9999), (   1,   3,   2)(   5,9999), 
  (   1,   3)(   5,9999) ]
gap> Print(permSml * (5,12345), "\n");
[ (    5,12345), (    2,    3)(    5,12345), (    1,    2)(    5,12345), 
  (    1,    2,    3)(    5,12345), (    1,    3,    2)(    5,12345), 
  (    1,    3)(    5,12345) ]

#
gap> Print(permBig, "\n");
[ (), (2,3), (1,2), (1,2,3), (1,3,2), (1,3) ]
gap> Print(permBig * (5,99), "\n");
[ ( 5,99), ( 2, 3)( 5,99), ( 1, 2)( 5,99), ( 1, 2, 3)( 5,99), 
  ( 1, 3, 2)( 5,99), ( 1, 3)( 5,99) ]
gap> Print(permBig * (5,999), "\n");
[ (  5,999), (  2,  3)(  5,999), (  1,  2)(  5,999), (  1,  2,  3)(  5,999), 
  (  1,  3,  2)(  5,999), (  1,  3)(  5,999) ]
gap> Print(permBig * (5,9999), "\n");
[ (   5,9999), (   2,   3)(   5,9999), (   1,   2)(   5,9999), 
  (   1,   2,   3)(   5,9999), (   1,   3,   2)(   5,9999), 
  (   1,   3)(   5,9999) ]
gap> Print(permBig * (5,99999), "\n");
[ (    5,99999), (    2,    3)(    5,99999), (    1,    2)(    5,99999), 
  (    1,    2,    3)(    5,99999), (    1,    3,    2)(    5,99999), 
  (    1,    3)(    5,99999) ]
gap> Print(permBig * (5,999999), "\n");
[ (    5,999999), (    2,    3)(    5,999999), (    1,    2)(    5,999999), 
  (    1,    2,    3)(    5,999999), (    1,    3,    2)(    5,999999), 
  (    1,    3)(    5,999999) ]

# Check String of large permutation
# Check length, beginning and end, as the string is too long to include in
# a test file
gap> p := String(PermList(Concatenation([2..2^20], [1])));;
gap> Length(p) = 7277505;
true
gap> p{[1..40]};
"(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,"
gap> p{[Length(p)-40..Length(p)]};
",1048572,1048573,1048574,1048575,1048576)"

#
# EqPerm
#
gap> ForAll([1..n], i -> ForAll([1..n], j-> (permSml[i] = permSml[j]) = (i = j)));
true
gap> ForAll([1..n], i -> ForAll([1..n], j-> (permSml[i] = permBig[j]) = (i = j)));
true
gap> ForAll([1..n], i -> ForAll([1..n], j-> (permBig[i] = permSml[j]) = (i = j)));
true
gap> ForAll([1..n], i -> ForAll([1..n], j-> (permBig[i] = permBig[j]) = (i = j)));
true

#
# LtPerm
#
gap> ForAll([1..n], i -> ForAll([1..n], j-> (permSml[i] < permSml[j]) = (i < j)));
true
gap> ForAll([1..n], i -> ForAll([1..n], j-> (permSml[i] < permBig[j]) = (i < j)));
true
gap> ForAll([1..n], i -> ForAll([1..n], j-> (permBig[i] < permSml[j]) = (i < j)));
true
gap> ForAll([1..n], i -> ForAll([1..n], j-> (permBig[i] < permBig[j]) = (i < j)));
true

#
# ProdPerm
#
gap> List(permSml,x->List(permSml,y->x*y));
[ [ (), (2,3), (1,2), (1,2,3), (1,3,2), (1,3) ], 
  [ (2,3), (), (1,2,3), (1,2), (1,3), (1,3,2) ], 
  [ (1,2), (1,3,2), (), (1,3), (2,3), (1,2,3) ], 
  [ (1,2,3), (1,3), (2,3), (1,3,2), (), (1,2) ], 
  [ (1,3,2), (1,2), (1,3), (), (1,2,3), (2,3) ], 
  [ (1,3), (1,2,3), (1,3,2), (2,3), (1,2), () ] ]
gap> List(permSml,x->List(permBig,y->x*y));
[ [ (), (2,3), (1,2), (1,2,3), (1,3,2), (1,3) ], 
  [ (2,3), (), (1,2,3), (1,2), (1,3), (1,3,2) ], 
  [ (1,2), (1,3,2), (), (1,3), (2,3), (1,2,3) ], 
  [ (1,2,3), (1,3), (2,3), (1,3,2), (), (1,2) ], 
  [ (1,3,2), (1,2), (1,3), (), (1,2,3), (2,3) ], 
  [ (1,3), (1,2,3), (1,3,2), (2,3), (1,2), () ] ]
gap> List(permBig,x->List(permSml,y->x*y));
[ [ (), (2,3), (1,2), (1,2,3), (1,3,2), (1,3) ], 
  [ (2,3), (), (1,2,3), (1,2), (1,3), (1,3,2) ], 
  [ (1,2), (1,3,2), (), (1,3), (2,3), (1,2,3) ], 
  [ (1,2,3), (1,3), (2,3), (1,3,2), (), (1,2) ], 
  [ (1,3,2), (1,2), (1,3), (), (1,2,3), (2,3) ], 
  [ (1,3), (1,2,3), (1,3,2), (2,3), (1,2), () ] ]
gap> List(permBig,x->List(permBig,y->x*y));
[ [ (), (2,3), (1,2), (1,2,3), (1,3,2), (1,3) ], 
  [ (2,3), (), (1,2,3), (1,2), (1,3), (1,3,2) ], 
  [ (1,2), (1,3,2), (), (1,3), (2,3), (1,2,3) ], 
  [ (1,2,3), (1,3), (2,3), (1,3,2), (), (1,2) ], 
  [ (1,3,2), (1,2), (1,3), (), (1,2,3), (2,3) ], 
  [ (1,3), (1,2,3), (1,3,2), (2,3), (1,2), () ] ]

#
# QuoPerm
#
gap> SetX(permAll, permAll, {x,y} -> (x/y)*y = x);
[ true ]
gap> SetX(permAll, permAll, {x,y} -> (x/y) = x * y^-1);
[ true ]

#
# LQuoPerm
#
gap> SetX(permAll, permAll, {x,y} -> x*LeftQuotient(x,y) = y);
[ true ]
gap> SetX(permAll, permAll, {x,y} -> LeftQuotient(x,y) = x^-1 * y);
[ true ]

#
# PowPermInt / InvPerm
#

#
gap> ForAll(permAll, x -> IsOne(x^0));
true
gap> ForAll(permAll, x -> IsOne(x^6));
true
gap> ForAll(permAll, x -> IsOne(x^-6));
true
gap> ForAll(permAll, x -> IsOne(x^(30^13)));
true
gap> ForAll(permAll, x -> IsOne(x^(-30^13)));
true
gap> ForAll([-5..5], i -> IsOne(()^i));
true

#
gap> ForAll(permAll, x -> x^-1 * x = ());
true
gap> ForAll(permAll, x -> x * x^-1 = ());
true

#
gap> ForAll(permAll, x -> x^1 = x);
true
gap> ForAll(permAll, x -> x^31 = x);
true
gap> ForAll(permAll, x -> x^-29 = x);
true
gap> ForAll(permAll, x -> x^(30^13+1) = x);
true
gap> ForAll(permAll, x -> x^(-30^13+1) = x);
true

#
gap> List(permAll, x -> x^2);
[ (), (), (), (1,3,2), (1,2,3), (), (), (), (), (1,3,2), (1,2,3), () ]
gap> List(permAll, x -> x^3);
[ (), (2,3), (1,2), (), (), (1,3), (), (2,3), (1,2), (), (), (1,3) ]
gap> List(permAll, x -> x^-3);
[ (), (2,3), (1,2), (), (), (1,3), (), (2,3), (1,2), (), (), (1,3) ]

#
# PowIntPerm
#
gap> (-1)^(1,2);
Error, PowIntPerm: <point> must be a positive integer (not the integer -1)
gap> (-2^100)^(1,2);
Error, no method found! For debugging hints type ?Recovery from NoMethodFound
Error, no 1st choice method found for `^' on 2 arguments
gap> 0^(1,2);
Error, PowIntPerm: <point> must be a positive integer (not the integer 0)
gap> n:=10^30;;
gap> ForAll(permAll, g -> n^g = n);
true
gap> List([1,2,3,4,1000],n->List(permSml, g->n^g));
[ [ 1, 1, 2, 2, 3, 3 ], [ 2, 3, 1, 3, 1, 2 ], [ 3, 2, 3, 1, 2, 1 ], 
  [ 4, 4, 4, 4, 4, 4 ], [ 1000, 1000, 1000, 1000, 1000, 1000 ] ]
gap> List([1,2,3,4,1000],n->List(permBig, g->n^g));
[ [ 1, 1, 2, 2, 3, 3 ], [ 2, 3, 1, 3, 1, 2 ], [ 3, 2, 3, 1, 2, 1 ], 
  [ 4, 4, 4, 4, 4, 4 ], [ 1000, 1000, 1000, 1000, 1000, 1000 ] ]

#
# QuoIntPerm
#
gap> (-1)/(1,2);
Error, QuoIntPerm: <point> must be a positive integer (not the integer -1)
gap> (-2^100)/(1,2);
Error, no method found! For debugging hints type ?Recovery from NoMethodFound
Error, no 1st choice method found for `*' on 2 arguments
gap> 0/(1,2);
Error, QuoIntPerm: <point> must be a positive integer (not the integer 0)
gap> n:=10^30;;
gap> ForAll(permAll, g -> n/g = n);
true
gap> 30000/(1,20000);  # test a perm with degree > PERM_INVERSE_THRESHOLD
30000
gap> List([1,2,3,4,1000],n->List(permSml, g->n/g));
[ [ 1, 1, 2, 3, 2, 3 ], [ 2, 3, 1, 1, 3, 2 ], [ 3, 2, 3, 2, 1, 1 ], 
  [ 4, 4, 4, 4, 4, 4 ], [ 1000, 1000, 1000, 1000, 1000, 1000 ] ]
gap> List([1,2,3,4,1000],n->List(permBig, g->n/g));
[ [ 1, 1, 2, 3, 2, 3 ], [ 2, 3, 1, 1, 3, 2 ], [ 3, 2, 3, 2, 1, 1 ], 
  [ 4, 4, 4, 4, 4, 4 ], [ 1000, 1000, 1000, 1000, 1000, 1000 ] ]

#
# PowPerm
#
gap> SetX(permAll, permAll, {x,y} -> y * x^y = x * y);
[ true ]

#
# CommPerm
#
gap> Comm(permSml[2], permSml[3]);
(1,3,2)
gap> Comm(permSml[2], permBig[3]);
(1,3,2)
gap> Comm(permBig[2], permSml[3]);
(1,3,2)
gap> Comm(permBig[2], permBig[3]);
(1,3,2)
gap> SetX(permAll, permAll, {a,b} -> Comm(a,b) = LeftQuotient((b*a), a*b));
[ true ]

# gap> SetX(permAll, permAll, {a,b} -> a * Comm(a,b) = a^b);
# [ true ]

#
# ListPerm
#
gap> p := ();
()
gap> ListPerm( p );
[  ]
gap> List([-1,0,1,5], n -> ListPerm( p, n ));
[ [  ], [  ], [ 1 ], [ 1, 2, 3, 4, 5 ] ]

#
gap> p := (1,100) / (1,100);
()
gap> ListPerm( p );
[  ]
gap> List([-1,0,1,5], n -> ListPerm( p, n ));
[ [  ], [  ], [ 1 ], [ 1, 2, 3, 4, 5 ] ]

#
gap> p := (1,2^17) / (1,2^17);
()
gap> ListPerm( p );
[  ]
gap> List([-1,0,1,5], n -> ListPerm( p, n ));
[ [  ], [  ], [ 1 ], [ 1, 2, 3, 4, 5 ] ]

#
gap> p := (1,2,3);
(1,2,3)
gap> ListPerm( p );
[ 2, 3, 1 ]
gap> List([-1,0,1,5], n -> ListPerm( p, n ));
[ [  ], [  ], [ 2 ], [ 2, 3, 1, 4, 5 ] ]

#
gap> p := (1,2,3,10000)*(1,10000);
(1,2,3)
gap> ListPerm( p );
[ 2, 3, 1 ]
gap> List([-1,0,1,5], n -> ListPerm( p, n ));
[ [  ], [  ], [ 2 ], [ 2, 3, 1, 4, 5 ] ]

#
gap> ListPerm( 1 );
Error, ListPerm: <perm> must be a permutation (not the integer 1)
gap> ListPerm( (1,2,3), "bla" );
Error, ListPerm: <n> must be a small integer (not a list (string))

#
# PermList
#
gap> PermList([1,2,3]) = ();
true
gap> PermList([1..3]) = ();
true
gap> () = PermList([1,2,3]);
true
gap> (1,2) = PermList([2,1,3]);
true
gap> PermList([2,1,3]) = (1,2);
true
gap> checklens := Concatenation([1..20], [2^15-10..2^15+10],
>                               [2^16-10..2^16+10], [2^17-10..2^17+10]);;
gap> ForAll(checklens, n -> PermList(Concatenation([1..n-1], [n+1,n])) =
>                           PermList(Concatenation([1..n-1],[n+1,n,n+2])));
true
gap> ForAll(checklens, n -> not(
>  PermList(Concatenation([1..n-1], [n+1,n,n+2,n+4,n+3])) =
>  PermList(Concatenation([1..n-1], [n+1,n+2,n,n+4,n+3]))));
true
gap> PermList([1..5]);
()
gap> PermList([5,4..1]);
(1,5)(2,4)

# PermList error handling
gap> PermList(1);
Error, PermList: <list> must be a small list (not the integer 1)

# PermList error handling for T_PERM2
gap> PermList([1,,3]);
fail
gap> PermList([1,fail,3]);
fail
gap> PermList([1,0,3]);
fail
gap> PermList([1,1,3]);
fail
gap> PermList([2..5]);
fail
gap> PermList([1,0..-4]);
fail
gap> PermList("abc");
fail
gap> PermList([true,false]); # argument is a blist
fail

# PermList error handling for T_PERM4
gap> PermList(Concatenation([1..70000],[70001,,70003]));
fail
gap> PermList(Concatenation([1..70000],[70001,fail,70003]));
fail
gap> PermList(Concatenation([1..70000],[70001,0,70003]));
fail
gap> PermList(Concatenation([1..70000],[70001,1,70003]));
fail

#
# SmallestMovedPoint, LargestMovedPoint, MovedPoints, NrMovedPoints
#
gap> moved := {p} -> [SmallestMovedPoint(p), LargestMovedPoint(p), MovedPoints(p), NrMovedPoints(p)];;
gap> moved((2,3));
[ 2, 3, [ 2, 3 ], 2 ]
gap> moved((2,70000));
[ 2, 70000, [ 2, 70000 ], 2 ]
gap> moved((70000, 70001));
[ 70000, 70001, [ 70000, 70001 ], 2 ]
gap> moved((1,2,3,4));
[ 1, 4, [ 1, 2, 3, 4 ], 4 ]
gap> moved(());
[ infinity, 0, [  ], 0 ]
gap> moved((1,2,3,4)^4);
[ infinity, 0, [  ], 0 ]
gap> moved([]);
[ infinity, 0, [  ], 0 ]
gap> moved([()]);
[ infinity, 0, [  ], 0 ]
gap> moved([(1,2),(5,6)]);
[ 1, 6, [ 1, 2, 5, 6 ], 4 ]
gap> moved(SymmetricGroup([5,7,9]));
[ 5, 9, [ 5, 7 .. 9 ], 3 ]
gap> moved(SymmetricGroup([5,7,9,70000]));
[ 5, 70000, [ 5, 7, 9, 70000 ], 4 ]
gap> moved(SymmetricGroup(1));
[ infinity, 0, [  ], 0 ]
gap> moved(Group((8,9,10),(13,15,19)));
[ 8, 19, [ 8, 9, 10, 13, 15, 19 ], 6 ]
gap> SMALLEST_MOVED_POINT_PERM(fail);
Error, SMALLEST_MOVED_POINT_PERM: <perm> must be a permutation (not the value \
'fail')
gap> LARGEST_MOVED_POINT_PERM(fail);
Error, LARGEST_MOVED_POINT_PERM: <perm> must be a permutation (not the value '\
fail')

#
# CycleLengthPermInt, CyclePermInt
#
gap> Cycles((),[]);
[  ]
gap> Cycles((),[1]);
[ [ 1 ] ]
gap> Cycles((1,2,3)(4,5)(6,70),[4..7]);
[ [ 4, 5 ], [ 6, 70 ], [ 7 ] ]
gap> CycleLengths((1,2,3)(4,5)(6,70),[4..7]);
[ 2, 2, 1 ]

#
gap> Cycles((1,2,3)(4,5)(6,70000),[4..7]);
[ [ 4, 5 ], [ 6, 70000 ], [ 7 ] ]
gap> CycleLengths((1,2,3)(4,5)(6,70000),[4..7]);
[ 2, 2, 1 ]

#
# CycleStructurePerm
#
gap> List(permSml, CycleStructurePerm);
[ [  ], [ 1 ], [ 1 ], [ , 1 ], [ , 1 ], [ 1 ] ]
gap> List(permBig, CycleStructurePerm);
[ [  ], [ 1 ], [ 1 ], [ , 1 ], [ , 1 ], [ 1 ] ]
gap> CycleStructurePerm( (1,2)(3,4,5)(10,12,13,14,15,16,17,18)(19,20) );
[ 2, 1,,,,, 1 ]

#
# OrderPerm
#
gap> List(permSml, Order);
[ 1, 2, 2, 3, 3, 2 ]
gap> List(permBig, Order);
[ 1, 2, 2, 3, 3, 2 ]
gap> Order( (1,2,3,4)(70,71,72) );
12
gap> Order( (1,2,3,4)(70000,71000,72000) );
12
gap> ORDER_PERM(fail);
Error, ORDER_PERM: <perm> must be a permutation (not the value 'fail')

#
# SignPerm
#
gap> List(permSml, SignPerm);
[ 1, -1, -1, 1, 1, -1 ]
gap> List(permBig, SignPerm);
[ 1, -1, -1, 1, 1, -1 ]
gap> SIGN_PERM(fail);
Error, SIGN_PERM: <perm> must be a permutation (not the value 'fail')

#
# SmallestGeneratorPerm
#
gap> SMALLEST_GENERATOR_PERM( 1 );
Error, SMALLEST_GENERATOR_PERM: <perm> must be a permutation (not the integer \
1)
gap> SmallestGeneratorPerm( (1,3,2) );
(1,2,3)
gap> SmallestGeneratorPerm( (1,2,3) );
(1,2,3)
gap> SmallestGeneratorPerm( (1,65537,2) );
(1,2,65537)
gap> SmallestGeneratorPerm( (1,2,65537) );
(1,2,65537)

#
# DistancePerms
#
gap> SetX(permSml, permSml, {x,y} -> DistancePerms(x,y) = NrMovedPoints(x/y));
[ true ]
gap> SetX(permSml, permBig, {x,y} -> DistancePerms(x,y) = NrMovedPoints(x/y));
[ true ]
gap> SetX(permBig, permSml, {x,y} -> DistancePerms(x,y) = NrMovedPoints(x/y));
[ true ]
gap> SetX(permBig, permBig, {x,y} -> DistancePerms(x,y) = NrMovedPoints(x/y));
[ true ]
gap> DistancePerms((1,2,3,4,5,6),(1,2,3));
4

#
# OnTuples for permutations
#
gap> ForAll(permSml, g -> OnTuples([1,2,3],g) = ListPerm(g, 3));
true
gap> ForAll(permBig, g -> OnTuples([1,2,3],g) = ListPerm(g, 3));
true
gap> ForAll(permSml, g -> OnTuples([1,2,3,70000],g) = Concatenation(ListPerm(g, 3),[70000]));
true
gap> ForAll(permBig, g -> OnTuples([1,2,3,70000],g) = Concatenation(ListPerm(g, 3),[70000]));
true
gap> OnTuples([1,2,3,70000,70001],(1,2,70000));
[ 2, 70000, 3, 1, 70001 ]

# action on tuples of permutations
gap> OnTuples([(1,2),(1,3)],(1,2));
[ (1,2), (2,3) ]
gap> OnTuples([(3,4),(1,2)],(1,2,70000));
[ (3,4), (2,70000) ]
gap> OnTuples([(1,2),(1,3)],(1,2,70000));
[ (2,70000), (2,3) ]

#
gap> OnTuples([,1],());
Error, OnTuples: <tup> must not contain holes
gap> OnTuples([,1],(70000,70001));
Error, OnTuples: <tup> must not contain holes

#
# OnSets for permutations
#
gap> ForAll(permSml, g -> OnSets([1,2,3],g) = [1,2,3]);
true
gap> ForAll(permBig, g -> OnSets([1,2,3],g) = [1,2,3]);
true
gap> ForAll(permSml, g -> OnSets([1,2,3,2^64],g) = [1,2,3,2^64]);
true
gap> ForAll(permBig, g -> OnSets([1,2,3,2^64],g) = [1,2,3,2^64]);
true
gap> OnSets([1,2,3,70000,70001],(1,2,70000));
[ 1, 2, 3, 70000, 70001 ]

# action on tuples of permutations
gap> OnSets([(1,2),(1,3)],(1,2));
[ (2,3), (1,2) ]
gap> OnSets([(3,4),(1,2)],(1,2,70000));
[ (3,4), (2,70000) ]
gap> OnSets([(1,2),(1,3)],(1,2,70000));
[ (2,3), (2,70000) ]

#
# OnTuples and OnSets for a non-internal list
#
gap> r:=NewCategory("ListTestObject",IsSmallList);;
gap> t:=NewType(ListsFamily, r and IsMutable and IsPositionalObjectRep);;
gap> InstallMethod(IsBound\[\],[r,IsPosInt],{l,i}->true);
gap> InstallMethod(\[\],[r,IsPosInt],{l,i}->i);
gap> InstallMethod(Length,[r],l->3); # hard code length
gap> l:=Objectify(t,[]);;
gap> OnTuples(l, (1,3));
[ 3, 2, 1 ]
gap> OnSets(l, (1,3));
[ 1, 2, 3 ]

#
# MappingPermListList
#
gap> MappingPermListList([],[]);
()
gap> MappingPermListList([1,1], [2,2]);
(1,2)
gap> MappingPermListList([1,2], [2,1]);
(1,2)
gap> MappingPermListList([1,2], [3,4]);
(1,3)(2,4)
gap> MappingPermListList([2,4,6], [1,2,3]);
(1,4,2)(3,6)
gap> MappingPermListList([1,1], [1,2]);
fail
gap> MappingPermListList([1,2], [1,1]);
fail
gap> MappingPermListList([1,1000], [1,1000]);
()
gap> MappingPermListList([1,1000], [1,1001]);
(1000,1001)
gap> MappingPermListList([1002,1000], [1,1001]);
(1,1000,1001,1002)
gap> MappingPermListList([1,1], [1000,1000]);
(1,1000)
gap> MappingPermListList([1,1], [1000,1001]);
fail
gap> MappingPermListList([1,2], [1000,1000]);
fail
gap> MappingPermListList((), []);
Error, MappingPermListList: <src> must be a dense list (not a permutation (sma\
ll))
gap> MappingPermListList([], ());
Error, MappingPermListList: <dst> must be a dense list (not a permutation (sma\
ll))
gap> MappingPermListList("cheese", "cake");
Error, MappingPermListList: <src> must have the same length as <dst> (lengths \
are 6 and 4)
gap> MappingPermListList("cheese", "cakeba");
Error, <src> must be a dense list of positive small integers
gap> MappingPermListList([1,2], [3,[]]);
Error, <dst> must be a dense list of positive small integers
gap> MappingPermListList([1,[]], [3,4]);
Error, <src> must be a dense list of positive small integers
gap> MappingPermListList([1,2], [3,0]);
Error, <dst> must be a dense list of positive small integers
gap> MappingPermListList([1,0], [3,4]);
Error, <src> must be a dense list of positive small integers
gap> MappingPermListList([1,-1], [3,4]);
Error, <src> must be a dense list of positive small integers
gap> MappingPermListList([1,2], [3,4]);
(1,3)(2,4)
gap> (1,128000) = ();
false
gap> (1,128000) * (129000, 129002);
(1,128000)(129000,129002)
gap> (1,128000) * (128000,128001);
(1,128001,128000)
gap> (128000,256000,512000) ^ (-1);
(128000,512000,256000)
gap> (1,2) * (128000,128001);
(1,2)(128000,128001)
gap> STOP_TEST("perm.tst");
