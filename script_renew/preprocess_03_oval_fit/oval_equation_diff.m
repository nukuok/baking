function sum_norms = oval_equation_diff(a,b,h,k,theta,Xs,Ys)
  rotate_X = @(X,Y) (cos(theta) * (X-h) + sin(theta) * (Y-k) + h);
  rotate_Y = @(X,Y) (cos(theta) * (Y-k) - sin(theta) * (X-h) + k);

  rotated_Xs = arrayfun(rotate_X, Xs, Ys);
  rotated_Ys = arrayfun(rotate_Y, Xs, Ys);

  if a > b
    axis = a;
    f = sqrt(a^2 - b^2);
    focus1 = [h-f,k];
    focus2 = [h+f,k];
  else
    axis = b;
    f = sqrt(b^2 - a^2);
    focus1 = [h,k-f];
    focus2 = [h,k+f];
  end

  f1_x = rotated_Xs - focus1(1);
  f1_y = rotated_Ys - focus1(2);
  f2_x = rotated_Xs - focus2(1);
  f2_y = rotated_Ys - focus2(2);
  
  d1 = sqrt(f1_x .^2 + f1_y .^2);
  d2 = sqrt(f2_x .^2 + f2_y .^2);

  sum_norms = norm(d1 + d2 - 2 * axis);
end
