function equations=funequations(length_parts,count)
for i=1:1:count
    for j=1:1:count
        if j==i
            equations(i,j)=2*(1/length_parts(1,i))+2*(1/length_parts(1,i+1));
            if(j-1>=1)
                equations(i,j-1)=1/length_parts(1,i);
            end
        elseif j==i+1
            equations(i,j)=1/length_parts(1,i+1);
        else
            equations(i,j)=0;
        end
    end
end
end
