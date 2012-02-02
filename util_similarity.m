% util_similarity.m
%
%    similarity_vals = util_similarity( point, set, indx)
%
% Calculates the similarity between a point and a set of points.
% Returns a vector with the similarity between each point in SET(INDX) 
% from the initial POINT.

% The angle between the vectors was chosen as the basis
% for the similarity measure:
%
% s(a,b) = 1 - theta / (pi/2) 
%
% It has several desirable properties:
% If the similarity between two points is s(a,b)
% 1) s(a,b) = s(b,a), transitive
% 2) s(a,b) is on [0,1] if all elements of a and b are on [0,1]
% 3) if a and b share no nonzero elements, s(a,b) = 0;
% 4) s(a,b) = 1 iff a = b * c, where c is a constant > 0

function similarity_vals = util_similarity( point, set, indx)

similarity_vals = [];

if ~(isempty(indx) || isempty( set) || isempty( point))
    
    num_points = length( indx);
    
    % first handles the non-cell case, e.g. comparing inputs to 
    % the features within a group
    if ~iscell( point)
        pnt_mat = repmat( point, 1, num_points);
        set_mat = set(:,indx);
        inner_product = sum(( pnt_mat .* set_mat), 1);
        mag_pnt = sqrt( sum( pnt_mat .^ 2, 1)) + eps;
        mag_set = sqrt( sum( set_mat .^ 2, 1)) + eps;
        cos_theta = inner_product ./ (mag_pnt .* mag_set);

        % the 'real' was added to compensate for a numerical processing
        % artifact resulting in a cos_theta slightly greater than 1
        theta = real( acos( cos_theta));
        similarity_vals = 1 - theta / ( pi/2);
        
    % the handles the cell case, e.g. comparing full feature activities
    % against causes in the model
    else
        num_groups = length( point);
        inner_product = zeros( 1, num_points);
        sum_sq_pnt = zeros( 1, num_points);
        sum_sq_set = zeros( 1, num_points);

        for k = 1:num_groups,        
            if ~isempty( point{k})

                % this weighting factor weights matches more heavily in groups
                % with more features. In a group with one feature, a match
                % means less than in a group with 10 features.
                % TODO: consider whether to continue using the weighting
                weight = length(point{k});
                pnt_mat = repmat( point{k}, 1, num_points);
                set_mat = set{k}(:,indx);
                inner_product = inner_product + ...
                    weight * sum(( pnt_mat .* set_mat), 1);
                sum_sq_pnt = sum_sq_pnt + weight * sum( pnt_mat .^ 2, 1);
                sum_sq_set = sum_sq_set + weight * sum( set_mat .^ 2, 1);
            end
        end
        mag_pnt = sqrt( sum_sq_pnt) + eps;
        mag_set = sqrt( sum_sq_set) + eps;
        cos_theta = inner_product ./ (mag_pnt .* mag_set);

        % the 'real' was added to compensate for a numerical processing
        % artifact resulting in a cos_theta slightly greater than 1
        theta = real( acos( cos_theta));
        similarity_vals = 1 - theta / ( pi/2);
    end
end

