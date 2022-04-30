function m=getM(i,V,w,p)
    if((i<1)||(V<0))
        m=0;
    else
        k=getBool(i,V,w,p);%判断是否装得下
        m=max(getM(i-1,V-w(i),w,p)+k,getM(i-1,V,w,p));%取或者不取
    end
end