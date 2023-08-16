# Implementation of Xifrat's scheme in GAP using Loops Package
# Three mixing functions BLK, VEC, and DUP constitute Xifrat's algorithm
# Functions: BlkIn,permutation, multiplication, Blk, Vec, Dup, VecIn, DupIn, prod, BitList, BitToBlk, Xtraction.
# Objects: Q.

LoadPackage("loop");

# multiplicationtiplication table of the quasigroup utilized in Xifrat
Q:= QuasigroupByCayleyTable([
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

elements:=Elements(Q);

#returns a random vector in Q^(16) with entries in the quasigroup
BlkIn := function() 
  return List([1..16],x->Random(elements));
end;

# returns a cyclic permutation of a list <A> by <x>-1 positions to the right
# inputs: BlkIn() and permutation shift
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
BlkOld:=function(A,B) 
  local i, C;
  C := [];
  for i in [1..16] do
    C[i]:=(Product(permutation(A,i)))*(Product(permutation(B,i)))*(Product(permutation(A,i)))*(Product(permutation(B,i)));
  od;
  return C;
end;

# implementation of BLK function exploiting the generalized restricted-commutativity
# inputs: two BlkIn() vectors
BLK := function(A,B) 
    local x;
    x:=List([1..16],i->a[i]*b[i]*a[i]*b[i]);
    return List([1..16],i->Product(permutation(x,i)));
end;

# returns a random set of 6 random BlkIns, the exact inputs of VEC function
VecIn:=function()  
	return List([1..6],x->BlkIn());
end;

# runs BLK function on the inputs of VEC
# input: VecIn()
multiplication := function(A) 
  local a,i;
  a:=A[1];
  for i in [2..Length(A)] do
    a := Blk(a,A[i]);
  od;
  return a;
end;

# inputs: A:=VecIn() and B:=VecIn()
VecOld:= function(A,B) 
  local i,j,C,X,M,V; 
  C := [];
  X := [];
  for i in [1..Length(A)] do
    M:=multiplication(permutation(A,i));
    V:=multiplication(permutation(B,i));
    X[i]:= [M,V,M,V];
    C[i]:= (multiplication(X[i]));
  od;
  return C;
end;

# inputs: A:=VecIn() and B:=VecIn()
VEC := function(a,b) 
    local x;
    x:=List([1..6],i->multiplication([a[i],b[i],a[i],b[i]]));
    return List([1..6],i->multiplication(permutation(x,i)));
end;

#runs VEC function on the inputs of DUP
# input: A=:DupIn() 
prod := function(A) 
  local a, i;
  a:=A[1];
  if Length(A) < 2 then
    return a;
  else
    for i in [2..Length(A)] do
      a := VEC(a,A[i]);
    od;
    return a;
  fi;
end;

# runs Vec function yielding the exact inputs needed for DUP function, C=(A0,A1)
DupIn:=function()  
    return List([1..2],x->VecIn());
end;

# inputs: A:=DupIn() and B:=DupIn()
DupOld:=function(A,B) 
  local i,X,C,M,V;
  X:=[];
  C:=[];
  for i in [1..Length(A)] do
    M:=prod(permutation(A,i));
    V:=prod(permutation(B,i));
    X[i]:= [M,V,M,V];
    C[i]:= prod(X[i]);  
  od;
  return C;
end;

DUP := function(a,b) #A:=DupIn() and B:=DupIn() as inputs
    local x;
    x:=List([1..2],i->prod([a[i],b[i],a[i],b[i]]));
    return List([1..2],i->prod(permutation(x,i)));
end;

sigma:=function(x)
  local list,i,j;
  list:=[];
  for i in [1..Length(x)]do
    if not IsList(x[i]) then
      list[i]:=Product(permutation(x,i));
    else
      for j in [1..Length(x[i])] do
        if not IsList(x[i][j]) then
          list[i]:=multiplication(permutation(x,i));
        else
          list[i]:=prod(permutation(x,i));
        fi;
      od;
    fi;
  od;
  return list;
end;

#a,b from Blk, Vec, or Dup
Xtraction:=function(A,B) 
  local i,c,x;
  if Length(A)=16 then
    C:= BLK(A,B);
    x:=sigma(C);
    for i in [1..14] do # at 15, the cycle reinitializes
      x:=sigma(x);
    od;
  fi;

  if Length(A)=6 then
    C:=VEC(A,B);
    x:=sigma(C);
    for i in [1..238] do # at 238, the cycle reinitializes
      x:=sigma(x);
    od;
  fi;

  if Length(A)=2 then
    C:=DUP(a,b);
    x:=sigma(C);
    for i in [1..238] do # at 238, the cycle reinitializes
      x:=sigma(x);
    od;
  fi;
  #Verification

#  if c=C(x) then
#    Print(true);
#  else
#    Print(false);
#  fi;
  return x;
end;

# function returns unknown k from c and p1. p1=Dup(c,k)
FindKey :=function(p1,c)
    local i,k;
    k:=p1;
    for i in [1..479] do 
            k:=DUP(c,k);
        od;
    return k; 
end;