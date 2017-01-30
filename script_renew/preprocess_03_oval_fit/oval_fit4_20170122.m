function result = oval_fit4_20170122(Xs, Ys)
  to_search = @(v) oval_equation_diff4(v(1),v(2),v(3),v(4),v(5),Xs,Ys);

  options = optimset('fmincon');
  options = optimset(options,'Algorithm','sqp');
  
  results = {}
  value = zeros(6,1)
%  lb = [1,1,0,0,-pi/3];
%  ub = [50,50,50,50,pi/3];

  %%%% 20161204 try00
  init = [2,2,mean(Xs),mean(Ys),0];
  lb = [1,1,mean(Xs)-20,mean(Ys)-20,-pi];
  ub = [max(Xs)-min(Xs),max(Ys)-min(Ys),mean(Xs)+20,mean(Ys)+20,pi];
  results{1} = fmincon(to_search, init, [],[],[],[],lb,ub,[],options);
  result = results{1}
  error(1) = oval_equation_diff4(result(1),result(2),result(3),result(4),result(5),Xs,Ys);

  %%%% 20161204 try01
  init = [0.5,0.5,mean(Xs),mean(Ys),0];
  lb = [0.1,0.1,mean(Xs)-20,mean(Ys)-20,-pi];
  ub = [max(Xs)-min(Xs),max(Ys)-min(Ys),mean(Xs)+20,mean(Ys)+20,pi];
  results{2} = fmincon(to_search, init, [],[],[],[],lb,ub,[],options);
  result = results{2}
  error(2) = oval_equation_diff4(result(1),result(2),result(3),result(4),result(5),Xs,Ys);

  %%%% 20161204 try02
  init = [0.2,0.2,mean(Xs),mean(Ys),0];
  lb = [0.1,0.1,mean(Xs)-30,mean(Ys)-30,-pi];
  ub = [max(Xs)-min(Xs),max(Ys)-min(Ys),mean(Xs)+30,mean(Ys)+30,pi];
  results{3} = fmincon(to_search, init, [],[],[],[],lb,ub,[],options);
  result = results{3}
  error(3) = oval_equation_diff4(result(1),result(2),result(3),result(4),result(5),Xs,Ys);

  %%%% 20161204 try03
  init = [0.2,0.2,mean(Xs),mean(Ys),0];
  lb = [0.1,0.1,mean(Xs)-10,mean(Ys)-10,-pi];
  ub = [max(Xs)-min(Xs),max(Ys)-min(Ys),mean(Xs)+10,mean(Ys)+10,pi];
  results{4} = fmincon(to_search, init, [],[],[],[],lb,ub,[],options);
  result = results{4}
  error(4) = oval_equation_diff4(result(1),result(2),result(3),result(4),result(5),Xs,Ys);

  %%%% 20161204 try04
  init = [0.2,0.2,mean(Xs),mean(Ys),0];
  lb = [0.1,0.1,mean(Xs)-5,mean(Ys)-5,-pi];
  ub = [max(Xs)-min(Xs),max(Ys)-min(Ys),mean(Xs)+5,mean(Ys)+5,pi];
  results{5} = fmincon(to_search, init, [],[],[],[],lb,ub,[],options);
  result = results{5}
  error(5) = oval_equation_diff4(result(1),result(2),result(3),result(4),result(5),Xs,Ys);

  init = [0.2,0.2,mean(Xs),mean(Ys),0];
  lb = [0.1,0.1,mean(Xs)-3,mean(Ys)-10,-pi];
  ub = [max(Xs)-min(Xs),max(Ys)-min(Ys),mean(Xs)+3,mean(Ys)+10,pi];
  results{6} = fmincon(to_search, init, [],[],[],[],lb,ub,[],options);
  result = results{6}
  error(6) = oval_equation_diff4(result(1),result(2),result(3),result(4),result(5),Xs,Ys);
  
  [minn, min_index] = min(error);
  result = results{min_index};
  % result = fmincon(to_search, init, [],[],[],[],lb,ub,[],options);
end
