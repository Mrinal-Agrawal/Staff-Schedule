function fitness = FitnessFunc(schedule, numEmployees, numDays, coverage, blockDuration, restDuration, maxSpecialDays)
numDays = 7; % Planning horizon (days)
numEmployees = 10; % Total number of employees
coverage = [4,4,4,4,4,4,4]; % Daily employee requirements

blockDuration = 3; % Max days in one work block
restDuration = 2; % Max days of rest after a block
maxSpecialDays = 2; % Max workdays on special days (e.g., weekends)   
schedule = reshape(schedule, numEmployees, numDays); % Reshape into employee-day matrix

    % 1. Coverage Penalty
    dayCoverage = sum(schedule, 1); % Coverage for each day
    coveragePenalty = sum(max(0, coverage - dayCoverage)); % Understaffing penalty

    % 2. Block and Rest Duration Penalty
    blockRestPenalty = 0;
    for i = 1:numEmployees
        workDays = find(schedule(i, :) == 1);
        if ~isempty(workDays)
            blockLengths = diff([0, workDays]) - 1; % Lengths of blocks/rests
            blockRestPenalty = blockRestPenalty + sum(blockLengths > blockDuration) + ...
                               sum(blockLengths < restDuration & blockLengths > 0);
        end
    end

    % 3. Special Day Penalty (weekends assumed)
    specialDays = [6, 7];  % Saturday, Sunday
    specialDayWork = sum(schedule(:, specialDays), 'all');
    specialDaysPenalty = max(0, specialDayWork - maxSpecialDays);

    % Objective: Minimize employees used + penalties
    fitness = sum(any(schedule, 2)) + 100 * (coveragePenalty + blockRestPenalty + specialDaysPenalty);
end