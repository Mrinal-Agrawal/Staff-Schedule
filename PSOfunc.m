function [Xbest,Fbest] = PSOfunc(FITNESSFUN,Npop,lb,ub,Maxiter,w,c1,c2)

%Determine the number of variables
D = length(lb);

% Generate a random population
pop = repmat(lb,Npop,1) + repmat((ub-lb),Npop,1).*rand(Npop,D);
pop = pop>=0.5;
% Generate random velocity vectors
v = repmat(lb,Npop,1) + repmat((ub-lb),Npop,1).*rand(Npop,D);
v = v >= 0.5;
%Evaluate the fitness value for each population member
for i = 1:Npop
    obj(i) = FITNESSFUN(pop(i,:));
end

%Initialize the personal best solutions
pbest = pop;
pbest_obj = obj;


% determine the global best solution
[gbest_obj,ind] = min(obj);
gbestPop = pop(ind,:);


% Perform iterations
for j = 1:Maxiter
    
    for i = 1:Npop
        
        % generate new velocity vector for the solution i
        v(i,:) = w*v(i,:) + c1*rand(1,D).*(pbest(i,:)-pop(i,:)) + c2*rand(1,D).*(gbestPop - pop(i,:));
        v(i,:) = v(i,:) >= 0.5;
        % generate new solution 
        pop(i,:) = pop(i,:) + v(i,:);
        
        
        pop(i,:) = pop(i,:) >= 0.5;
        
        % Determine the fitness of the new population member
        obj(i) = FITNESSFUN(pop(i,:));
        
        % update the personal best solution
        if obj(i)<pbest_obj(i)
            pbest(i,:) =  pop(i,:);
            pbest_obj(i) = obj(i);
            
            % update the global best solution
            if pbest_obj(i)< gbest_obj
                gbest_obj = pbest_obj(i);
                gbestPop = pbest(i,:);
            end
        end
    end
end

Fbest = gbest_obj;
Xbest = pbest(ind,:);



