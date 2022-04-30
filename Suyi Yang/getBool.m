function b=getBool(i,V,w,p)
    if(w(i)>V)
        b=0;
    else
        b=p(i);
    end
end