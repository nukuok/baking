function [delta, tau] = tobit4_lsqlin(speed, spacing, acc)
  % x = lsqlin(C,d,A,b)
  speed = speed(acc<0.1);
  spacing = spacing(acc<0.1);

  LL = @(delta, tau) -sum((spacing - tau * speed - delta) .^ 2);

  % x = lsqlin([1,0,0;2,0,0;3,0,0],[2,4,6]',zeros(3),[1,1,1]')
  data_length = length(speed);
  C = zeros(data_length);
  C(:,1) = speed';

  options = optimset('lsqlin');
  options = optimset(options,'LargeScale','off');
  x = lsqlin(C, spacing', zeros(data_length), ones(data_length,1),[],[],[],[],[], options)
  % size(x)
  % size(C)
  % size(zeros(size(C,1),1))
  tau = x(1);

  if tau > 5
    delta = mean(spacing - 5 * speed);
  elseif tau < 0
    delta = mean(spacing);
  else
    delta = mean(spacing - tau * speed);
  end		   
end
