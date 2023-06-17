Length=Book3.Length;
UDL=Book3.UDL;
Count=Book3.Count;
Points=Book3.Points;
length = Length(1);
udl = UDL(1);
count = Count(1);
pos = [];
pos = [pos 0];
for i=1:1:count
    pos = [pos Points(i)];
end
pos = [pos length];
length_parts=[];
for i=2:1:count+2
    length_parts(i-1)=pos(i)-pos(i-1); %#ok<*SAGROW>
end
equations=[];

equations=funequations(length_parts,count);

udl_matrix=[];

udl_matrix=funudlmatrix(udl,length_parts,count);

udl_matrix=udl_matrix';
equations_op=equations^-1;
theta_want=equations_op*udl_matrix;
theta_want(count+1)= 0;
theta_want
start=(udl*length_parts(1)*length_parts(1))/12+theta_want(1)/length_parts(1);
end_moment=[]; %#ok<NASGU>

end_moment=funend_moment(udl ,length_parts,theta_want,count);
ending=(-udl*length_parts(count+1)*length_parts(count+1))/12+theta_want(count)/length_parts(count+1);
 end_moment(2*count+1)=ending;

end_moment
start_reaction=(start+end_moment(1)+(udl*length_parts(1)*length_parts(1))/2)/length_parts(1)

reactions=[];

reactions=funreactions(start_reaction,end_moment,udl,length_parts,count);

reactions
end_reaction=reactions(2*count+1);
total_reaction=[];

total_reaction=funtotal_reaction(reactions,start_reaction,count,end_reaction);

total_reaction
total_moments=[];
total_moments=funtotal_moments(start,count,ending);

total_moments
vartotal_reaction=0;
fplot(@(x) 0,[0 length], '--or');
hold on;
for i=1:1:count+1
     vartotal_reaction=vartotal_reaction+total_reaction(i);
     
     fplot(@(x) vartotal_reaction-udl*x,[pos(i) pos(i+1)],LineWidth=2);
     hold on;
end
hold off;
title('Shear Force Diagram');
ylabel('Shear Force '); 
xlabel('0 < x < length') ;