function sum_norms = oval_equation_diff2(a,b,c,u,v,f,Xs,Ys)
  a = 1
  distance = a*(Xs-u).^2 + b*(Xs-u).*(Ys-v) + c*(Ys-v).^2 + f

  sum_norms = norm(distance)
end
