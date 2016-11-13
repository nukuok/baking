addpath('preprocess_03_oval_fit')

[oXs, oYs] = oval_points([10,5,19,19,0], 0.5);
%% %% result = oval_fit(part_speed, part_spacing)
%% figure
%% plot(oXs, oYs, 'rx')
%% 
%% figure
%% result = oval_fit2(oXs, oYs)
%% oval_points2(result)

figure
hold on
% plot(part_speed, part_spacing, 'rx')
plot(oXs, oYs, 'rx')

result = oval_fit_theta_cases(oXs, oYs)

theta_range = [-pi/4 : pi/160 : pi/4];
%% [v,x,y,vx,vy,vtheta] = min_index(result)

[minn,order]=min(result)
vtheta = theta_range(order)
to_search = @(v) oval_equation_diff(v(1),v(2),v(3),v(4),vtheta,oXs,oYs);
init = [0,0];

lb = [1,1];
ub = [50,50];

options = optimset('fmincon');
options = optimset(options,'Algorithm','active-set');
fit_result = fmincon(to_search, init, [],[],[],[],lb,ub,[],options)

[Xs,Ys] = oval_points([fit_result(1),fit_result(2),vx,vy,vtheta], 0.05);
plot(Xs,Ys,'b')
