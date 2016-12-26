function result = oval_fit5(Xs, Ys)
  to_search = @(v) oval_equation_diff5(v(1),v(2),v(3),v(4),v(5),Xs,Ys);


%  lb = [1,1,0,0,-pi/3];
%  ub = [50,50,50,50,pi/3];

  %%%% 20161204 try00
  % init = [2,2,mean(Xs),mean(Ys),0];
  % lb = [1,1,mean(Xs)-20,mean(Ys)-20,-pi];
  % ub = [max(Xs)-min(Xs),max(Ys)-min(Ys),mean(Xs)+20,mean(Ys)+20,pi];


  %%%% 20161204 try01
  % init = [0.5,0.5,mean(Xs),mean(Ys),0];
  % lb = [0.1,0.1,mean(Xs)-20,mean(Ys)-20,-pi];
  % ub = [max(Xs)-min(Xs),max(Ys)-min(Ys),mean(Xs)+20,mean(Ys)+20,pi];

  %%%% 20161204 try02
  % init = [0.2,0.2,mean(Xs),mean(Ys),0];
  % lb = [0.1,0.1,mean(Xs)-30,mean(Ys)-30,-pi];
  % ub = [max(Xs)-min(Xs),max(Ys)-min(Ys),mean(Xs)+30,mean(Ys)+30,pi];

  %%%% 20161204 try03
  % init = [0.2,0.2,mean(Xs),mean(Ys),0];
  % lb = [0.1,0.1,mean(Xs)-10,mean(Ys)-10,-pi];
  % ub = [max(Xs)-min(Xs),max(Ys)-min(Ys),mean(Xs)+10,mean(Ys)+10,pi];

  %%%% 20161204 try04
  % init = [0.2,0.2,mean(Xs),mean(Ys),0];
  % lb = [0.1,0.1,mean(Xs)-5,mean(Ys)-5,-pi];
  % ub = [max(Xs)-min(Xs),max(Ys)-min(Ys),mean(Xs)+5,mean(Ys)+5,pi];

  init = [0.2,0.2,mean(Xs),mean(Ys),0];
  lb = [0.1,0.1,mean(Xs)-3,mean(Ys)-10,-pi/4];
  ub = [max(Xs)-min(Xs),max(Ys)-min(Ys),mean(Xs)+3,mean(Ys)+10,pi/4];
  
  options = optimset('fmincon');
  options = optimset(options,'Algorithm','sqp');

  result = fmincon(to_search, init, [],[],[],[],lb,ub,[],options);
end
