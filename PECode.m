clear; clc; close all;

d = load('data.data');

sigma = 3.4; % in Angstrom 
eps = 0.0024;  % in eV

xSub = d(1:960,3:5);
xC60 = d(961:1020,3:5);

xC60(:,1) = xC60(:,1) - mean(xC60(:,1));
xC60(:,2) = xC60(:,2) - mean(xC60(:,2));
xC60(:,3) = xC60(:,3) - mean(xC60(:,3)); % average z of C60 com is 8.08
xNum = 1;


for x = min(xSub(:,1))-5:0.5:max(xSub(:,1))+5
    yNum = 1;
    for y = min(xSub(:,2))-5:0.5:max(xSub(:,2))+5
        lj(xNum,yNum) = 0;
        xC60(:,1) = xC60(:,1) + x;
        xC60(:,2) = xC60(:,2) + y;
        for z = 8.0:0.2:10
            ljValue = 0;
            xC60(:,3) = xC60(:,3) + (z - mean(xC60(:,3)));
            for i = 1:length(xSub(:,1))
                for j = 1:length(xC60(:,1))
                    xsrf(xNum,yNum) = x;
                    ysrf(xNum,yNum) = y;
                    r = ((xSub(i,1)-xC60(j,1))^2 + ...
                        (xSub(i,2)-xC60(j,2))^2 + ...
                        (xSub(i,3)-xC60(j,3))^2 )^0.5;
                    ljValue = ljValue + 4*eps*((sigma/r)^12 - (sigma/r)^6);
                end
            end
            lj(xNum,yNum) = min([lj(xNum,yNum) , ljValue]);
            xC60(:,3) = xC60(:,3) - mean(xC60(:,3));
        end
        %                     hold on
        %                     plot3(xC60(:,1),xC60(:,2),xC60(:,3),'O')
        %                     plot3(xSub(:,1),xSub(:,2),xSub(:,3),'O')
        %                     pause(0.1)
        %                     axis equal
        xC60(:,1) = xC60(:,1) - mean(xC60(:,1));
        xC60(:,2) = xC60(:,2) - mean(xC60(:,2));
        yNum = yNum + 1;
    end
    xNum = xNum + 1;
end


surf(xsrf,ysrf,lj)
% hold on 
% plot3(xC60(:,1),xC60(:,2),xC60(:,3),'O')
% plot3(xSub(:,1),xSub(:,2),xSub(:,3),'O')
axis equal


