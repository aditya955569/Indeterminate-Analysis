function udl_matrix=funudlmatrix(udl,length_parts,count)
for i=1:1:count
    udl_matrix(i)=(udl*length_parts(i)*length_parts(i))/12-(udl*length_parts(i+1)*length_parts(i+1))/12;
end
end