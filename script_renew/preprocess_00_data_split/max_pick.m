function local_max = max_pick(matrix)
  tm1 = circshift(matrix, [1 0]);
  tm2 = circshift(matrix, [-1 0]);
  tm3 = circshift(matrix, [0 1]);
  tm4 = circshift(matrix, [0 -1]);

  tm1(1,:) = 0;
  tm2(end,:) = 0;
  tm3(:,1) = 0;
  tm4(:,end) = 0;

  local_max = ((matrix - tm1)>0) + ...
	      ((matrix - tm2)>0) + ...
	      ((matrix - tm3)>0) + ...
	      ((matrix - tm4)>0);
  local_max = (local_max == 4);
end
