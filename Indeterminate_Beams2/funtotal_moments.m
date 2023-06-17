function total_moments=funtotal_moments(start,count,ending)
   total_moments(1)=start;
   for i=1+1:1:count+1
    total_moments(i)=0;
   end
   total_moments(count+2)=ending;
end