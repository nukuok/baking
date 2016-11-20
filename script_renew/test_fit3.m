addpath('preprocess_03_oval_fit')

[oXs, oYs] = oval_points([3,2,9,9,0], 0.5);

figure
hold on
plot(oXs, oYs, 'rx')

result = oval_fit3(oXs, oYs)
%[a,b,h,k,theta] = result

%to_search = @(v) oval_equation_diff(v(1),v(2),vx,vy,vtheta,oXs,oYs);

%      init = [0,0];

%      lb = [1,1];
%      ub = [50,50];

%      options = optimset('fmincon');
%      options = optimset(options,'Algorithm','active-set');
%      fit_result = fmincon(to_search, init, [],[],[],[],lb,ub,[],options)

[Xs,Ys] = oval_points(result, 0.05);
plot(Xs,Ys,'b')
