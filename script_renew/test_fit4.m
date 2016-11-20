addpath('preprocess_03_oval_fit')

figure
hold on

[oXs, oYs] = oval_points4([19,11,19,9,pi/5], [-pi/2:0.5:pi/2]);
plot(oXs, oYs, 'rx', 'linewidth', 3)
result = oval_fit4(oXs, oYs)
[Xs,Ys] = oval_points(result, 0.05);
plot(Xs,Ys,'r')

[oXs, oYs] = oval_points4([10,5,3,3,-pi/3], [-pi/2:0.5:pi/2*3]);
plot(oXs, oYs, 'gx', 'linewidth', 3)
result = oval_fit4(oXs, oYs)
[Xs,Ys] = oval_points(result, 0.05);
plot(Xs,Ys,'g')

[oXs, oYs] = oval_points4([10,15,40,40,pi/4], [-pi/2:0.5:pi/2]);
plot(oXs, oYs, 'bx', 'linewidth', 3)
result = oval_fit4(oXs, oYs)
[Xs,Ys] = oval_points(result, 0.05);
plot(Xs,Ys,'b')

[oXs, oYs] = oval_points4([6,6,10,30,0], [-pi:0.5:pi]);
plot(oXs, oYs, 'yx', 'linewidth', 3)
result = oval_fit4(oXs, oYs)
[Xs,Ys] = oval_points(result, 0.05);
plot(Xs,Ys,'y')
