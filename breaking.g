# Implementation of Xifrat's scheme in GAP using Loops Package
# Three mixing functions: BLK, VEC, and DUP constitute Xifrat's algorithm
# Functions: BlkIn, VecIn, DupIn, permutation, multiplication, prod, BlkOld, VecOld, DupOld, BLK, VEC, DUP, sigma, Xtraction, FindKey.
# Objects: Q, elements.

LoadPackage("loop");

# multiplicationtiplication table of the quasigroup employed in Xifrat
Q := QuasigroupByCayleyTable([
  [10,11,0,3,12,4,1,5,15,6,8,14,2,9,7,13],
  [15,8,9,7,2,13,5,1,10,14,11,6,12,0,3,4],
  [2,3,6,11,15,5,13,4,12,0,7,9,10,14,8,1],
  [0,5,10,4,14,3,8,11,9,2,1,12,6,15,13,7],
  [8,15,1,12,3,14,0,9,11,13,10,4,7,5,2,6],
  [6,4,2,5,9,11,7,3,14,10,13,15,0,12,1,8],
  [13,14,7,9,5,15,2,12,4,8,6,11,1,3,0,10],
  [12,7,14,8,10,1,4,13,2,9,3,0,15,6,11,5],
  [5,0,11,6,13,2,15,10,1,3,9,7,4,8,14,12],
  [14,13,12,1,0,8,3,7,6,15,4,10,9,2,5,11],
  [1,9,8,14,4,12,10,15,5,7,0,3,13,11,6,2],                                                                                                                                                                                                          
  [7,12,13,15,11,9,6,14,3,1,2,5,8,4,10,0],
  [9,1,15,13,6,7,11,8,0,12,5,2,14,10,4,3],
  [4,6,3,0,1,10,12,2,13,11,14,8,5,7,9,15],
  [11,10,5,2,7,6,9,0,8,4,15,13,3,1,12,14],
  [3,2,4,10,8,0,14,6,7,5,12,1,11,13,15,9]
  ]);

elements := Elements(Q);

#returns a random vector in Q^(16) with entries in the quasigroup
BlkIn := function() 
  return List([1..16], x->Random(elements));
end;

# returns a cyclic permutation of a list <A> by <x>-1 positions to the right
# inputs: A := BlkIn() and x := permutation shift
permutation := function(A,x) 
  local list, i;
  list := [];
  for i in [1..Length(A)] do
    list[i] := A[(i+x-2) mod Length(A) + 1];
  od;
  return list;
end;

# implementation of BLK function as presented in the scheme
# inputs: two BlkIn() vectors
BlkOld := function(A,B) 
  local i, C;
  C := [];
  for i in [1..16] do
    C[i] := (Product(permutation(A,i)))*(Product(permutation(B,i)))*(Product(permutation(A,i)))*(Product(permutation(B,i)));
  od;
  return C;
end;

# implementation of BLK function exploiting the generalized restricted-commutativity
# inputs: two BlkIn() vectors
BLK := function(A,B) 
    local X;
    X := List([1..16],i->A[i]*B[i]*A[i]*B[i]);
    return List([1..16],i->Product(permutation(X,i)));
end;

# returns a random set of 6 random BlkIn() vectors, the exact inputs of VEC function
VecIn := function()  
	return List([1..6], x->BlkIn());
end;

# runs BLK function on the inputs of VEC
# input: VecIn()
multiplication := function(A) 
  local a, i;
  a := A[1];
  for i in [2..Length(A)] do
    a := BLK(a,A[i]);
  od;
  return a;
end;

# implementation of VEC function as presented in the scheme
# inputs: two VecIn() vectors
VecOld := function(A,B) 
  local i, j, C, X, M, V; 
  C := [];
  X := [];
  for i in [1..Length(A)] do
    M := multiplication(permutation(A,i));
    V := multiplication(permutation(B,i));
    X[i] := [M,V,M,V];
    C[i] := (multiplication(X[i]));
  od;
  return C;
end;

# implementation of VEC function exploiting the generalized restricted-commutativity
# inputs: two VecIn() vectors
VEC := function(A,B) 
    local X;
    X := List([1..6], i->multiplication([A[i],B[i],A[i],B[i]]));
    return List([1..6], i->multiplication(permutation(X,i)));
end;

# runs VEC function on the inputs of DUP function, DupIn()
# input: DupIn() vector
prod := function(A) 
  local a, i;
  a := A[1];
  if Length(A) < 2 then
    return a;
  else
    for i in [2..Length(A)] do
      a := VEC(a,A[i]);
    od;
    return a;
  fi;
end;

# runs VEC function yielding the exact inputs needed for DUP function
DupIn := function()  
    return List([1..2], x->VecIn());
end;

# implementation of DUP function as presented in the scheme
# inputs: A:=DupIn() and B:=DupIn()
DupOld := function(A,B) 
  local i, X, C, M, V;
  X := [];
  C := [];
  for i in [1..Length(A)] do
    M := prod(permutation(A,i));
    V := prod(permutation(B,i));
    X[i] := [M,V,M,V];
    C[i] := prod(X[i]);  
  od;
  return C;
end;

# implementation of DUP function exploiting the generalized restricted-commutativity
# inputs: two DupIn() vectors
DUP := function(A,B) 
    local X;
    X := List([1..2], i->prod([A[i],B[i],A[i],B[i]]));
    return List([1..2],i ->prod(permutation(X,i)));
end;

# function exploiting generalized restricted-commutativity to simplify BLK, VEC, and DUP functions
# input: either a BlkIn(), VecIn(), or a DupIn() vector
sigma := function(X)
  local list, i, j;
  list := [];
  for i in [1..Length(X)]do
    if not IsList(X[i]) then
      list[i] := Product(permutation(X,i));
    else
      for j in [1..Length(X[i])] do
        if not IsList(X[i][j]) then
          list[i] := multiplication(permutation(X,i));
        else
          list[i] := prod(permutation(X,i));
        fi;
      od;
    fi;
  od;
  return list;
end;

#
# inputs: either BlkIn(), VecIn(), or DupIn() vectors
Xtraction := function(A,B) 
  local i, C, X;
  if Length(A) = 16 then
    C := BLK(A,B);
    X := sigma(C);
    for i in [1..14] do # at 15, the cycle reinitializes
      X := sigma(X);
    od;
  fi;

  if Length(A) = 6 then
    C := VEC(A,B);
    X := sigma(C);
    for i in [1..238] do # at 238, the cycle reinitializes
      X := sigma(X);
    od;
  fi;

  if Length(A) = 2 then
    C := DUP(A,B);
    X := sigma(C);
    for i in [1..238] do # at 238, the cycle reinitializes
      X := sigma(X);
    od;
  fi;
# Verification
#  if c = C(x) then
#    Print(true);
#  else
#    Print(false);
#  fi;
  return X;
end;

# function returns unknown k from c and p1. p1=DUP(c,k)
# run "time;" afterwards to get the duration in milliseconds for the key recovery
FindKey := function(p1,c)
    local i, k;
    k := p1;
    for i in [1..479] do 
            k := DUP(c,k);
        od;
    return k; 
end;
