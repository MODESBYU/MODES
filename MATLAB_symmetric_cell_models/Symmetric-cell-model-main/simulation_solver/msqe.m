function [error] = msqe(x,C)

%% create the two halves of the function
[left,~,~] = RunSim_solver(x,0);
right = C;

%% set up test arrays
% a = [[1,2,3],[3,2,1],[8,5,7]];
% b = [[1,2,3],[3,4,1],[8,5,7]];
%% sum up the squared error
total = 0;

if size(left) == size(right)
    for i = 1:size(left, 1)
        for j = 1:size(left, 2)
            diff = (left(i,j) - right(i,j))^2;
            total = total + diff;
        end
    end
else
    disp('Dimensions of left and right matrices are not consistent.');
end

%% Test method
% total = 0;
% 
% if size(a) == size(b)
%     for i = 1:size(a, 1)
%         for j = 1:size(a, 2)
%             diff = (a(i,j) - b(i,j))^2;
%             total = total + diff;
%         end
%     end
% else
%     disp('Dimensions of left and right matrices are not consistent.');
% end

%% Assign output variables

error = total;
disp(error)
end