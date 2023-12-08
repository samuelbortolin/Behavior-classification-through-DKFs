clear all;
close all;
clc;

% Hyperparameters
node_number = 50;                                           % The number of sensors/nodes of the network
max_communication_range = 500;                              % Nodes can communicate with other nodes up to a certain max_communication_range distance
communication_failure_prob = 0.001;                         % Probability of failure to communicate
sigma_z_value = 25;                                         % Sensors noise standard deviation
max_detection_range = 250;                                  % Sensors reveal the entity up to a certain max_detection_range distance
entity_misdetection_prob = 0.001;                           % Probability of not detecting the entity
sigma_noise_human = 10;                                     % Human model noise standard deviation
sigma_noise_animal = 10;                                    % Animal model noise standard deviation
animal_change_direction_prob = 1/3;                         % Probability of the animal of changing direction
iterations = 30;                                            % Kalman filters iterations
min_iterations_for_delta = 5;                               % Minimum number of iterations for computing a delta between positions in order to compute direction and norm of the control input
animal_model_scaling_factor = 3;                            % The scaling factor on the step that the animal will take in the previous direction

use_animal_dynamics = 0;                                    % Whether to use the animal dynamics for the entity moving in the area or not

initial_regularization = 0;
regularization_increase = 1;
use_plots = 1;
use_logs = 1;

fig_id = 0;

%% Network topology

% Create random positions for the sensors (they are static sensors), the area is a space of size area_size * area_size
area_size = 1000;
node_positions = area_size * rand(2, node_number);

% Plot the placement of the sensors
if use_plots == 1
    fig_id = fig_id + 1;
    figure(fig_id), clf, hold on;
    scatter(node_positions(1 ,:), node_positions(2 ,:));
    text(node_positions(1 ,:) + 10, node_positions(2 ,:), cellstr(num2str((1 : node_number)')));
end

% Adjacency matrix (computed by connecting only nodes up to a certain max_communication_range distance)
adjacency_matrix = zeros(node_number, node_number);
for i = 1 : node_number
    for j = i + 1 : node_number
        if norm(node_positions(:, i) - node_positions(:, j)) < max_communication_range
            adjacency_matrix(i, j) = 1;
        end
    end
end
adjacency_matrix = adjacency_matrix + adjacency_matrix';

% Plot the graph
if use_plots == 1
    fig_id = fig_id + 1;
    figure(fig_id), clf, hold on;
    g = graph(adjacency_matrix);
    plot(g);
end

% Compute the weights of the consensus protocol (Metropolis-Hastings weights)
D = sum(adjacency_matrix, 2);
Q = zeros(node_number, node_number);
for i = 1 : node_number
    for j = 1 : node_number
        if not(i == j) && (adjacency_matrix(i, j) == 1)
            Q(i, j) = 1 / (max(D(i), D(j)) + 1);
        end
    end
    Q(i, i) = 1 - sum(Q(i, :));
end

% Simulation set-up for consensus iterations
Dt = 0.1;
t = 0 : Dt : 2;

%% Sensors

% Initial position of the entity to track
p_init = 300 + 400 * rand(2, 1);
if use_logs == 1
    disp(['Initial position:', ' x = ', num2str(p_init(1)), ' y = ', num2str(p_init(2))]);
end

% Sensors uncertainties
sigma_z = zeros(2, node_number);
for i = 1 : node_number
    sigma_z(:, i) = sigma_z_value * ones(2, 1);
end

% Measured positions by the sensors. We assume that each sensor has a GPS and knows its position and through a thermal camera can estimate the position of the detected entity
Z = zeros(2, node_number);
C = zeros(2, 2, node_number);
for i = 1 : node_number
    if norm(node_positions(:, i) - p_init) < max_detection_range && not(rand(1) < entity_misdetection_prob)
        Z(:, i) = p_init + sigma_z(:, i) .* randn(2, 1);
        C(:, :, i) = diag(sigma_z(:, i).^2);
    else
        Z(:, i) = NaN(2, 1);
        C(:, :, i) = NaN(2, 2);
    end
end

%% Kalman Filter

p_Kest1 = zeros(2, node_number);
P_Kest1 = zeros(2, 2, node_number);
prob_1 = 0.5 + zeros(node_number, 1);

p_Kest2 = zeros(2, node_number);
P_Kest2 = zeros(2, 2, node_number);
prob_2 = 0.5 + zeros(node_number, 1);

% Nodes initialization
for i = 1 : node_number
    p_Kest1(:, i) = 500 * ones(2, 1);
    P_Kest1(:, :, i) = 10^6 * eye(2);

    p_Kest2(:, i) = 500 * ones(2, 1);
    P_Kest2(:, :, i) = 10^6 * eye(2);
end

% Human dynamics
Ahuman = eye(2);
direction_human = 2 * pi * rand(1);
direction_human = [cos(direction_human); sin(direction_human)];

% Animal dynamics
Aanimal = eye(2);
direction_animal = 2 * pi * rand(1);
direction_animal = [cos(direction_animal); sin(direction_animal)];

% Real dynamics matrices of the entity
if use_animal_dynamics == 1
    A = Aanimal;
    direction = direction_animal;
    sigma_noise = sigma_noise_animal;
else
    A = Ahuman;
    direction = direction_human;
    sigma_noise = sigma_noise_human;
end

fig_id = fig_id + 1;
fig_id1 = fig_id;
fig_id = fig_id + 1;
fig_id2 = fig_id;
fig_id = fig_id + 1;
fig_id_avg = fig_id;

p = p_init;
u = 20;

previous_position_for_human_estimate = Z;
u_human_predicted = NaN(node_number, 1);
first_measurement_iteration = NaN(node_number, 1);
for i = 1 : node_number
    if not(isnan(previous_position_for_human_estimate(:, i)))
        first_measurement_iteration(i) = 0;
    end
end

iterations_needed_for_delta = min_iterations_for_delta * ones(node_number, 1);
direction_human_predicted = NaN(2, node_number);

previous_position_for_animal_estimate = Z;
u_animal_predicted = NaN(node_number, 1);
direction_animal_predicted = NaN(2, node_number);

error_model_combined = 0;
error_model_1 = 0;
error_model_2 = 0;

tracking_error_history1 = NaN(iterations, 1);
tracking_error_history2 = NaN(iterations, 1);
tracking_error_historyZ = NaN(iterations, 1);

for iteration = 1 : iterations
    % Application of the real dynamics
    if rand(1) < animal_change_direction_prob
        direction_animal = 2 * pi * rand(1);
        direction_animal = [cos(direction_animal); sin(direction_animal)];
    end

    if use_animal_dynamics == 1
        direction = direction_animal;
        u = u - 5 * (0.5 - rand(1));  % For the animal model it is quite random
    else
        u = u - 0.1 * (0.5 - rand(1));  % For the human models it is almost the same
    end

    p = A * p + direction * u + sigma_noise * randn(2, 1);

    % Kalman filters
    for i = 1 : node_number
        % - Prediction step (for the 2 models)
        if not(isnan(direction_human_predicted(1, i))) && not(isnan(u_human_predicted(i)))
            p_Kest1(:, i) = Ahuman * p_Kest1(:, i) + direction_human_predicted(:, i) * u_human_predicted(i);  % Use the estimated direction and u
        else
            p_Kest1(:, i) = Ahuman * p_Kest1(:, i);
        end
        P_Kest1(:, :, i) = Ahuman * P_Kest1(:, :, i) * Ahuman' + sigma_noise_human^2 * eye(2);

        if not(isnan(direction_animal_predicted(1, i))) && not(isnan(u_animal_predicted(i)))
            p_Kest2(:, i) = Aanimal * p_Kest2(:, i) + (direction_animal_predicted(:, i) * u_animal_predicted(i)) / animal_model_scaling_factor;  % The model does not know the changes in the direction, the position is updated with the previos estimated direction and u
        else
            p_Kest2(:, i) = Aanimal * p_Kest2(:, i);
        end
        P_Kest2(:, :, i) = Aanimal * P_Kest2(:, :, i) * Aanimal' + sigma_noise_animal^2 * eye(2);

        % Measurements
        if norm(node_positions(:, i) - p) < max_detection_range && not(rand(1) < entity_misdetection_prob)
            Z(:, i) = p + sigma_z(:, i) .* randn(2, 1);
            C(:, :, i) = diag(sigma_z(:, i).^2);

            % Direction estimation
            if isnan(previous_position_for_human_estimate(:, i))
                previous_position_for_human_estimate(:, i) = Z(:, i);
                iterations_needed_for_delta(i) = iterations_needed_for_delta(i) + iteration;
                first_measurement_iteration(i) = iteration;
            end
            if iteration == iterations_needed_for_delta(i)
                if not(isnan(previous_position_for_human_estimate(:, i)))
                    delta = Z(:, i) - previous_position_for_human_estimate(:, i);
                    u_human_predicted(i) = norm(delta) / (iteration - first_measurement_iteration(i));
                    current_direction_estimations = atan2(delta(2), delta(1));
                    direction_human_predicted(:, i) = [cos(current_direction_estimations); sin(current_direction_estimations)];
                end
            end

            if not(isnan(previous_position_for_animal_estimate(:, i)))
                temp = Z(:, i) - previous_position_for_animal_estimate(:, i);
                u_animal_predicted(i) = norm(temp);
                animal_direction_estimation = atan2(temp(2), temp(1));
                direction_animal_predicted(:, i) = [cos(animal_direction_estimation); sin(animal_direction_estimation)];
            else
                u_animal_predicted(i) = NaN(1);
                direction_animal_predicted(:, i) = NaN(2, 1);
            end
        else
            Z(:, i) = NaN(2, 1);
            C(:, :, i) = NaN(2, 2);

            if iteration == iterations_needed_for_delta(i) && not(isnan(first_measurement_iteration(i)))
                iterations_needed_for_delta(i) = iterations_needed_for_delta(i) + 1;
            end

            u_animal_predicted(i) = NaN(1);
            direction_animal_predicted(:, i) = NaN(2, 1);
        end
        previous_position_for_animal_estimate(:, i) = Z(:, i);
    end

    % Consensus algoritm
    a = NaN(2, node_number);
    a_new = NaN(2, node_number);
    F = NaN(2, 2, node_number);
    F_new = NaN(2, 2, node_number);
    node_estimates = zeros(node_number);
    node_estimates_new = zeros(node_number);

    for j = 1 : node_number
        if not(isnan(Z(:, j)))
            a(:, j) = inv(C(:, :, j)) * Z(:, j);
            F(:, :, j) = inv(C(:, :, j));
            node_estimates(j, j) = 1;
        end
    end

    current_u_human_predicted = u_human_predicted;
    current_u_human_predicted_new = NaN(node_number, 1);
    current_direction_human_predicted = direction_human_predicted;
    current_direction_human_predicted_new = NaN(2, node_number);

    current_u_animal_predicted = u_animal_predicted;
    current_u_animal_predicted_new = NaN(node_number, 1);
    current_direction_animal_predicted = direction_animal_predicted;
    current_direction_animal_predicted_new = NaN(2, node_number);

    for i = 1 : length(t)
        for j = 1 : node_number
            a_new(:, j) = a(:, j);
            F_new(:, :, j) = F(:, :, j);

            current_u_human_predicted_new(j) = current_u_human_predicted(j);
            current_direction_human_predicted_new(:, j) = current_direction_human_predicted(:, j);

            current_u_animal_predicted_new(j) = current_u_animal_predicted(j);
            current_direction_animal_predicted_new(:, j) = current_direction_animal_predicted(:, j);

            for k = 1 : node_number
                if not(isnan(Z(1, j))) && not(isnan(Z(1, k)))  % Nodes without measurements do not share anything
                    if not(adjacency_matrix(j, k) == 0) && not(rand(1) < communication_failure_prob)
                        a_new(:, j) = a_new(:, j) + Q(j, k) .* (a(:, k) - a(:, j));
                        F_new(:, :, j) = F_new(:, :, j) + Q(j, k) .* (F(:, :, k) - F(:, :, j));
                    end
                end

                if not(isnan(current_u_human_predicted(j))) && not(isnan(current_direction_human_predicted(1, j))) && not(isnan(current_u_human_predicted(k))) && not(isnan(current_direction_human_predicted(1, k)))
                    if not(adjacency_matrix(j, k) == 0) && not(rand(1) < communication_failure_prob)
                        current_u_human_predicted_new(j) = current_u_human_predicted_new(j) + Q(j, k) .* (current_u_human_predicted(k) - current_u_human_predicted(j));
                        current_direction_human_predicted_new(:, j) = current_direction_human_predicted_new(:, j) + Q(j, k) .* (current_direction_human_predicted(:, k) - current_direction_human_predicted(:, j));
                    end
                end

                if not(isnan(current_u_animal_predicted(j))) && not(isnan(current_direction_animal_predicted(1, j))) && not(isnan(current_u_animal_predicted(k))) && not(isnan(current_direction_animal_predicted(1, k)))
                    if not(adjacency_matrix(j, k) == 0) && not(rand(1) < communication_failure_prob)
                        current_u_animal_predicted_new(j) = current_u_animal_predicted_new(j) + Q(j, k) .* (current_u_animal_predicted(k) - current_u_animal_predicted(j));
                        current_direction_animal_predicted_new(:, j) = current_direction_animal_predicted_new(:, j) + Q(j, k) .* (current_direction_animal_predicted(:, k) - current_direction_animal_predicted(:, j));
                    end
                end

                node_estimates_new(k, j) = node_estimates(k, j);
                for l = 1 : node_number
                    if not(isnan(Z(1, k))) && not(isnan(Z(1, l)))  % Nodes without measurements do not share anything
                        if not(adjacency_matrix(k, l) == 0) && not(rand(1) < communication_failure_prob)
                            node_estimates_new(k, j) = node_estimates_new(k, j) + Q(k, l) .* (node_estimates(l, j) - node_estimates(k, j));
                        end
                    end
                end
            end
        end

        % Store the updated values after the consensus iteration
        a = a_new;
        F = F_new;
        node_estimates = node_estimates_new;

        current_u_human_predicted = current_u_human_predicted_new;
        current_direction_human_predicted = current_direction_human_predicted_new;

        current_u_animal_predicted = current_u_animal_predicted_new;
        current_direction_animal_predicted = current_direction_animal_predicted_new;
    end

    u_human_predicted = current_u_human_predicted;
    direction_human_predicted = current_direction_human_predicted;

    u_animal_predicted = current_u_animal_predicted;
    direction_animal_predicted = current_direction_animal_predicted;

    for i = 1 : node_number - 1  % node_number - 1 handles the worst case scenario when only one node has a measurement
        for j = 1 : node_number
            % Share a and F to nodes that do not have them and let them to do the update step anyway using that information
            if not(isnan(a(1, j))) && not(isnan(F(1, 1, j)))
                for k = 1 : node_number
                    if not(adjacency_matrix(j, k) == 0) && not(rand(1) < communication_failure_prob)
                        if isnan(a(1, k)) && isnan(F(1, 1, k))
                            a(:, k) = a(:, j);
                            F(:, :, k) = F(:, :, j);
                            node_estimates(k, k) = node_estimates(j, j);
                        end
                    end
                end
            end
        end
    end

    % After the share of the knowledge, is someone does not have measurement means that no one has the measurement and the process will stop
    stop_the_process = 0;
    for i = 1 : node_number
        if isnan(a(1, k)) && isnan(F(1, 1, k))
            stop_the_process = 1;
            break
        end
    end
    if stop_the_process == 1
        break
    end

    % - Update step
    if iteration > min_iterations_for_delta
        for i = 1 : node_number
            if not(isnan(a(1, i))) && not(isnan(F(1, 1, i)))
                P_Kest1_pred = P_Kest1(:, :, i);
                P_Kest1(:, :, i) = inv(inv(P_Kest1_pred) + round(1 / node_estimates(i, i)) * F(:, :, i));
                p_Kest1(:, i) = p_Kest1(:, i) + P_Kest1_pred * (eye(2) - round(1 / node_estimates(i, i)) * F(:, :, i) * P_Kest1(:, :, i)) * (round(1 / node_estimates(i, i)) * a(:, i) - round(1 / node_estimates(i, i)) * F(:, :, i) * p_Kest1(:, i));
                % p_Kest1(:, i) = p_Kest1(:, i) + P_Kest1(:, :, i) * (a(:, i) - F(:, :, i) * p_Kest1(:, i));

                P_Kest2_pred = P_Kest2(:, :, i);
                P_Kest2(:, :, i) = inv(inv(P_Kest2_pred) + round(1 / node_estimates(i, i)) * F(:, :, i));
                p_Kest2(:, i) = p_Kest2(:, i) + P_Kest2_pred * (eye(2) - round(1 / node_estimates(i, i)) * F(:, :, i) * P_Kest2(:, :, i)) * (round(1 / node_estimates(i, i)) * a(:, i) - round(1 / node_estimates(i, i)) * F(:, :, i) * p_Kest2(:, i));
                % p_Kest2(:, i) = p_Kest2(:, i) + P_Kest2(:, :, i) * (a(:, i) - F(:, :, i) * p_Kest2(:, i));
            end

            if not(isnan(Z(1, i)))
                % Update probability of modes after update step
                regularization = initial_regularization;
                got_updated_probabilities = 0;
                prob_1_prev = prob_1(i);
                prob_2_prev = prob_2(i);
                while got_updated_probabilities == 0
                    try
                        prob_1(i) = mvnpdf(Z(:, i), p_Kest1(:, i), P_Kest1(:, :, i) + regularization * eye(2)) * prob_1_prev;
                        prob_2(i) = mvnpdf(Z(:, i), p_Kest2(:, i), P_Kest2(:, :, i) + regularization * eye(2)) * prob_2_prev;
                        got_updated_probabilities = 1;
                    catch
                        regularization = regularization + regularization_increase;
                    end
                end
                if (isnan(prob_1(i)) || prob_1(i) == 0) && (isnan(prob_2(i)) || prob_2(i) == 0)
                    prob_1(i) = 0.5;
                    prob_2(i) = 0.5;
                elseif isnan(prob_1(i))
                    prob_1(i) = 0;
                elseif isnan(prob_2(i))
                    prob_2(i) = 0;
                end
                norm_factor = prob_1(i) + prob_2(i);
                prob_1(i) = prob_1(i) / norm_factor;
                prob_2(i) = prob_2(i) / norm_factor;
            end
        end
    end

    % Combine mode-conditioned state estimate p_Kesti and covariances P_Kest after consensus to get the combined estimate
    p_Kest = zeros(2, node_number);
    for i = 1 : node_number
        p_Kest(:, i) = prob_1(i) * p_Kest1(:, i) + prob_2(i) * p_Kest2(:, i);
    end

    P_Kest = zeros(2, 2, node_number);
    for i = 1 : node_number
        P_Kest(:, :, i) = prob_1(i) * (P_Kest1(:, :, i) + (p_Kest1(:, i) - p_Kest(:, i)) * (p_Kest1(:, i) - p_Kest(:, i))') + p_Kest2(i) * (P_Kest2(:, :, i) + (p_Kest2(:, i) - p_Kest(:, i)) * (p_Kest2(:, i) - p_Kest(:, i))');
    end

    error_model_1 = norm(p - mean(p_Kest1, 2));
    error_model_2 = norm(p - mean(p_Kest2, 2));
    tracking_error_history1(iteration) = error_model_1;
    tracking_error_history2(iteration) = error_model_2;
    error_model_combined = norm(p - mean(p_Kest, 2));
    meaurements = 0;
    mean_z = zeros(2, 1);
    for i = 1 : node_number
        if not(isnan(Z(1, i)))
            meaurements = meaurements + 1;
            mean_z = mean_z + Z(:, i);
        end
    end
    mean_z = mean_z ./ meaurements;
    error_meaurements = norm(p - mean_z);
    tracking_error_historyZ(iteration) = error_meaurements;

    p1 = mean(prob_1);
    p2 = mean(prob_2);

    % Display error between real and estimated positions
    if use_logs == 1
        disp([13, 'Iteration: ', num2str(iteration)]);
        disp(['Norm of the Kalman filter 1 error: ', num2str(error_model_1), ' ', num2str(error_model_1 - error_meaurements), 9, ...
                'Norm of the Kalman filter 2 error: ', num2str(error_model_2), ' ', num2str(error_model_2 - error_meaurements)]);
    end

    % Display the probability that the entity is one of the models
    if use_logs == 1
        disp(['Probability of model 1: ', num2str(p1), 9, 9, 'Probability of model 2: ', num2str(p2)]);
    end

    % Display error between real and combined estimate position
    if use_logs == 1
        disp(['Norm of the combined estimate error: ', num2str(error_model_combined), ' ', num2str(error_model_combined - error_meaurements)]);
        disp(['Norm of the measument error: ', num2str(error_meaurements), ' with ', num2str(meaurements), ' meaurements']);
    end

    % Plot the points predicted by the kalman filters w.r.t. the correct one
    if use_plots == 1
        figure(fig_id1), clf, hold on;
        plt = plot(mean(p_Kest1(1, :)), mean(p_Kest1(2, :)), 'r.', p(1), p(2), 'g.', mean_z(1, 1), mean_z(2, 1), 'k.');
        plt(1).MarkerSize = 50;
        plt(2).MarkerSize = 20;
        lgd = legend('Kalman filter 1 estimate', 'Target');
        lgd.FontSize = 20;
        xlim([round(p_init(1)) - 750 round(p_init(1)) + 750]);
        ylim([round(p_init(2)) - 750 round(p_init(2)) + 750]);

        figure(fig_id2), clf, hold on;
        plt = plot(mean(p_Kest2(1, :)), mean(p_Kest2(2, :)), 'b.', p(1), p(2), 'g.', mean_z(1, 1), mean_z(2, 1), 'k.');
        plt(1).MarkerSize = 50;
        plt(2).MarkerSize = 20;
        lgd = legend('Kalman filter 2 estimate', 'Target');
        lgd.FontSize = 20;
        xlim([round(p_init(1)) - 750 round(p_init(1)) + 750]);
        ylim([round(p_init(2)) - 750 round(p_init(2)) + 750]);
    end

    % Plot the combined estimated point w.r.t. the correct one
    if use_plots == 1
        figure(fig_id_avg), clf, hold on;
        plt = plot(mean(p_Kest(1, :)), mean(p_Kest(2, :)), 'y.', p(1), p(2), 'g.', mean_z(1, 1), mean_z(2, 1), 'k.');
        plt(1).MarkerSize = 50;
        plt(2).MarkerSize = 20;
        lgd = legend('Combined estimate', 'Target');
        lgd.FontSize = 20;
        xlim([round(p_init(1)) - 750 round(p_init(1)) + 750]);
        ylim([round(p_init(2)) - 750 round(p_init(2)) + 750]);
        % pause(0.25);
    end
end
