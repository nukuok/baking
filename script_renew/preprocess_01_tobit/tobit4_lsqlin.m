function [delta, tau] = tobit4_lsqlin(speed, spacing, acc)
  % x = lsqlin(C,d,A,b)
  speed = speed(abs(acc)<0.1);
  spacing = spacing(abs(acc)<0.1);

  % LL = @(delta, tau) -sum((spacing - tau * speed - delta) .^ 2);
  %% v(1) -> delta, v(2) -> tau
  LL = @(v) sum((spacing - v(2) * speed - v(1)) .^ 2);
  LL5 = @(v) sum((spacing - 5 * speed - v(1)) .^ 2);
  LL0 = @(v) sum((spacing - 0 * speed - v(1)) .^ 2);

  foundv = fminsearch(LL, [0,0])
  delta = foundv(1)
  tau = foundv(2)

  if tau > 5
    tau = 5
    foundv = fminsearch(LL5, [0,0])
    delta = foundv(1)
  elseif tau < 0
    tau = 0
    foundv = fminsearch(LL0, [0,0])
    delta = foundv(1)
end
