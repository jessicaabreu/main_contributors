function student_frequency = get_players(significant_groups_scores)
%%% Returns how frequently students are in groups that have higher average
% Input:
%   significant_groups_scores (matlab struct):
%   significant_groups_scores.(lecture_number).(quiz_version).(group_name).(students)
%   significant_groups_scores.(lecture_number).(quiz_version).(group_name).(grades)
%
% Output:
%   student_frequency (vector): first column is students id, secind column
%   is how frequently the student is in a group with higher average.
% Jessica de Abreu - jxd484@case.edu
%

lectures = fieldnames(significant_groups_scores);
number_of_quizzes = 0;
students_total = [];
for l=1:length(lectures)
    quiz_versions = fieldnames(significant_groups_scores.(char(lectures(l))));
    for q=1:length(quiz_versions)
        groups = fieldnames(significant_groups_scores.(char(lectures(l))). ...
            (char(quiz_versions(q))));
        for g=1:length(groups)
            number_of_quizzes = number_of_quizzes + 1;
            students = significant_groups_scores.(char(lectures(l))). ...
            (char(quiz_versions(q))).(char(groups(g))).students;
            students_total = [students_total students];
        end       
    end
end
unique_students = unique(students_total);
result = arrayfun(@(x)(length(nonzeros(x==students_total))), unique_students);
result_percent = result/number_of_quizzes;
student_frequency = [unique_students' result_percent'];
end