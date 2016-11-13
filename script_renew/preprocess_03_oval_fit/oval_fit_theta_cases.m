function result = oval_fit_theta_cases(Xs, Ys)
  theta_range = [-pi/4 : pi/160 : pi/4];

  iteration = prod(size(theta_range));
  for ii = 1:iteration
    result = zeros(iteration)

    ii

    theta = theta_range(ii);
    to_search = @(v) oval_equation_diff(v(1),v(2),v(3),v(4),theta,Xs,Ys);
  
    init = [0,0,0,0];
  
    lb = [1,1,0,0];
    ub = [50,50,50,50];
  
    options = optimset('fmincon');
    options = optimset(options,'Algorithm','active-set');
    fit_result = fmincon(to_search, init, [],[],[],[],lb,ub,[],options);

    a = fit_result(1)
    b = fit_result(2)
    h = fit_result(3)
    k = fit_result(4)
    result(ii1) = oval_equation_diff(a,b,h,k,theta,Xs,Ys);
  end
end
