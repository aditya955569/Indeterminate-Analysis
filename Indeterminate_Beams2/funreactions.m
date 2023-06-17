function reactions=funreactions(start_reaction,end_moment,udl,length_parts,count)
reactions(1)=start_reaction;
for i=2:2:2*count
    p=i/2;
    reactions(i)=udl*length_parts(p)-reactions(i-1);
    reactions(i+1)=(end_moment(2*p)+end_moment(2*p+1)+(udl*length_parts(p+1)*length_parts(p+1))/2)/length_parts(p+1);
end

end