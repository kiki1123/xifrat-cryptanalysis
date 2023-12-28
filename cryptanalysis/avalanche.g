#tests : avalanche, RES, duptest, blktest, rnd_sqn;

avalanche:=function(x,runs) #variability of the output as the ith bit changes
    local l,i_ava,count,flipped,sum1,sum2,sum,resultado,vektor,resultaat,run,v,filepath1,filepath2,filepath3,res,change,list,n,i,j,k;
    
    if x=64 then
        k:=vector();
        filepath1:=Concatenation("avalanche_blk_count","_",String(runs),".g");
        filepath2:=Concatenation("avalanche_blk_change","_",String(runs),".g");
        filepath3:=Concatenation("avalanche_blk_res","_",String(runs),".g");

    else
        k:=f2();
        filepath1:=Concatenation("avalanche_dup_count","_",String(runs),".g");
        filepath2:=Concatenation("avalanche_dup_change","_",String(runs),".g");
        filepath3:=Concatenation("avalanche_dup_res","_",String(runs),".g");
    fi;


    PrintTo(filepath1,"");
    PrintTo(filepath2,"l:=");
    PrintTo(filepath3,"");

    res := List([1..runs],x->[]);
    
    for run in [1..runs] do
        
        if x=64 then
            v:=vector();
            resultado:=Flat(ToBit(Blk(k,v)));
            vektor:=Flat(ToBit(v));
        else
            v:=f2();
            resultado:=Flat(VectorToBit(Dup(k,v)));
            vektor:=Flat(VectorToBit(v));
        fi;

        for i_ava in [1..Length(vektor)] do
            flipped:=ShallowCopy(vektor);
            flipped[i_ava]:=1-flipped[i_ava];
                  
            if x=64 then
                resultaat:=Blk(k,BitToBlk(flipped));
                resultaat:=Flat(ToBit(resultaat));
            else
                resultaat:=Dup(k,BitToVector(DupCons(flipped)));
                resultaat:=Flat(VectorToBit(resultaat));
            fi;

            count:=0;
            change:=[];
                for j in [1..Length(resultado)] do
                    if resultado[j] <> resultaat[j] then
                        count:=count+1;
                        Add(change,j);
                    fi;
                od;
            res[run][i_ava] := change;

            AppendTo(filepath1,count," ");           
        od;
    AppendTo(filepath1,"\n");
    od;  
    
    AppendTo(filepath2,res);
    AppendTo(filepath2,";");

    l:=res;
    if x=64 then
        list:=List([1..64],x->List([1..64],x->0));
    else
        list:=List([1..768],x->List([1..768],x->0));
    fi;

    for i in [1..Length(l)] do
        for j in [1..Length(l[i])] do
            for k in [1..Length(l[i][j])] do
                n:=l[i][j][k];
                list[j][n]:=list[j][n]+1;
            od;
        od;
    od;
    AppendTo(filepath3,list);
end;

RES:=function(filein,fileout,x) #takes in change file
    local list,i,j,k,n,l;
    Reread(filein);

    if x=64 then
        list:=List([1..64],x->List([1..64],x->0));
    else
    list:=List([1..768],x->List([1..768],x->0));
    fi;

    for i in [1..Length(l)] do
        for j in [1..Length(l[i])] do
            for k in [1..Length(l[i][j])] do
                n:=l[i][j][k];
                list[j][n]:=list[j][n]+1;
            od;
        od;
    od;
    AppendTo(fileout,list);
end;

duptest:=function(trials,date,pc)
    local i,cc,c,k,kk,result,file_in,file_out,trial,n,letter;
  
    file_in:=Concatenation("input_dup","_",String(trials),"_",String(date),"_",String(pc),".g");
    file_out:=Concatenation("output_dup","_",String(trials),"_",String(date),"_",String(pc),".g");

    PrintTo(file_in,"");
    PrintTo(file_out,"");

    c:=f2();
    cc:=Flat(VectorToBit(c));

    for i in cc do
        AppendTo(file_in,i);
    od;
    AppendTo(file_in,"\n");

    for trial in [1..trials] do

        k:=f2();

        kk:=Flat(VectorToBit(k));
        result:= Flat(VectorToBit(Dup(c,k)));

        for i in kk do
            AppendTo(file_in,i);
        od;
            AppendTo(file_in,"\n");

        for i in result do 
        AppendTo(file_out,i);
        od;
        AppendTo(file_out,"\n");
    od;

    Print("Total time: ", StringTime(time),"\n");
end;

blktest:=function(trials,date,pc)
    local result,resultaat,resultado,trailk,kk,i,v,vv,file_in,file_out,trial,n,k,letter;

    k:=vector();
    kk:=Flat(ToBit(k));
    
    file_in:=Concatenation("/Users/kikasss/Desktop/REU/xifrat_simulations/blk/in_blk","_",String(trials),"_",String(date),"_",String(pc),".g");
    file_out:=Concatenation("/Users/kikasss/Desktop/REU/xifrat_simulations/blk/out_blk","_",String(trials),"_",String(date),"_",String(pc),".g");

    PrintTo(file_in,"");
    PrintTo(file_out,"");

    for i in kk do
        AppendTo(file_in,i);
        od;
    AppendTo(file_in,"\n");   

    for trial in [1..trials] do
        v:=vector();
        vv:=Flat(ToBit(v));
        result:=Blk(k,v);
        resultado:=Flat(ToBit(result));

        for i in vv do
            AppendTo(file_in,i);
        od;
            AppendTo(file_in,"\n");
        for i in resultado do
            AppendTo(file_out,i);
            od;
            AppendTo(file_out,"\n");
    od;

    Print("Total time: ", StringTime(time), "\n");
end;


rand_sqn:=function(run)
    local file_in, i_rand,o,i_rando,list;
    file_in:=Concatenation("/Users/kikasss/Desktop/REU/xifrat_simulations/dup/rand_sqn_100K",".g");
    PrintTo(file_in,"");

    for i_rand in [1..run] do
        o:=f2();
        list:=Flat(VectorToBit(o)); 

        for i_rando in list do
            AppendTo(file_in,i_rando);
        od;
        AppendTo(file_in,"\n");   
    od;
end;
