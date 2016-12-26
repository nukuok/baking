function sum_norms = oval_equation_diff5(a,b,h,k,theta,Xs,Ys)
  rotate_X = @(X,Y) (cos(theta) * (X-h) + sin(theta) * (Y-k));
  rotate_Y = @(X,Y) (cos(theta) * (Y-k) - sin(theta) * (X-h));
  distance = @(X,Y) sqrt(X.^2 + Y.^2);
  
  XX = rotate_X(Xs, Ys);
  YY = rotate_Y(Xs, Ys);

  fake_YY = YY/b*a;

  mame = distance(XX, fake_YY);

  cos_value = XX ./ mame;
  sin_value = fake_YY ./ mame;

  X_on_oval = cos_value * a;
  Y_on_oval = sin_value * b;
  
  DD = distance(X_on_oval - XX, Y_on_oval - YY);
  
  sum_norms = norm(DD);
end
