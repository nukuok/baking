function result = oval_fit2(Xs, Ys)
  to_search = @(v) oval_equation_diff2(v(1),v(2),v(3),v(4),v(5),v(6),Xs,Ys);
  init = [0.1,0.1,0.1,0,0,0]

  options = optimset('fmincon');
  options = optimset(options,'Algorithm','sqp');

  result = fminsearch(to_search, init);
end
