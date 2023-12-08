clear all;
close all;
clc;

for run_index = 1 : 61

    number_of_experiments = 1000;

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

    initial_regularization = 0;
    regularization_increase = 1;
    use_plots = 0;
    use_logs = 0;

    % run_index == 1: dafault configuration, run final: [904,96;89,911]

    % Variation of node_number
    if run_index == 2                       % run final: [787,213;112,888]
        node_number = 15;
    elseif run_index == 3                   % run final: [878,122;97,903]
        node_number = 25;
    elseif run_index == 4                   % run final: [898,102;94,906]
        node_number = 75;
    elseif run_index == 5                   % run final: [885,115;86,914]
        node_number = 100;

    % Variation of communication and detection hyperparameters
    elseif run_index == 6                   % run final: [889,111;90,910]
        max_communication_range = 500000;
        communication_failure_prob = 0;
        max_detection_range = 500000;
        entity_misdetection_prob = 0;
    elseif run_index == 7                   % run final: [921,79;85,915]
        max_communication_range = 1000;
        communication_failure_prob = 0.001;
        max_detection_range = 500;
        entity_misdetection_prob = 0.001;
    elseif run_index == 8                   % run final: [454,546;156,844]
        max_communication_range = 250;
        communication_failure_prob = 0.1;
        max_detection_range = 125;
        entity_misdetection_prob = 0.1;

    % Variation of communication_failure_prob
    elseif run_index == 9                   % run final: [917,83;97,903]
        communication_failure_prob = 0;
    elseif run_index == 10                  % run final: [886,114;90,910]
        communication_failure_prob = 0.01;
    elseif run_index == 11                  % run final: [873,127;72,928]
        communication_failure_prob = 0.1;
    elseif run_index == 12                  % run final: [913,87;66,934]
        communication_failure_prob = 0.25;

    % Variation of entity_misdetection_prob
    elseif run_index == 13                  % run final: [885,115;82,918]
        entity_misdetection_prob = 0;
    elseif run_index == 14                  % run final: [911,89;84,916]
        entity_misdetection_prob = 0.01;
    elseif run_index == 15                  % run final: [932,68;103,897]
        entity_misdetection_prob = 0.1;
    elseif run_index == 16                  % run final: [960,40;134,866]
        entity_misdetection_prob = 0.25;
    
    % Variation of sigma_z_value
    elseif run_index == 17                  % run final: [732,268;162,838]
        sigma_z_value = 5;
    elseif run_index == 18                  % run final: [841,159;108,892]
        sigma_z_value = 10;
    elseif run_index == 19                  % run final: [853,147;87,913]
        sigma_z_value = 15;
    elseif run_index == 20                  % run final: [888,112;77,923]
        sigma_z_value = 20;
    elseif run_index == 21                  % run final: [913,87;91,909]
        sigma_z_value = 30;
    elseif run_index == 22                  % run final: [912,88;94,906]
        sigma_z_value = 35;

    % Variation of sigma_noise_human and sigma_noise_animal
    elseif run_index == 23                  % run final: [997,3;93,907]
        sigma_noise_human = 1;
        sigma_noise_animal = 1;
    elseif run_index == 24                  % run final: [1000,0;49,951]
        sigma_noise_human = 3;
        sigma_noise_animal = 3;
    elseif run_index == 25                  % run final: [996,4;42,958] (very good results)
        sigma_noise_human = 5;
        sigma_noise_animal = 5;
    elseif run_index == 26                  % run final: [944,56;43,957]
        sigma_noise_human = 7.5;
        sigma_noise_animal = 7.5;
    elseif run_index == 27                  % run final: [854,146;135,865]
        sigma_noise_human = 12.5;
        sigma_noise_animal = 12.5;
    elseif run_index == 28                  % run final: [763,237;179,821]
        sigma_noise_human = 15;
        sigma_noise_animal = 15;
    elseif run_index == 29                  % run final: [681,319;280,720]
        sigma_noise_human = 20;
        sigma_noise_animal = 20;
    elseif run_index == 30                  % run final: [643,357;364,636]
        sigma_noise_human = 25;
        sigma_noise_animal = 25;

    % Combination of measurement and model noises
    elseif run_index == 31                  % run final: [978,22;22,978]
        sigma_z_value = 10;
        sigma_noise_human = 5;
        sigma_noise_animal = 5;
    elseif run_index == 32                  % run final: [991,9;24,976] (very good results)
        sigma_z_value = 15;
        sigma_noise_human = 5;
        sigma_noise_animal = 5;
    elseif run_index == 33                  % run final: [991,9;29,971]
        sigma_z_value = 20;
        sigma_noise_human = 5;
        sigma_noise_animal = 5;
    elseif run_index == 34                  % run final: [993,7;46,954]
        sigma_z_value = 30;
        sigma_noise_human = 5;
        sigma_noise_animal = 5;
    elseif run_index == 35                  % run final: [938,62;51,949]
        sigma_z_value = 15;
        sigma_noise_human = 7.5;
        sigma_noise_animal = 7.5;
    elseif run_index == 36                  % run final: [948,52;46,954]
        sigma_z_value = 20;
        sigma_noise_human = 7.5;
        sigma_noise_animal = 7.5;
    elseif run_index == 37                  % run final: [960,40;58,942]
        sigma_z_value = 30;
        sigma_noise_human = 7.5;
        sigma_noise_animal = 7.5;

    % Variation of animal_change_direction_prob
    elseif run_index == 38                  % run final: [910,90;257,743]
        animal_change_direction_prob = 0.1;
    elseif run_index == 39                  % run final: [900,100;96,904]
        animal_change_direction_prob = 0.25;
    elseif run_index == 40                  % run final: [905,95;78,922]
        animal_change_direction_prob = 0.4;
    elseif run_index == 41                  % run final: [895,105;97,903]
        animal_change_direction_prob = 0.5;

    % Variation of the number of iterations
    elseif run_index == 42                  % run final: [641,359;329,671]
        iterations = 10;
    elseif run_index == 43                  % run final: [786,214;135,865]
        iterations = 20;
    elseif run_index == 44                  % run final: [940,60;54,946]
        iterations = 40;
    elseif run_index == 45                  % run final: [936,64;42,958]
        iterations = 50;

    % Variation of the number of min_iterations_for_delta
    elseif run_index == 46                  % run final: [842,158;63,937]
        min_iterations_for_delta = 2;
    elseif run_index == 47                  % run final: [895,105;61,939]
        min_iterations_for_delta = 3;
    elseif run_index == 48                  % run final: [839,161;85,915]
        min_iterations_for_delta = 7;
    elseif run_index == 49                  % run final: [792,208;90,910]
        min_iterations_for_delta = 8;

    % Combination of more parameters
    elseif run_index == 50                  % run final: [998,2;23,977]
        sigma_z_value = 1;
        sigma_noise_human = 1;
        sigma_noise_animal = 1;
    elseif run_index == 51                  % run final: [966,34;18,982]
        sigma_z_value = 3;
        sigma_noise_human = 3;
        sigma_noise_animal = 3;
    elseif run_index == 52                  % run final: [925,75;44,956]
        sigma_z_value = 5;
        sigma_noise_human = 5;
        sigma_noise_animal = 5;
    elseif run_index == 53                  % run final: [882,118;64,936]
        sigma_z_value = 7.5;
        sigma_noise_human = 7.5;
        sigma_noise_animal = 7.5;
    elseif run_index == 54                  % run final: [827,173;106,894]
        sigma_z_value = 10;
        sigma_noise_human = 10;
        sigma_noise_animal = 10;
    elseif run_index == 55                  % run final: [921,79;73,927]
        sigma_z_value = 5;
        sigma_noise_human = 5;
        sigma_noise_animal = 5;
        max_communication_range = 500000;
        communication_failure_prob = 0;
        max_detection_range = 500000;
        entity_misdetection_prob = 0;
    elseif run_index == 56                  % run final: [836,164;121,879]
        sigma_z_value = 7.5;
        sigma_noise_human = 7.5;
        sigma_noise_animal = 7.5;
        max_communication_range = 500000;
        communication_failure_prob = 0;
        max_detection_range = 500000;
        entity_misdetection_prob = 0;
    elseif run_index == 57                  % run final: [763,237;168,832]
        sigma_z_value = 10;
        sigma_noise_human = 10;
        sigma_noise_animal = 10;
        max_communication_range = 500000;
        communication_failure_prob = 0;
        max_detection_range = 500000;
        entity_misdetection_prob = 0;
    elseif run_index == 58                  % run final: [990,10;35,965]
        sigma_z_value = 10;
        sigma_noise_human = 5;
        sigma_noise_animal = 5;
        max_communication_range = 500000;
        communication_failure_prob = 0;
        max_detection_range = 500000;
        entity_misdetection_prob = 0;
    elseif run_index == 59                  % run final: [1000,0;27,973] (very good results)
        sigma_z_value = 15;
        sigma_noise_human = 5;
        sigma_noise_animal = 5;
        max_communication_range = 500000;
        communication_failure_prob = 0;
        max_detection_range = 500000;
        entity_misdetection_prob = 0;
    elseif run_index == 60                  % run final: [999,1;34,966]
        sigma_z_value = 20;
        sigma_noise_human = 5;
        sigma_noise_animal = 5;
        max_communication_range = 500000;
        communication_failure_prob = 0;
        max_detection_range = 500000;
        entity_misdetection_prob = 0;
    elseif run_index == 61                  % run final: [1000,0;16,984] (very good results)
        sigma_z_value = 1;
        sigma_noise_human = 1;
        sigma_noise_animal = 1;
        max_communication_range = 500000;
        communication_failure_prob = 0;
        max_detection_range = 500000;
        entity_misdetection_prob = 0;
    end

    disp(['Run index: ', num2str(run_index)]);

    % Store results
    true_animal = 0;
    false_animal = 0;
    true_human = 0;
    false_human = 0;

    error_model_1_human = zeros(number_of_experiments, 1);
    error_model_2_human = zeros(number_of_experiments, 1);
    error_model_combined_human = zeros(number_of_experiments, 1);
    p1_human = zeros(number_of_experiments, 1);
    p2_human = zeros(number_of_experiments, 1);
    adjacency_matrix_human = zeros(node_number, node_number, number_of_experiments);
    tracking_error_history1_human = NaN(number_of_experiments, iterations);
    tracking_error_history2_human = NaN(number_of_experiments, iterations);
    tracking_error_historyZ_human = NaN(number_of_experiments, iterations);

    disp('Launching human model');
    for i = 1 : number_of_experiments
        use_animal_dynamics = 0;            % Use the human dynamics for the entity moving in the area
        try
            [p1, p2, error_model_combined, error_model_1, error_model_2, adjacency_matrix, tracking_error_history1, tracking_error_history2, tracking_error_historyZ] = main(...
                node_number, max_communication_range, communication_failure_prob, ...
                sigma_z_value, max_detection_range, entity_misdetection_prob, ...
                sigma_noise_human, sigma_noise_animal, animal_change_direction_prob, ...
                use_animal_dynamics, iterations, min_iterations_for_delta, animal_model_scaling_factor, ...
                initial_regularization, regularization_increase, use_plots, use_logs);
        catch
            p1 = NaN(1);
            p2 = NaN(1);
            error_model_combined = NaN(1);
            error_model_1 = NaN(1);
            error_model_2 = NaN(1);
        end

        tracking_error_history1_human(i, :) = tracking_error_history1;
        tracking_error_history2_human(i, :) = tracking_error_history2;
        tracking_error_historyZ_human(i, :) = tracking_error_historyZ;
        error_model_1_human(i) = error_model_1;
        error_model_2_human(i) = error_model_2;
        error_model_combined_human(i) = error_model_combined;
        p1_human(i) = p1;
        p2_human(i) = p2;
        adjacency_matrix_human(:, :, i) = adjacency_matrix;

        if p1 > p2
            true_human = true_human + 1;
        else
            false_animal = false_animal + 1;
        end
        disp(['Experiment: ', num2str(i), 9, 9, 'Prob human: ', num2str(p1), 9, 9, 'Prob animal: ', num2str(p2)]);
    end

    error_model_1_animal = zeros(number_of_experiments, 1);
    error_model_2_animal = zeros(number_of_experiments, 1);
    error_model_combined_animal = zeros(number_of_experiments, 1);
    p1_animal = zeros(number_of_experiments, 1);
    p2_animal = zeros(number_of_experiments, 1);
    adjacency_matrix_animal = zeros(node_number, node_number, number_of_experiments);
    tracking_error_history1_animal = NaN(number_of_experiments, iterations);
    tracking_error_history2_animal = NaN(number_of_experiments, iterations);
    tracking_error_historyZ_animal = NaN(number_of_experiments, iterations);

    disp('Launching animal model');
    for i = 1 : number_of_experiments
        use_animal_dynamics = 1;            % Use the animal dynamics for the entity moving in the area
        try
            [p1, p2, error_model_combined, error_model_1, error_model_2, adjacency_matrix, tracking_error_history1, tracking_error_history2, tracking_error_historyZ] = main(...
                node_number, max_communication_range, communication_failure_prob, ...
                sigma_z_value, max_detection_range, entity_misdetection_prob, ...
                sigma_noise_human, sigma_noise_animal, animal_change_direction_prob, ...
                use_animal_dynamics, iterations, min_iterations_for_delta, animal_model_scaling_factor, ...
                initial_regularization, regularization_increase, use_plots, use_logs);
        catch
            p1 = NaN(1);
            p2 = NaN(1);
            error_model_combined = NaN(1);
            error_model_1 = NaN(1);
            error_model_2 = NaN(1);
        end

        tracking_error_history1_animal(i, :) = tracking_error_history1;
        tracking_error_history2_animal(i, :) = tracking_error_history2;
        tracking_error_historyZ_animal(i, :) = tracking_error_historyZ;
        error_model_1_animal(i) = error_model_1;
        error_model_2_animal(i) = error_model_2;
        error_model_combined_animal(i) = error_model_combined;
        p1_animal(i) = p1;
        p2_animal(i) = p2;
        adjacency_matrix_animal(:, :, i) = adjacency_matrix;

        if p1 > p2
            false_human = false_human + 1;
        else
            true_animal = true_animal + 1;
        end
        disp(['Experiment: ', num2str(i), 9, 9, 'Prob human: ', num2str(p1), 9, 9, 'Prob animal: ', num2str(p2)]);
    end

    mean_p1_human = mean(p1_human, 'omitnan');
    std_p1_human = std(p1_human, 'omitnan');
    mean_p1_animal = mean(p1_animal, 'omitnan');
    std_p1_animal = std(p1_animal, 'omitnan');

    mean_p2_animal = mean(p2_animal, 'omitnan');
    std_p2_animal = std(p2_animal, 'omitnan');
    mean_p2_human = mean(p2_human, 'omitnan');
    std_p2_human = std(p2_human, 'omitnan');

    mean_error_model_1_human = mean(error_model_1_human, 'omitnan');
    std_error_model_1_human = std(error_model_1_human, 'omitnan');
    mean_error_model_1_animal = mean(error_model_1_animal, 'omitnan');
    std_error_model_1_animal = std(error_model_1_animal, 'omitnan');

    mean_error_model_2_human = mean(error_model_2_human, 'omitnan');
    std_error_model_2_human = std(error_model_2_human, 'omitnan');
    mean_error_model_2_animal = mean(error_model_2_animal, 'omitnan');
    std_error_model_2_animal = std(error_model_2_animal, 'omitnan');

    mean_error_model_combined_human = mean(error_model_combined_human, 'omitnan');
    std_error_model_combined_human = std(error_model_combined_human, 'omitnan');
    mean_error_model_combined_animal = mean(error_model_combined_animal, 'omitnan');
    std_error_model_combined_animal = std(error_model_combined_animal, 'omitnan');
    
    % Display results
    confusion_matrix = [true_human, false_animal; false_human, true_animal];
    disp('Confusion matrix');
    disp(confusion_matrix);

    % Save results
    save("data/data" + num2str(run_index) + "_final_test.mat");
end
