duptest:=function(trials, date) #generates dup test vectors for NIST randomness and collision tests
    local i,cc,c,k,kk,result,file_in,file_out,trial,n,letter;
  
    file_in:=Concatenation("input_dup","_",String(trials),"_",String(date)".g");
    file_out:=Concatenation("output_dup","_",String(trials),"_",String(date)".g");

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

blktest:=function(trials, date) #generates blk test vectors for NIST randomness and collision tests
    local result,resultaat,resultado,trailk,kk,i,v,vv,file_in,file_out,trial,n,k,letter;

    k:=vector();
    kk:=Flat(ToBit(k));
    
    file_in:=Concatenation("input_blk","_",String(trials),"_",String(date)".g");
    file_out:=Concatenation("output_blk","_",String(trials),"_",String(date)".g");

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


rand_sqn:=function(trials) #generates random test vectors for NIST randomness and and collision tests
    local file_in, i_rand,o,i_rando,list;
    file_in:=Concatenation("rand_sqn",".g");
    PrintTo(file_in,"");

    for i_rand in [1..trials] do
        o:=f2();
        list:=Flat(VectorToBit(o)); 

        for i_rando in list do
            AppendTo(file_in,i_rando);
        od;
        AppendTo(file_in,"\n");   
    od;
end;
