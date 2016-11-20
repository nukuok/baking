function result = oval_fit4(Xs, Ys)
  to_search = @(v) oval_equation_diff4(v(1),v(2),v(3),v(4),v(5),Xs,Ys);

  init = [2,2,mean(Xs),mean(Ys),0];

%  lb = [1,1,0,0,-pi/3];
%  ub = [50,50,50,50,pi/3];
  lb = [1,1,mean(Xs)-20,mean(Ys)-20,-pi];
  ub = [max(Xs)-min(Xs),max(Ys)-min(Ys),mean(Xs)+20,mean(Ys)+20,pi];

  options = optimset('fmincon');
  options = optimset(options,'Algorithm','sqp');

  result = fmincon(to_search, init, [],[],[],[],lb,ub,[],options);
end
