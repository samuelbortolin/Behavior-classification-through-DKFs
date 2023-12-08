clear all;
close all;
clc;

fig_id = 0;
set(0, 'DefaultTextInterpreter', 'none');

%% Plot iterations

X_human_array = zeros(5, 1);
X_animal_array = zeros(5, 1);
Y_human_array = zeros(5, 1);
Y_animal_array = zeros(5, 1);
Y_error_human = zeros(5, 1);
Y_error_animal = zeros(5, 1);
Y_prob_human = zeros(5, 1);
Y_prob_animal = zeros(5, 1);

load("data/data1_final_test.mat");
X_human_array(1) = iterations;
X_animal_array(1) = iterations;
Y_human_array(1) = true_human / 10;
Y_animal_array(1) = true_animal / 10;
Y_error_human(1) = mean_error_model_1_human;
Y_error_animal(1) = mean_error_model_2_animal;
Y_prob_human(1) = mean_p1_human;
Y_prob_animal(1) = mean_p2_animal;

for file_number = 2 : 5
    load("data/data" + (file_number + 40) + "_final_test.mat");
    X_human_array(file_number) = iterations;
    X_animal_array(file_number) = iterations;
    Y_human_array(file_number) = true_human / 10;
    Y_animal_array(file_number) = true_animal / 10;
    Y_error_human(file_number) = mean_error_model_1_human;
    Y_error_animal(file_number) = mean_error_model_2_animal;
    Y_prob_human(file_number) = mean_p1_human;
    Y_prob_animal(file_number) = mean_p2_animal;
end

fig_id = fig_id + 1;
figure(fig_id), clf, hold on;
plt = plot(X_human_array, Y_human_array, "r+", X_animal_array, Y_animal_array, "bx");
xlim([0, 60]);
ylim([50, 100]);
xlabel('iterations');
ylabel('Accuracy per class [%]');
plt(1).MarkerSize = 10;
plt(1).LineWidth = 2;
plt(2).MarkerSize = 10;
plt(2).LineWidth = 2;
lgd = legend("human", "animal");
lgd.FontSize = 10;

fig_id = fig_id + 1;
figure(fig_id), clf, hold on;
plt = plot(X_human_array, Y_error_human, "r+", X_animal_array, Y_error_animal, "bx");
xlim([0, 60]);
ylim([0, 50]);
xlabel('iterations');
ylabel('Tracking error per class [m]');
plt(1).MarkerSize = 10;
plt(1).LineWidth = 2;
plt(2).MarkerSize = 10;
plt(2).LineWidth = 2;
lgd = legend("human", "animal");
lgd.FontSize = 10;

fig_id = fig_id + 1;
figure(fig_id), clf, hold on;
plt = plot(X_human_array, Y_prob_human, "r+", X_animal_array, Y_prob_animal, "bx");
xlim([0, 60]);
ylim([0.4, 0.8]);
xlabel('iterations');
ylabel('Confidence per class');
plt(1).MarkerSize = 10;
plt(1).LineWidth = 2;
plt(2).MarkerSize = 10;
plt(2).LineWidth = 2;
lgd = legend("human", "animal");
lgd.FontSize = 10;

%% Plot min_iterations_for_delta

X_human_array = zeros(5, 1);
X_animal_array = zeros(5, 1);
Y_human_array = zeros(5, 1);
Y_animal_array = zeros(5, 1);
Y_error_human = zeros(5, 1);
Y_error_animal = zeros(5, 1);
Y_prob_human = zeros(5, 1);
Y_prob_animal = zeros(5, 1);

load("data/data1_final_test.mat");
X_human_array(1) = min_iterations_for_delta;
X_animal_array(1) = min_iterations_for_delta;
Y_human_array(1) = true_human / 10;
Y_animal_array(1) = true_animal / 10;
Y_error_human(1) = mean_error_model_1_human;
Y_error_animal(1) = mean_error_model_2_animal;
Y_prob_human(1) = mean_p1_human;
Y_prob_animal(1) = mean_p2_animal;

for file_number = 2 : 5
    load("data/data" + (file_number + 44) + "_final_test.mat");
    X_human_array(file_number) = min_iterations_for_delta;
    X_animal_array(file_number) = min_iterations_for_delta;
    Y_human_array(file_number) = true_human / 10;
    Y_animal_array(file_number) = true_animal / 10;
    Y_error_human(file_number) = mean_error_model_1_human;
    Y_error_animal(file_number) = mean_error_model_2_animal;
    Y_prob_human(file_number) = mean_p1_human;
    Y_prob_animal(file_number) = mean_p2_animal;
end

fig_id = fig_id + 1;
figure(fig_id), clf, hold on;
plt = plot(X_human_array, Y_human_array, "r+", X_animal_array, Y_animal_array, "bx");
xlim([1, 9]);
ylim([50, 100]);
xlabel('min_iterations_for_delta');
ylabel('Accuracy per class [%]');
plt(1).MarkerSize = 10;
plt(1).LineWidth = 2;
plt(2).MarkerSize = 10;
plt(2).LineWidth = 2;
lgd = legend("human", "animal");
lgd.FontSize = 10;

fig_id = fig_id + 1;
figure(fig_id), clf, hold on;
plt = plot(X_human_array, Y_error_human, "r+", X_animal_array, Y_error_animal, "bx");
xlim([1, 9]);
ylim([0, 50]);
xlabel('min_iterations_for_delta');
ylabel('Tracking error per class [m]');
plt(1).MarkerSize = 10;
plt(1).LineWidth = 2;
plt(2).MarkerSize = 10;
plt(2).LineWidth = 2;
lgd = legend("human", "animal");
lgd.FontSize = 10;

fig_id = fig_id + 1;
figure(fig_id), clf, hold on;
plt = plot(X_human_array, Y_prob_human, "r+", X_animal_array, Y_prob_animal, "bx");
xlim([1, 9]);
ylim([0.4, 0.8]);
xlabel('min_iterations_for_delta');
ylabel('Confidence per class');
plt(1).MarkerSize = 10;
plt(1).LineWidth = 2;
plt(2).MarkerSize = 10;
plt(2).LineWidth = 2;
lgd = legend("human", "animal");
lgd.FontSize = 10;

%% Plot communication_failure_prob

X_human_array = zeros(5, 1);
X_animal_array = zeros(5, 1);
Y_human_array = zeros(5, 1);
Y_animal_array = zeros(5, 1);
Y_error_human = zeros(5, 1);
Y_error_animal = zeros(5, 1);
Y_prob_human = zeros(5, 1);
Y_prob_animal = zeros(5, 1);

load("data/data1_final_test.mat");
X_human_array(1) = communication_failure_prob;
X_animal_array(1) = communication_failure_prob;
Y_human_array(1) = true_human / 10;
Y_animal_array(1) = true_animal / 10;
Y_error_human(1) = mean_error_model_1_human;
Y_error_animal(1) = mean_error_model_2_animal;
Y_prob_human(1) = mean_p1_human;
Y_prob_animal(1) = mean_p2_animal;

for file_number = 2 : 5
    load("data/data" + (file_number + 7) + "_final_test.mat");
    X_human_array(file_number) = communication_failure_prob;
    X_animal_array(file_number) = communication_failure_prob;
    Y_human_array(file_number) = true_human / 10;
    Y_animal_array(file_number) = true_animal / 10;
    Y_error_human(file_number) = mean_error_model_1_human;
    Y_error_animal(file_number) = mean_error_model_2_animal;
    Y_prob_human(file_number) = mean_p1_human;
    Y_prob_animal(file_number) = mean_p2_animal;
end

fig_id = fig_id + 1;
figure(fig_id), clf, hold on;
plt = plot(X_human_array, Y_human_array, "r+", X_animal_array, Y_animal_array, "bx");
xlim([- 0.05, 0.3]);
ylim([50, 100]);
xlabel('communication_failure_prob');
ylabel('Accuracy per class [%]');
plt(1).MarkerSize = 10;
plt(1).LineWidth = 2;
plt(2).MarkerSize = 10;
plt(2).LineWidth = 2;
lgd = legend("human", "animal");
lgd.FontSize = 10;

fig_id = fig_id + 1;
figure(fig_id), clf, hold on;
plt = plot(X_human_array, Y_error_human, "r+", X_animal_array, Y_error_animal, "bx");
xlim([- 0.05, 0.3]);
ylim([0, 50]);
xlabel('communication_failure_prob');
ylabel('Tracking error per class [m]');
plt(1).MarkerSize = 10;
plt(1).LineWidth = 2;
plt(2).MarkerSize = 10;
plt(2).LineWidth = 2;
lgd = legend("human", "animal");
lgd.FontSize = 10;

fig_id = fig_id + 1;
figure(fig_id), clf, hold on;
plt = plot(X_human_array, Y_prob_human, "r+", X_animal_array, Y_prob_animal, "bx");
xlim([- 0.05, 0.3]);
ylim([0.4, 0.8]);
xlabel('communication_failure_prob');
ylabel('Confidence per class');
plt(1).MarkerSize = 10;
plt(1).LineWidth = 2;
plt(2).MarkerSize = 10;
plt(2).LineWidth = 2;
lgd = legend("human", "animal");
lgd.FontSize = 10;

%% Plot entity_misdetection_prob

X_human_array = zeros(5, 1);
X_animal_array = zeros(5, 1);
Y_human_array = zeros(5, 1);
Y_animal_array = zeros(5, 1);
Y_error_human = zeros(5, 1);
Y_error_animal = zeros(5, 1);
Y_prob_human = zeros(5, 1);
Y_prob_animal = zeros(5, 1);

load("data/data1_final_test.mat");
X_human_array(1) = entity_misdetection_prob;
X_animal_array(1) = entity_misdetection_prob;
Y_human_array(1) = true_human / 10;
Y_animal_array(1) = true_animal / 10;
Y_error_human(1) = mean_error_model_1_human;
Y_error_animal(1) = mean_error_model_2_animal;
Y_prob_human(1) = mean_p1_human;
Y_prob_animal(1) = mean_p2_animal;

for file_number = 2 : 5
    load("data/data" + (file_number + 11) + "_final_test.mat");
    X_human_array(file_number) = entity_misdetection_prob;
    X_animal_array(file_number) = entity_misdetection_prob;
    Y_human_array(file_number) = true_human / 10;
    Y_animal_array(file_number) = true_animal / 10;
    Y_error_human(file_number) = mean_error_model_1_human;
    Y_error_animal(file_number) = mean_error_model_2_animal;
    Y_prob_human(file_number) = mean_p1_human;
    Y_prob_animal(file_number) = mean_p2_animal;
end

fig_id = fig_id + 1;
figure(fig_id), clf, hold on;
plt = plot(X_human_array, Y_human_array, "r+", X_animal_array, Y_animal_array, "bx");
xlim([- 0.05, 0.3]);
ylim([50, 100]);
xlabel('entity_misdetection_prob');
ylabel('Accuracy per class [%]');
plt(1).MarkerSize = 10;
plt(1).LineWidth = 2;
plt(2).MarkerSize = 10;
plt(2).LineWidth = 2;
lgd = legend("human", "animal");
lgd.FontSize = 10;

fig_id = fig_id + 1;
figure(fig_id), clf, hold on;
plt = plot(X_human_array, Y_error_human, "r+", X_animal_array, Y_error_animal, "bx");
xlim([- 0.05, 0.3]);
ylim([0, 50]);
xlabel('entity_misdetection_prob');
ylabel('Tracking error per class [m]');
plt(1).MarkerSize = 10;
plt(1).LineWidth = 2;
plt(2).MarkerSize = 10;
plt(2).LineWidth = 2;
lgd = legend("human", "animal");
lgd.FontSize = 10;

fig_id = fig_id + 1;
figure(fig_id), clf, hold on;
plt = plot(X_human_array, Y_prob_human, "r+", X_animal_array, Y_prob_animal, "bx");
xlim([- 0.05, 0.3]);
ylim([0.4, 0.8]);
xlabel('entity_misdetection_prob');
ylabel('Confidence per class');
plt(1).MarkerSize = 10;
plt(1).LineWidth = 2;
plt(2).MarkerSize = 10;
plt(2).LineWidth = 2;
lgd = legend("human", "animal");
lgd.FontSize = 10;

%% Plot animal_change_direction_prob

X_human_array = zeros(5, 1);
X_animal_array = zeros(5, 1);
Y_human_array = zeros(5, 1);
Y_animal_array = zeros(5, 1);
Y_error_human = zeros(5, 1);
Y_error_animal = zeros(5, 1);
Y_prob_human = zeros(5, 1);
Y_prob_animal = zeros(5, 1);

load("data/data1_final_test.mat");
X_human_array(1) = animal_change_direction_prob;
X_animal_array(1) = animal_change_direction_prob;
Y_human_array(1) = true_human / 10;
Y_animal_array(1) = true_animal / 10;
Y_error_human(1) = mean_error_model_1_human;
Y_error_animal(1) = mean_error_model_2_animal;
Y_prob_human(1) = mean_p1_human;
Y_prob_animal(1) = mean_p2_animal;

for file_number = 2 : 5
    load("data/data" + (file_number + 36) + "_final_test.mat");
    X_human_array(file_number) = animal_change_direction_prob;
    X_animal_array(file_number) = animal_change_direction_prob;
    Y_human_array(file_number) = true_human / 10;
    Y_animal_array(file_number) = true_animal / 10;
    Y_error_human(file_number) = mean_error_model_1_human;
    Y_error_animal(file_number) = mean_error_model_2_animal;
    Y_prob_human(file_number) = mean_p1_human;
    Y_prob_animal(file_number) = mean_p2_animal;
end

fig_id = fig_id + 1;
figure(fig_id), clf, hold on;
plt = plot(X_human_array, Y_human_array, "r+", X_animal_array, Y_animal_array, "bx");
xlim([0, 0.6]);
ylim([50, 100]);
xlabel('animal_change_direction_prob');
ylabel('Accuracy per class [%]');
plt(1).MarkerSize = 10;
plt(1).LineWidth = 2;
plt(2).MarkerSize = 10;
plt(2).LineWidth = 2;
lgd = legend("human", "animal");
lgd.FontSize = 10;

fig_id = fig_id + 1;
figure(fig_id), clf, hold on;
plt = plot(X_human_array, Y_error_human, "r+", X_animal_array, Y_error_animal, "bx");
xlim([0, 0.6]);
ylim([0, 50]);
xlabel('animal_change_direction_prob');
ylabel('Tracking error per class [m]');
plt(1).MarkerSize = 10;
plt(1).LineWidth = 2;
plt(2).MarkerSize = 10;
plt(2).LineWidth = 2;
lgd = legend("human", "animal");
lgd.FontSize = 10;

fig_id = fig_id + 1;
figure(fig_id), clf, hold on;
plt = plot(X_human_array, Y_prob_human, "r+", X_animal_array, Y_prob_animal, "bx");
xlim([0, 0.6]);
ylim([0.4, 0.8]);
xlabel('animal_change_direction_prob');
ylabel('Confidence per class');
plt(1).MarkerSize = 10;
plt(1).LineWidth = 2;
plt(2).MarkerSize = 10;
plt(2).LineWidth = 2;
lgd = legend("human", "animal");
lgd.FontSize = 10;

%% Polt tracking error through execution

load("data/data1_final_test.mat");
X_human_array = 1:iterations;
X_animal_array = 1:iterations;
X_measurement_array = 1:iterations;
Y_human_array = mean(tracking_error_history1_human, 'omitnan');
Y_animal_array = mean(tracking_error_history2_animal, 'omitnan');
Y_measurement_array = mean(tracking_error_historyZ_animal, 'omitnan');

fig_id = fig_id + 1;
figure(fig_id), clf, hold on;
plt = plot(X_human_array, Y_human_array, "r-", X_animal_array, Y_animal_array, "b-", X_measurement_array, Y_measurement_array, "k-");
xlim([0, iterations + 1]);
ylim([0, 200]);
xlabel('iteration index');
ylabel('Error between model and true position');
plt(1).MarkerSize = 10;
plt(1).LineWidth = 2;
plt(2).MarkerSize = 10;
plt(2).LineWidth = 2;
plt(3).MarkerSize = 10;
plt(3).LineWidth = 2;
lgd = legend("human", "animal", "measurements");
lgd.FontSize = 10;


load("data/data17_final_test.mat");
X_human_array = 1:iterations;
X_animal_array = 1:iterations;
X_measurement_array = 1:iterations;
Y_human_array = mean(tracking_error_history1_human, 'omitnan');
Y_animal_array = mean(tracking_error_history2_animal, 'omitnan');
Y_measurement_array = mean(tracking_error_historyZ_animal, 'omitnan');

fig_id = fig_id + 1;
figure(fig_id), clf, hold on;
plt = plot(X_human_array, Y_human_array, "r-", X_animal_array, Y_animal_array, "b-", X_measurement_array, Y_measurement_array, "k-");
xlim([0, iterations + 1]);
ylim([0, 200]);
xlabel('iteration index');
ylabel('Error between model and true position');
plt(1).MarkerSize = 10;
plt(1).LineWidth = 2;
plt(2).MarkerSize = 10;
plt(2).LineWidth = 2;
plt(3).MarkerSize = 10;
plt(3).LineWidth = 2;
lgd = legend("human", "animal", "measurements");
lgd.FontSize = 10;

load("data/data45_final_test.mat");
X_human_array = 1:iterations;
X_animal_array = 1:iterations;
X_measurement_array = 1:iterations;
Y_human_array = mean(tracking_error_history1_human, 'omitnan');
Y_animal_array = mean(tracking_error_history2_animal, 'omitnan');
Y_measurement_array = mean(tracking_error_historyZ_animal, 'omitnan');

fig_id = fig_id + 1;
figure(fig_id), clf, hold on;
plt = plot(X_human_array, Y_human_array, "r-", X_animal_array, Y_animal_array, "b-", X_measurement_array, Y_measurement_array, "k-");
xlim([0, iterations + 1]);
ylim([0, 200]);
xlabel('iteration index');
ylabel('Error between model and true position');
plt(1).MarkerSize = 10;
plt(1).LineWidth = 2;
plt(2).MarkerSize = 10;
plt(2).LineWidth = 2;
plt(3).MarkerSize = 10;
plt(3).LineWidth = 2;
lgd = legend("human", "animal", "measurements");
lgd.FontSize = 10;

load("data/data59_final_test.mat");
X_human_array = 1:iterations;
X_animal_array = 1:iterations;
X_measurement_array = 1:iterations;
Y_human_array = mean(tracking_error_history1_human, 'omitnan');
Y_animal_array = mean(tracking_error_history2_animal, 'omitnan');
Y_measurement_array = mean(tracking_error_historyZ_animal, 'omitnan');

fig_id = fig_id + 1;
figure(fig_id), clf, hold on;
plt = plot(X_human_array, Y_human_array, "r-", X_animal_array, Y_animal_array, "b-", X_measurement_array, Y_measurement_array, "k-");
xlim([0, iterations + 1]);
ylim([0, 200]);
xlabel('iteration index');
ylabel('Error between model and true position');
plt(1).MarkerSize = 10;
plt(1).LineWidth = 2;
plt(2).MarkerSize = 10;
plt(2).LineWidth = 2;
plt(3).MarkerSize = 10;
plt(3).LineWidth = 2;
lgd = legend("human", "animal", "measurements");
lgd.FontSize = 10;

load("data/data61_final_test.mat");
X_human_array = 1:iterations;
X_animal_array = 1:iterations;
X_measurement_array = 1:iterations;
Y_human_array = mean(tracking_error_history1_human, 'omitnan');
Y_animal_array = mean(tracking_error_history2_animal, 'omitnan');
Y_measurement_array = mean(tracking_error_historyZ_animal, 'omitnan');

fig_id = fig_id + 1;
figure(fig_id), clf, hold on;
plt = plot(X_human_array, Y_human_array, "r-", X_animal_array, Y_animal_array, "b-", X_measurement_array, Y_measurement_array, "k-");
xlim([0, iterations + 1]);
ylim([0, 200]);
xlabel('iteration index');
ylabel('Error between model and true position');
plt(1).MarkerSize = 10;
plt(1).LineWidth = 2;
plt(2).MarkerSize = 10;
plt(2).LineWidth = 2;
plt(3).MarkerSize = 10;
plt(3).LineWidth = 2;
lgd = legend("human", "animal", "measurements");
lgd.FontSize = 10;

%% Plot node_number

X_human_array = zeros(5, 1);
X_animal_array = zeros(5, 1);
Y_human_array = zeros(5, 1);
Y_animal_array = zeros(5, 1);
Y_error_human = zeros(5, 1);
Y_error_animal = zeros(5, 1);
Y_prob_human = zeros(5, 1);
Y_prob_animal = zeros(5, 1);

load("data/data1_final_test.mat");
X_human_array(1) = node_number;
X_animal_array(1) = node_number;
Y_human_array(1) = true_human / 10;
Y_animal_array(1) = true_animal / 10;
Y_error_human(1) = mean_error_model_1_human;
Y_error_animal(1) = mean_error_model_2_animal;
Y_prob_human(1) = mean_p1_human;
Y_prob_animal(1) = mean_p2_animal;

for file_number = 2 : 5
    load("data/data" + file_number + "_final_test.mat");
    X_human_array(file_number) = node_number;
    X_animal_array(file_number) = node_number;
    Y_human_array(file_number) = true_human / 10;
    Y_animal_array(file_number) = true_animal / 10;
    Y_error_human(file_number) = mean_error_model_1_human;
    Y_error_animal(file_number) = mean_error_model_2_animal;
    Y_prob_human(file_number) = mean_p1_human;
    Y_prob_animal(file_number) = mean_p2_animal;
end

fig_id = fig_id + 1;
figure(fig_id), clf, hold on;
plt = plot(X_human_array, Y_human_array, "r+", X_animal_array, Y_animal_array, "bx");
xlim([0, 115]);
ylim([50, 100]);
xlabel('node_number');
ylabel('Accuracy per class [%]');
plt(1).MarkerSize = 10;
plt(1).LineWidth = 2;
plt(2).MarkerSize = 10;
plt(2).LineWidth = 2;
lgd = legend("human", "animal");
lgd.FontSize = 10;

fig_id = fig_id + 1;
figure(fig_id), clf, hold on;
plt = plot(X_human_array, Y_error_human, "r+", X_animal_array, Y_error_animal, "bx");
xlim([0, 115]);
ylim([0, 50]);
xlabel('node_number');
ylabel('Tracking error per class [m]');
plt(1).MarkerSize = 10;
plt(1).LineWidth = 2;
plt(2).MarkerSize = 10;
plt(2).LineWidth = 2;
lgd = legend("human", "animal");
lgd.FontSize = 10;

fig_id = fig_id + 1;
figure(fig_id), clf, hold on;
plt = plot(X_human_array, Y_prob_human, "r+", X_animal_array, Y_prob_animal, "bx");
xlim([0, 115]);
ylim([0.4, 0.8]);
xlabel('node_number');
ylabel('Confidence per class');
plt(1).MarkerSize = 10;
plt(1).LineWidth = 2;
plt(2).MarkerSize = 10;
plt(2).LineWidth = 2;
lgd = legend("human", "animal");
lgd.FontSize = 10;

%% Plot sigma_z_value

X_human_array = zeros(7, 1);
X_animal_array = zeros(7, 1);
Y_human_array = zeros(7, 1);
Y_animal_array = zeros(7, 1);
Y_error_human = zeros(7, 1);
Y_error_animal = zeros(7, 1);
Y_prob_human = zeros(7, 1);
Y_prob_animal = zeros(7, 1);

load("data/data1_final_test.mat");
X_human_array(1) = sigma_z_value;
X_animal_array(1) = sigma_z_value;
Y_human_array(1) = true_human / 10;
Y_animal_array(1) = true_animal / 10;
Y_error_human(1) = mean_error_model_1_human;
Y_error_animal(1) = mean_error_model_2_animal;
Y_prob_human(1) = mean_p1_human;
Y_prob_animal(1) = mean_p2_animal;

for file_number = 2 : 7
    load("data/data" + (file_number + 15) + "_final_test.mat");
    X_human_array(file_number) = sigma_z_value;
    X_animal_array(file_number) = sigma_z_value;
    Y_human_array(file_number) = true_human / 10;
    Y_animal_array(file_number) = true_animal / 10;
    Y_error_human(file_number) = mean_error_model_1_human;
    Y_error_animal(file_number) = mean_error_model_2_animal;
    Y_prob_human(file_number) = mean_p1_human;
    Y_prob_animal(file_number) = mean_p2_animal;
end

fig_id = fig_id + 1;
figure(fig_id), clf, hold on;
plt = plot(X_human_array, Y_human_array, "r+", X_animal_array, Y_animal_array, "bx");
xlim([0, 40]);
ylim([50, 100]);
xlabel('sigma_z_value [m]');
ylabel('Accuracy per class [%]');
plt(1).MarkerSize = 10;
plt(1).LineWidth = 2;
plt(2).MarkerSize = 10;
plt(2).LineWidth = 2;
lgd = legend("human", "animal");
lgd.FontSize = 10;

fig_id = fig_id + 1;
figure(fig_id), clf, hold on;
plt = plot(X_human_array, Y_error_human, "r+", X_animal_array, Y_error_animal, "bx");
xlim([0, 40]);
ylim([0, 50]);
xlabel('sigma_z_value [m]');
ylabel('Tracking error per class [m]');
plt(1).MarkerSize = 10;
plt(1).LineWidth = 2;
plt(2).MarkerSize = 10;
plt(2).LineWidth = 2;
lgd = legend("human", "animal");
lgd.FontSize = 10;

fig_id = fig_id + 1;
figure(fig_id), clf, hold on;
plt = plot(X_human_array, Y_prob_human, "r+", X_animal_array, Y_prob_animal, "bx");
xlim([0, 40]);
ylim([0.4, 0.8]);
xlabel('sigma_z_value [m]');
ylabel('Confidence per class');
plt(1).MarkerSize = 10;
plt(1).LineWidth = 2;
plt(2).MarkerSize = 10;
plt(2).LineWidth = 2;
lgd = legend("human", "animal");
lgd.FontSize = 10;

%% Plot sigma_noise_human & sigma_noise_animal

X_human_array = zeros(9, 1);
X_animal_array = zeros(9, 1);
Y_human_array = zeros(9, 1);
Y_animal_array = zeros(9, 1);
Y_error_human = zeros(9, 1);
Y_error_animal = zeros(9, 1);
Y_prob_human = zeros(9, 1);
Y_prob_animal = zeros(9, 1);

load("data/data1_final_test.mat");
X_human_array(1) = sigma_noise_human;
X_animal_array(1) = sigma_noise_human;
Y_human_array(1) = true_human / 10;
Y_animal_array(1) = true_animal / 10;
Y_error_human(1) = mean_error_model_1_human;
Y_error_animal(1) = mean_error_model_2_animal;
Y_prob_human(1) = mean_p1_human;
Y_prob_animal(1) = mean_p2_animal;

for file_number = 2 : 9
    load("data/data" + (file_number + 21) + "_final_test.mat");
    X_human_array(file_number) = sigma_noise_human;
    X_animal_array(file_number) = sigma_noise_human;
    Y_human_array(file_number) = true_human / 10;
    Y_animal_array(file_number) = true_animal / 10;
    Y_error_human(file_number) = mean_error_model_1_human;
    Y_error_animal(file_number) = mean_error_model_2_animal;
    Y_prob_human(file_number) = mean_p1_human;
    Y_prob_animal(file_number) = mean_p2_animal;
end

fig_id = fig_id + 1;
figure(fig_id), clf, hold on;
plt = plot(X_human_array, Y_human_array, "r+", X_animal_array, Y_animal_array, "bx");
xlim([0, 26]);
ylim([50, 100]);
xlabel('sigma_noise_human & sigma_noise_animal [m]');
ylabel('Accuracy per class [%]');
plt(1).MarkerSize = 10;
plt(1).LineWidth = 2;
plt(2).MarkerSize = 10;
plt(2).LineWidth = 2;
lgd = legend("human", "animal");
lgd.FontSize = 10;

fig_id = fig_id + 1;
figure(fig_id), clf, hold on;
plt = plot(X_human_array, Y_error_human, "r+", X_animal_array, Y_error_animal, "bx");
xlim([0, 26]);
ylim([0, 50]);
xlabel('sigma_noise_human & sigma_noise_animal [m]');
ylabel('Tracking error per class [m]');
plt(1).MarkerSize = 10;
plt(1).LineWidth = 2;
plt(2).MarkerSize = 10;
plt(2).LineWidth = 2;
lgd = legend("human", "animal");
lgd.FontSize = 10;

fig_id = fig_id + 1;
figure(fig_id), clf, hold on;
plt = plot(X_human_array, Y_prob_human, "r+", X_animal_array, Y_prob_animal, "bx");
xlim([0, 26]);
ylim([0.4, 0.8]);
xlabel('sigma_noise_human & sigma_noise_animal [m]');
ylabel('Confidence per class');
plt(1).MarkerSize = 10;
plt(1).LineWidth = 2;
plt(2).MarkerSize = 10;
plt(2).LineWidth = 2;
lgd = legend("human", "animal");
lgd.FontSize = 10;

