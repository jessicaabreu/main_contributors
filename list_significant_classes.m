function significant_groups_scores = list_significant_groups(score_file)
%% Function to select data from classes that have a significantly higher average
%   Inputs:
%       score_file (matlab struct):
%           score_file.(lecture_number).(quiz_version).(group_name).(students)
%           score_file.(lecture_number).(quiz_version).(group_name).(grades)
%   Outputs:
%       significant_groups_scores (matlab struct):
%          significant_groups_scores.(lecture_number).(quiz_version).(group_name).(students)
%           significant_groups_scores.(lecture_number).(quiz_version).(group_name).(grades)
%
% Jessica de Abreu - jxd484@case.edu
%%
 
lectures = fieldnames(score_file);
for l=1:length(lectures)
    quiz_versions = fieldnames(score_file.(char(lectures(l))));
    for q=1:length(quiz_versions)
        groups = fieldnames(score_file.(char(lectures(l))).(char(quiz_versions(q))));
        % Making a table for anova
        group_grades = cellfun(@(x)(score_file.(char(lectures(l))). ...
            (char(quiz_versions(q))).(x).grades), groups, 'uniformoutput',false);
        flat_grades = horzcat(group_grades{:});
        group_indexes = cellfun(@(x)(repmat(x, length(score_file.(char(lectures(l))). ...
             (char(quiz_versions(q))).(x).grades), 1)), groups, 'uniformoutput',false);
        [p,tbl,stats] = anova1(flat_grades,vertcat(group_indexes{:}));
        title([lectures(l), quiz_versions(q)])
        if p <= 0.05
            [c,m,h,nms] = multcompare(stats);
            % Select groups that have significantly higher average than any
            % other group
            significant = c(:, end) <= 0.05;
            significant_pairs = c(significant, 1:2);
            g_max = [];
            for i=1:size(significant_pairs, 1)
                g_max = [g_max nms(m(:, 1) == max(m(significant_pairs(i, :))))];
            end
            g_max = unique(g_max);
            % Storing data from groups that have higher average
            for g=1:length(g_max)
                significant_groups_scores.(char(lectures(l))).(char(quiz_versions(q))). ...
                    (char(g_max(g))).grades =  score_file.(char(lectures(l))). ...
                    (char(quiz_versions(q))).(char(g_max(g))).grades;
                significant_groups_scores.(char(lectures(l))).(char(quiz_versions(q))). ...
                    (char(g_max(g))).students =  score_file.(char(lectures(l))). ...
                    (char(quiz_versions(q))).(char(g_max(g))).students;
            end
        end
    end
    
end