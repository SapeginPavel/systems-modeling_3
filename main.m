% 3. Междугородный переговорный пункт имеет четыре телефонных
% аппарата. В среднем за сутки поступает 320 заявок на переговоры. Средняя
% длительность переговоров составляет 5 мин. Длина очереди не должна
% превышать 6 абонентов. Потоки заявок и обслуживаний простейшие.
% Определить характеристики обслуживания переговорного пункта в
% стационарном режиме: 
    % вероятность простоя каналов,
    % вероятность отказа клиенту в обслуживании, 
    % среднее число занятых каналов, 
    % среднее число заявок в очереди.

% Проблемы: 
% надо было выключить единый out для всех переменных (To workspace)

clear all; % очищаем рабочую область

Ts = 0.25; % снимаем показания каждые 15 секунд (период дискретизации)
Ns = 60 * 24; % отчет на протяжении 24 часов

sim('model', Ts * Ns); % запуск моделирования

% 1 ПАРАМЕТР: Считаем время занятости каналов
channel1_sum = sum(channel1);
channel2_sum = sum(channel2);
channel3_sum = sum(channel3);
channel4_sum = sum(channel4);

% Получаем количество отсчетов для каждого канала
channel1_len = length(channel1);
channel2_len = length(channel2);
channel3_len = length(channel3);
channel4_len = length(channel4);

% Рассчитываем для каждого канала время простоя
p_downtime1 = 1 - channel1_sum / channel1_len;
p_downtime2 = 1 - channel2_sum / channel2_len;
p_downtime3 = 1 - channel3_sum / channel3_len;
p_downtime4 = 1 - channel4_sum / channel4_len;

fprintf('Время простоя каналов: %f, %f, %f, %f\n', ...
    p_downtime1, p_downtime2, p_downtime3, p_downtime4); % выводим в консоль


% 2 ПАРАМЕТР: Считаем вероятность отказа клиенту
probability_of_failure = 1 - (sum(entitiesNumFromQueue) ...
    / sum(enitiesNumFromGenerator));
 
fprintf('Вероятность отказа клиенту в обслуживании: %f\n', ...
    probability_of_failure); % Выводим в консоль вероятность отказа


% 3 ПАРАМЕТР: Рассчитываем среднее число занятых каналов
n = length(channel1);  % длина массивов
active_counts = zeros(1, n);  % сюда будем сохранять количество ненулевых значений

% Запускаем цикл по длине массивов
for i = 1:n
    % Проверяем, какие из 4 каналов ненулевые в текущем индексе
    count = (channel1(i) ~= 0) + ...
            (channel2(i) ~= 0) + ...
            (channel3(i) ~= 0) + ...
            (channel4(i) ~= 0);

    active_counts(i) = count;  % сохраняем, сколько каналов активно
end

% Вычисляем среднее количество одновременно активных каналов
average_active_channels = mean(active_counts);

fprintf('Среднее число активных каналов: %f\n', ...
    average_active_channels); % Выводим в консоль


% Считаем среднее кол-во заявок в очереди
average_number_of_requests_in_queue = sum(entitiesNumInQueue) / length(entitiesNumInQueue);


fprintf('Среднее число заявок в очереди: %f\n', ...
    average_number_of_requests_in_queue); % Выводим в консоль