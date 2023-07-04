length=input("length of the beam ");
count_supports=input("input the number of supports ");
position_supports=[];
position_supports=[position_supports 0];
for i=1:1:count_supports
    position_supports(1,i+1)=input("input the position of the support ");
end
position_supports=[position_supports length];
udl=[];
for i=1:1:count_supports+1
    udl(1,i)=input("Input the value of the udl ");    
end

count_load=input("input the number of point loads ");
position_loads=[];
for i=1:1:count_load
    position_loads(1,i)=input("input the position of the load ");
end

value_load=[];
for i=1:1:count_load
    value_load(1,i)=input("input the value of the load ");
end
equations=[];
for i=1:1:count_supports
    for j=1:1:count_supports
        if(i==j)
            equations(i,j)=2*(2/(position_supports(i+1)-position_supports(i))+2/(position_supports(i+2)-position_supports(i+1)));
            if(j~=1)
                equations(i,j-1)=2*(1/(position_supports(i+1)-position_supports(i)));
            end
        elseif(j==i+1)
                    equations(i,j)=2*(1/(position_supports(i+2)-position_supports(i+1)));
        else
            equations(i,j)=0;
        end
    end
end
equations
udl_matrix=[];
for i=1:1:count_supports
    udl_matrix(1,i)=(udl(1,i+1)*(position_supports(i+2)-position_supports(i+1))^2)/12-(udl(1,i)*(position_supports(i+1)-position_supports(i))^2)/12;
end
udl_matrix
for i=1:1:count_supports
    for j=1:1:count_load
        if position_loads(j)<position_supports(i+1)&&position_loads(j)>position_supports(i)
            a=position_loads(j)-position_supports(i);
            b=-position_loads(j)+position_supports(i+1);
            udl_matrix(1,i)=udl_matrix(1,i)-(value_load(j)*(a^2)*b)/((position_supports(i+1)-position_supports(i))^2);
        elseif position_loads(j)>position_supports(i+1)&&position_loads(j)<position_supports(i+2)
            a=position_loads(j)-position_supports(i+1);
            b=position_supports(i+2)-position_loads(j);
            udl_matrix(1,i)=udl_matrix(1,i)+(value_load(j)*(b^2)*a)/((position_supports(i+2)-position_supports(i+1))^2);
        end
    end
end
udl_matrix=udl_matrix'
equations=equations^-1;
equations
theta_want=equations*udl_matrix;
theta_want=theta_want'
all_theta=[];
all_theta(1)=0;
fem=[]
for i=2:1:count_supports+1
    all_theta(i)=theta_want(i-1);
end
all_theta(count_supports+2)=0;
for i=1:1:count_supports+1
    fem(1,i)=-(udl(1,i)*(position_supports(i+1)-position_supports(i))^2)/12;
    for j=1:1:count_load
        if position_loads(j)<position_supports(i+1)&&position_loads(j)>position_supports(i)
             a=position_loads(j)-position_supports(i);
             b=position_supports(i+1)-position_loads(j);
             fem(i)=fem(i)-(value_load(j)*a*(b^2))/((position_supports(i+1)-position_supports(i))^2);
        end
    end
    fem(1,i)=fem(1,i)+(4*all_theta(i)+2*all_theta(i+1))/(position_supports(i+1)-position_supports(i));
end
fem(1,count_supports+2)=(udl(1,count_supports+1)*(position_supports(count_supports+2)-position_supports(count_supports+1))^2)/12;
for i=1:1:count_load
    if position_loads(j)<position_supports(count_supports+2)&&position_loads(j)>position_supports(count_supports+1)
             a=position_loads(j)-position_supports(count_supports+1);
             b=position_supports(count_supports+2)-position_loads(j);
             fem(count_supports+2)=fem(count_supports+2)+(value_load(j)*(a^2)*(b))/((position_supports(count_supports+2)-position_supports(count_supports+1))^2);
    end
end
fem(1,count_supports+2)=fem(1,count_supports+2)+2*all_theta(count_supports+1)/((position_supports(count_supports+2)-position_supports(count_supports+1)));
fem
react=[];
react2=[];
for i=1:1:count_supports+1
    if i~=count_supports+1
        moment1=fem(i);
        moment2=-fem(i+1);
        total_moment=moment2+moment1;
        total_moment=total_moment-(udl(i)*(position_supports(i+1)-position_supports(i))^2)/2;
        total_force=udl(i)*(position_supports(i+1)-position_supports(i));
        for j=1:1:count_load
            if position_loads(j)<position_supports(i+1)&&position_loads(j)>position_supports(i)
                total_moment=total_moment-value_load(j)*(position_supports(i+1)-position_loads(j));
                total_force=total_force+value_load(j);
            end
        end
        react(i)=-total_moment/(position_supports(i+1)-position_supports(i));
        react2(i)=total_force-react(i);
    else
        moment1=fem(i);
        moment2=fem(i+1);
        total_moment=moment2+moment1;
        total_moment=total_moment-(udl(i)*(position_supports(i+1)-position_supports(i))^2)/2;
        for j=1:1:count_load
            if position_loads(j)<position_supports(i+1)&&position_loads(j)>position_supports(i)
                total_moment=total_moment-value_load(j)*(position_supports(i+1)-position_loads(j));
            end
        end
        react(i)=-total_moment/(position_supports(i+1)-position_supports(i));
    end
end
react
total_reaction=[];
for i=1:1:count_supports
    total_reaction(i)=react(i+1)+react2(i);
end
total_reaction
position_bump=[];
k=2;
p=1;
h=1;
for i=1:1:length
    if all(k<=count_supports+1)&&all(i==position_supports(k))
        position_bump(h)=position_supports(k);
        h=h+1;
        k=k+1;
    end
    if all(p<=count_load)&&all(i==position_loads(p))
        position_bump(h)=position_loads(p);
        h=h+1;
        p=p+1;
    end
end
position_bump
syms x;
theta_f=[];
theta_f(1)=0;
f=2;
k=1;
p=2;
u=2;
tr=1;
l=1;
lo=1;
fx=@(x) -udl(1)*(x.^2)/2+fem(1)+react(1)*x;
fplot(@(x) 0,[0 length], '--or');
hold on;
value=[];
points=[];
prev=0;
ui=0
for i=1:1:length
    if k<=count_load+count_supports && i==position_bump(k)
        if p<=count_supports+1 && i==position_supports(p)
            for qw=prev+0.00:0.01:position_bump(k)
                if qw==position_bump(k)
                    theta_f(f)=integral(fx,prev,position_bump(k))+theta_f(f-1);
                    a=integral(fx,prev,qw)+theta_f(f-1);
                    f=f+1;
                    a
                    points=[points qw];
                    value=[value a];
                    ui=ui+1;
                else
                    a=integral(fx,prev,qw)+theta_f(f-1);
                    a
                     points=[points qw];
                    value=[value a];
                    ui=ui+1;
                end
            end
           left=@(x) udl(u-1)*((x-position_supports(p-1)).^2)/2;
           new=@(x) udl(u-1)*(position_supports(p)-position_supports(p-1))*(x-(position_supports(p)+position_supports(p-1))/2);
           plus=@(x) udl(u)*((x-position_supports(p)).^2)/2;
           reacto=@(x) total_reaction(tr)*(x-position_supports(p));
           fx=@(x) fx(x)+left(x)-new(x)-plus(x)+reacto(x);
           p=p+1;
           tr=tr+1;
           u=u+1;
           k=k+1;
        end
        if l<=count_load && i==position_loads(l)
            for qw=prev:0.01:position_bump(k)
                if qw==position_bump(k)
                    theta_f(f)=integral(fx,prev,position_bump(k))+theta_f(f-1);
                    a=integral(fx,prev,qw)+theta_f(f-1);
                    f=f+1;
                    a
                    points=[points qw];
                    value=[value a];
                    ui=ui+1;
                else
                    a=integral(fx,prev,qw)+theta_f(f-1);
                    a
                     points=[points qw];
                    value=[value a];
                    ui=ui+1;
                end
            end
            plus=@(x) value_load(l)*(x-position_bump(k));
            fx=@(x) fx(x)-plus(x);
            l=l+1;
            k=k+1;

        end
        prev=position_bump(k-1)
    end
end
for i=prev:0.01:length
    a=integral(fx,prev,i)+theta_f(f-1);
    a
    points=[points i];
    value=[value a];
    ui=ui+1;
end
points2=[];
points2=[points2 0];
points3=[];
value2=[];
value2=[value2 0];
value3=[];
size(value)
for i=2:1:ui
    points2=[points2 points(i)];
    value2=[value2 value(i)];
    area=trapz(points2,value2);
    points3=[points3 points(i)];
    value3=[value3 area];
end
plot(points3,value3);