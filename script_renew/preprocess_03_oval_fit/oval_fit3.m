function result = oval_fit3(Xs, Ys)
  to_search = @(v) oval_equation_diff3(v(1),v(2),v(3),v(4),v(5),Xs,Ys);

  init = [0,0,0,0,0]

  lb = [1,1,0,0,-pi/3];
  ub = [50,50,50,50,pi/3];

  options = optimset('fmincon');
  options = optimset(options,'Algorithm','sqp');

  result = fmincon(to_search, init, [],[],[],[],lb,ub,[],options)
end
