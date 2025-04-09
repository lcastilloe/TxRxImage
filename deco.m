%% Reconstrucción de la imagen desde archivo con 111 'a' y 111 'b'
clear; clc; close all;


%% Elección de la mejor trama
% Leer el archivo de texto original
filename = 'outputP09.txt'; % Información del receptor
fileID = fopen(filename, 'r');
data = fread(fileID, '*char')';
fclose(fileID);

% Buscar el patrón que comienza con entre 106 y 116 'a' y termina con entre 106 y 116 'b'
pattern = '(a{30,30})(.*?)(b{30,30})'; % Captura inicio, contenido y fin
matches = regexp(data, pattern, 'tokens'); % Busca coincidencias y separa en grupos

% Inicializar variables para almacenar resultados filtrados
filtered_matches = [];
filtered_differences = [];

% Analizar cada coincidencia
for i = 1:length(matches)
    match = matches{i}; % Extraer el grupo actual
    content = match{2}; % Contenido entre las 'a' y las 'b'
    
    % Contar caracteres diferentes a '0' y '1'
    non_binary_count = sum(~ismember(content, '01'));
    
    % Guardar solo las cadenas válidas y sus diferencias
    if non_binary_count > 0
        filtered_matches = [filtered_matches; join(match, '')]; %#ok<AGROW>
        filtered_differences = [filtered_differences; non_binary_count]; %#ok<AGROW>
    end
end

% Seleccionar las 3 cadenas con la menor cantidad de caracteres no binarios
[~, indices] = sort(filtered_differences); % Ordenar por menor cantidad de diferencias
selected_matches = filtered_matches(indices(1:min(3, length(indices)))); % Tomar las primeras 3

% Evaluar las cadenas seleccionadas para encontrar la más cercana a 26,240 caracteres entre la última 'a' y la última 'b'
closest_match = '';
min_difference = inf;

for i = 1:length(selected_matches)
    current_match = selected_matches{i};
    
    % Encontrar la posición de la última 'a' y la última 'b'
    last_a_idx = find(current_match == 'a', 1, 'last');
    last_b_idx = find(current_match == 'b', 1, 'last');
    
    % Calcular la cantidad de caracteres entre la última 'a' y la última 'b'
    char_count = last_b_idx - last_a_idx - 1;
    
    % Verificar si es más cercana a 26,240 caracteres
    difference = abs(char_count - 78720);
    if difference < min_difference
        min_difference = difference;
        closest_match = current_match;
    end
end

% Guardar la cadena más cercana en un tercer archivo
output_filename = 'borrar.txt';
fileID = fopen(output_filename, 'w');

if ~isempty(closest_match)
    fprintf(fileID, '%s\n', closest_match);
    fprintf('La cadena más cercana a 26,240 caracteres guardada en "%s".\n', output_filename);
else
    fprintf('No se encontró una cadena válida para guardar.\n');
end

fclose(fileID);

%% Organizar el txt en 101 filas

% 1. Leer el archivo con una sola línea
input_filename = 'borrar.txt'; % Archivo con una sola línea larga
fileID = fopen(input_filename, 'r');
linea_unica = fgetl(fileID); % Leer la única línea del archivo
fclose(fileID);

% 2. Verificar que la longitud sea 78,780 caracteres
if length(linea_unica) ~= 78780
    error('La longitud de la línea no es la esperada (78,780 caracteres). Tiene %d caracteres.', length(linea_unica));
end

% 3. Dividir la línea en 101 filas de 780 caracteres
lineas = reshape(linea_unica, 780, [])'; % Crear una matriz donde cada fila tiene 780 caracteres

% 4. Guardar las líneas formateadas en un nuevo archivo
output_filename = 'borrar_formateado.txt'; % Nombre del archivo de salida
fileID = fopen(output_filename, 'w');
for i = 1:size(lineas, 1)
    fprintf(fileID, '%s\n', lineas(i, :));
end
fclose(fileID);

disp(['✅ Archivo organizado y guardado como "', output_filename, '".']);

%% Decodificar la trama y recostruir la imagen

% 1. Leer el archivo con los bits
fileID = fopen('borrar_formateado.txt', 'r');
lineas = textscan(fileID, '%s');
fclose(fileID);
lineas = lineas{1};

% 2. Unir todas las líneas en una sola cadena
cadena_bits = strjoin(lineas, '');

% 3. Remover los 30 caracteres 'a' al inicio y los 30 'b' al final
cadena_bits = cadena_bits(31:end-30);

% 4. Convertir la cadena de caracteres a un vector de bits
bits = cadena_bits - '0'; % Convierte '0' y '1' a 0 y 1

% 5. Reconstruir la imagen desde los bits
bits_per_pixel = 8; % 8 bits por canal de color
rows = 41; % Alto de la imagen
cols = 80; % Ancho de la imagen
channels = 3; % Número de canales (RGB)

% Convertir los bits en valores de píxeles
img_reconstruida = uint8(reshape(bi2de(reshape(bits, bits_per_pixel, []).', 'left-msb'), rows, cols, channels));

% 6. Mostrar la imagen reconstruida
figure;
imshow(img_reconstruida);
title('Imagen Reconstruida desde el Archivo de Texto');

% 7. Guardar la imagen reconstruida
imwrite(img_reconstruida, 'imagen_reconstruida.png');
disp('✅ Imagen reconstruida y guardada como imagen_reconstruida.png');