

%% Reconstrucción de la imagen desde archivo con 111 'a' y 111 'b'
clear; clc; close all;


%% Elección de la mejor trama
% Leer el archivo de texto original
filename = 'imagen_color_bits_formato_101_lineas.txt'; % Información del receptor
fileID = fopen(filename, 'r');
data = fread(fileID, '*char')';
fclose(fileID);

% Buscar el patrón que comienza con entre 106 y 116 'a' y termina con entre 106 y 116 'b'
pattern = '(a{106,116})(.*?)(b{106,116})'; % Captura inicio, contenido y fin
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
    difference = abs(char_count - 26240);
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


%% Decodificar la trama y recostruir la imagen

% === Parámetros conocidos ===
rows = 41;
cols = 80;
bits_por_pixel = 8;
total_pixels = rows * cols;
total_bits = total_pixels * bits_por_pixel; % 26240

% === Leer el archivo de texto ===
filename = 'borrar.txt';  % Cambia si es necesario
fid = fopen(filename, 'r');
if fid == -1
    error('No se pudo abrir el archivo %s', filename);
end

lineas = textscan(fid, '%s', 'Delimiter', '\n');
fclose(fid);
lineas = lineas{1};

% === Unir todas las líneas en una sola cadena ===
cadena_completa = strjoin(lineas, '');  % Unir las líneas eliminando saltos de línea

% === Validación del tamaño ===
if length(cadena_completa) ~= 26462
    error('La cadena no tiene 26462 caracteres. Tiene %d.', length(cadena_completa));
end

% === Eliminar los 111 'a' del inicio y 111 'b' del final ===
cadena_bits_puros = cadena_completa(112:end-111); % del carácter 112 al 26351

% === Filtrar caracteres no deseados (solo '0' y '1') ===
cadena_bits_puros = cadena_bits_puros(cadena_bits_puros == '0' | cadena_bits_puros == '1');

% === Verificar que la cantidad de bits sea 26240 ===
if length(cadena_bits_puros) ~= total_bits
    % Si hay más o menos bits, rellenamos con '0' o '1'
    faltantes = total_bits - length(cadena_bits_puros);
    if faltantes > 0
        % Si faltan bits, agregamos ceros (puedes cambiarlo a '1' si prefieres)
        cadena_bits_puros = [cadena_bits_puros, repmat('0', 1, faltantes)];
    elseif faltantes < 0
        % Si sobran bits, cortamos el exceso (esto no debería ocurrir si todo está correcto)
        cadena_bits_puros = cadena_bits_puros(1:total_bits);
    end
end

% === Convertir a vector binario numérico ===
bit_vector = double(cadena_bits_puros) - double('0');  % Convertimos '0' a 0 y '1' a 1

% === Verificar que solo haya 0 y 1 ===
valores_unicos = unique(bit_vector);
if ~all(ismember(valores_unicos, [0 1]))
    error('Se encontraron caracteres distintos de 0 y 1.');
end

% === Reconstrucción de la imagen ===
bits_reshape = reshape(bit_vector, [], bits_por_pixel);
pixel_vals = bi2de(bits_reshape, 'left-msb');
img_reconstruida = reshape(pixel_vals, [rows, cols]);

% === Mostrar la imagen ===
figure;
imshow(img_reconstruida, []);
title('Imagen Reconstruida desde archivo con 101 líneas');

disp('✅ Imagen reconstruida correctamente desde el archivo .txt');

% === Escalar la imagen reconstruida (por ejemplo, 5 veces más grande) ===
factor_escala = 5;  % Puedes cambiar este valor (ej. 2, 3, 4, etc.)
img_reconstruida_grande = imresize(img_reconstruida, factor_escala, 'nearest');

% === Mostrar la imagen escalada ===
figure;
imshow(img_reconstruida_grande, []);
title('Imagen Reconstruida y Ampliada');

disp('✅ Imagen reconstruida y ampliada correctamente.');