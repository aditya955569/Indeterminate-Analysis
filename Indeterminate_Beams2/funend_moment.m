function end_moment=funend_moment(udl ,length_parts,theta_want,count)
    end_moment(1)=(-udl*length_parts(1)*length_parts(1))/12+(2*theta_want(1))/length_parts(1);
    end_moment(2)=(udl*length_parts(2)*length_parts(2))/12+(2*theta_want(1))/length_parts(2)+theta_want(2)/length_parts(2);
   for i=3:2:2*count
    p=(i+1)/2;
    end_moment(i)=(-udl*length_parts(p)*length_parts(p))/12+2*theta_want(p)/length_parts(p)+theta_want(p-1)/length_parts(p);
    end_moment(i+1)=(udl*length_parts(p+1)*length_parts(p+1))/12+2*theta_want(p)/length_parts(p+1)+theta_want(p+1)/length_parts(p+1);
   end
end