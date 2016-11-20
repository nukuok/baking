function [Xs,Ys] = oval_points4(foundv, gap_region)
  a = foundv(1);
  b = foundv(2);
  h = foundv(3);
  k = foundv(4);
  theta = foundv(5);

  rotate_X = @(X,Y) (cos(theta) * (X) - sin(theta) * (Y) + h);
  rotate_Y = @(X,Y) (cos(theta) * (Y) + sin(theta) * (X) + k);

  t = gap_region
  xs = cos(t) * a;
  ys = sin(t) * b;

  Xs = rotate_X(xs,ys);
  Ys = rotate_Y(xs,ys);
end
