function score_file = create_fake_scores(number_of_students, number_of_groups, number_of_lectures, number_of_players, increase_per_player, MISSING_STUDENTS)
%% Function creates fake data for testing algorithms to assess how individual students contribute to overall group results
%   The dataset considers a class under the following setting:
%   1) Students are split into number_of_groups groups (ha!)
%   2) After a quiz, the groups are shuffled, and the quiz is retaken.
%
%   Inputs: 
%       number_of_students (integer): number of students in the class
%       number_of_groups (integer): number of groups to split the students
%       number_of_lectures (integer): number of lectures in which quizes
%       will be given.
%       number_of_players (integer): number of students that are main
%       contributors (increase the average of the group when they are
%       present).
%       increase_per_player ([0, 1]): fraction of grade average increase
%       when player is present.
%       MISSING_STUDENTS (0 OR 1): if set to 1, the data will consider
%       that a random number of students between 0 and 20% of the class is
%       not present each day.
%
%   Ouputs:
%   score_file: a matlab structure containing the fields=>
%      score_file.(lecture_number).(quiz_version).(group_name).(students)
%      score_file.(lecture_number).(quiz_version).(group_name).(grades)
%      score_file. players = player_ids
%
% Jessica de Abreu - jxd484@case.edu

student_ids = 1:number_of_students;
max_missing = ceil(number_of_students * 0.2);
% The first ids will be the players
players = 1:number_of_players;
score_file.players = players;

for l=1:number_of_lectures
    lecture_name = strcat('lecture', num2str(l));
    % Removing missing students, if set to do so.
    if MISSING_STUDENTS == 1
        number_missing = randi([0 max_missing]);
        class_final = datasample(student_ids,number_of_students-number_missing, 'Replace',false);
    else
        class_final = student_ids;
    end
    % In each lecture, students are randomly assigned to groups.
    idx1 = randperm(length(class_final)); % first round
    idx2 = randperm(length(class_final)); % second round
    std_per_group = floor(length(class_final)/number_of_groups);
    for g=1:number_of_groups
        if g == number_of_groups
            students_r1 = class_final(idx1(1+(g-1)*std_per_group:end));
            students_r2 = class_final(idx2(1+(g-1)*std_per_group:end));
        else
            students_r1 = class_final(idx1(1+(g-1)*std_per_group:g*std_per_group));
            students_r2 = class_final(idx2(1+(g-1)*std_per_group:g*std_per_group));
        end
        score_file.(lecture_name).('r1').(strcat('group', num2str(g))). ...
            students = students_r1;
        % For the first round, grades will be randomly selected from normal
        % distributions centered in 5, with std 1.5
        % If a player is in the team, the score is higher
        idx_player_1 = ismember(students_r1, players);
        grades_1 = normrnd(5 + increase_per_player * nnz(idx_player_1) * 5, 1.5,[1,length(students_r1)]);
        score_file.(lecture_name).('r1').(strcat('group', num2str(g))). ...
            grades = grades_1;
        % For the second round, grades will be randomly selected from normal
        % distributions centered in 7, with std 1.0
        % If a player is in the team, the score is higher
        idx_player_2 = ismember(students_r2, players);
        grades_2 = normrnd(5 + increase_per_player * nnz(idx_player_2) * 5, 1.5,[1,length(students_r2)]);
        score_file.(lecture_name).('r2').(strcat('group', num2str(g))). ...
            grades = grades_2;
    end
end
    