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

result = oval_fit_cases(oXs, oYs)
[v,x,y,vx,vy,vtheta] = min_index(result)
to_search = @(v) oval_equation_diff(v(1),v(2),vx,vy,vtheta,oXs,oYs);
      init = [0,0];

      lb = [1,1];
      ub = [50,50];

      options = optimset('fmincon');
      options = optimset(options,'Algorithm','active-set');
      fit_result = fmincon(to_search, init, [],[],[],[],lb,ub,[],options)

[Xs,Ys] = oval_points([fit_result(1),fit_result(2),vx,vy,vtheta], 0.05);
plot(Xs,Ys,'b')
