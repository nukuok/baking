function [Xs,Ys] = oval_points2(foundv)
  a = foundv(1);
  b = foundv(2);
  c = foundv(3);
  u = foundv(4);
  v = foundv(5);
  f = foundv(6);
  color = @(x,y) abs(a*(x-u).^2 + b*(x-u).*(y-v) + c*(y-v).^2 + f)

  [x,y] = meshgrid([0:.05:50]);
  Z = arrayfun(color,x,y);
  surf(x,y,Z)
  colorbar
end
