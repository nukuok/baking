function [Xs,Ys] = oval_points(foundv, gap)
  a = foundv(1);
  b = foundv(2);
  h = foundv(3);
  k = foundv(4);
  theta = foundv(5);

  rotate_X = @(X,Y) (cos(theta) * (X-h) - sin(theta) * (Y-k) + h);
  rotate_Y = @(X,Y) (cos(theta) * (Y-k) + sin(theta) * (X-h) + k);

  t = [gap:gap:2*pi];
  xs = h + cos(t) * a;
  ys = k + sin(t) * b;

  Xs = rotate_X(xs,ys);
  Ys = rotate_Y(xs,ys);
end
