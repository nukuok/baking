function [delta, fi, arc] = oval_find_T(a,b,h,k,theta,Xs,Ys)
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
  alpha_bar = sqrt(cos(theta)^2 / a^2 + sin(theta)^2 / b^2);
  beta_bar = sqrt(sin(theta)^2 / a^2 + cos(theta)^2 / b^2);
  fi = asin(abs(1/b^2 - 1/a^2) * cos(theta) * sin(theta) / alpha_bar / beta_bar);

  cos_start = cos_value(1);
  sin_start = sin_value(1);
  cos_end = cos_value(end);
  sin_end = sin_value(end);
  if sin_start < 0
    arc_start = 2 * pi - acos(cos_start);
  else
    arc_start = acos(cos_start);
  end
  
  if sin_end < 0
    arc_end = 2 * pi - acos(cos_end);
  else
    arc_end = acos(cos_end);
  end

  if arc_end <= arc_start
    arc = arc_end + 2 *pi - arc_start;
  else
    arc = arc_end - arc_start;
  end
  omega = arc / 2 * pi;
  delta = (pi / 2 - fi) / omega;
end
