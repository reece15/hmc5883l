plot(XY(:,1),XY(:,2),'.')
hold on
result=fitellipse(XY)
plotellipse(result(3),result(4),result(1),result(2))
