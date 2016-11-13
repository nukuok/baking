function result = oval_fit_cases(Xs, Ys)
  x_range = [1:1:50];
  y_range = [1:1:50];
  [X_matrix, Y_matrix] = meshgrid(x_range,y_range);
  %% theta_range = [-pi/4 : pi/20 : pi/4];
  theta_range = [0];

  iteration1 = prod(size(X_matrix));
  iteration2 = prod(size(theta_range));

  result = zeros(iteration1, iteration2);
  for ii1 = 1:iteration1
    for ii2 = 1:iteration2
      ii1
      ii2
      h = X_matrix(ii1);
      k = Y_matrix(ii1);
      theta = theta_range(ii2);
      to_search = @(v) oval_equation_diff(v(1),v(2),h,k,theta,Xs,Ys);

      init = [0,0];

      lb = [1,1];
      ub = [50,50];

      options = optimset('fmincon');
      options = optimset(options,'Algorithm','active-set');
      fit_result = fmincon(to_search, init, [],[],[],[],lb,ub,[],options);

      result(ii1,ii2) = oval_equation_diff(fit_result(1),fit_result(2),h,k,theta,Xs,Ys);
    end
  end
  %% [v,x,y] = min_index(result)
end
%% to_search = @(v) oval_equation_diff(v(1),v(2),v(3),v(4),v(5),Xs,Ys);
%% 
%% init = [0,0,2,2,pi/4]
%% 
%% lb = [1,1,2,2,-pi/4];
%% ub = [50,50,2,2,pi/4];
%% 
%% options = optimset('fmincon');
%% options = optimset(options,'Algorithm','active-set');
%% result = fmincon(to_search, init, [],[],[],[],lb,ub,[],options)
