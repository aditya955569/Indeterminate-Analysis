function total_reaction=funtotal_reaction(reactions,start_reaction,count,end_reaction)
  total_reaction(1)=start_reaction;
 for i=1:1:count
    total_reaction(i+1)=reactions(2*i)+reactions(2*i+1);
 end
 total_reaction(count+2)=end_reaction;
end