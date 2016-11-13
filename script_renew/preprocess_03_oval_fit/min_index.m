function [v,x,y,vx,vy,vtheta] = min_index(result)
  [r1,o1] = min(result,[],1);
  [r2,o2] = min(result,[],2);
  [v,y] = min(r1)
  [v,x] = min(r2)

  x_range = [1:1:50];
  y_range = [1:1:50];
  [X_matrix, Y_matrix] = meshgrid(x_range,y_range);
  theta_range = [0];
  %% theta_range = [-pi/4 : pi/20 : pi/4];
  vx = X_matrix(x);
  vy = Y_matrix(x);
  %% v
  %% x
  %% y
  %% vx
  %% vy
  vtheta=theta_range(y);
end
