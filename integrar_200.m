clc; clear; close all;

%% === PARTE 1: EXTRAER BLOQUE VÁLIDO DE 78780 CARACTERES ===
longitud_total = 150800;  % 30 'a' + 78720 bits + 30 'b'
prefijo = repmat('a', 1, 70);
sufijo  = repmat('b', 1, 70);

filename = 'imagen_decimales_color.txt';  % Archivo original con cadenas largas
contenido = fileread(filename);
total_caracteres = length(contenido);

fprintf('📄 Total de caracteres en el archivo: %d\n', total_caracteres);
num_bloques = floor(total_caracteres / longitud_total);
fprintf('🔍 Se detectaron %d posibles bloques de 150660 caracteres.\n', num_bloques);

cadena_valida = '';
for i = 1:num_bloques
    inicio = (i - 1) * longitud_total + 1;
    fin = inicio + longitud_total - 1;
    bloque = contenido(inicio:fin);

    % Verificar inicio, final y longitud exacta
    if startsWith(bloque, prefijo) && endsWith(bloque, sufijo) && length(bloque) == longitud_total
        cadena_valida = bloque;
        fprintf('✅ Bloque %d válido encontrado (longitud %d).\n', i, length(bloque));
        break;
    else
        fprintf('❌ Bloque %d inválido (longitud %d, no cumple requisitos).\n', i, length(bloque));
    end
end

if isempty(cadena_valida)
    error('⚠️ No se encontró ninguna cadena válida con 70 "a", 70 "b" y 150660 caracteres.');
end

%% === PARTE 2: FORMATEAR EN 101 LÍNEAS DE 780 CARACTERES ===
lineas = reshape(cadena_valida, 754, [])';  % Cada fila es una línea de 780 caracteres
filename_out = 'espacios.txt';
fid = fopen(filename_out, 'w');
for i = 1:size(lineas, 1)
    if i < size(lineas, 1)
        fprintf(fid, '%s\n', lineas(i, :));
    else
        fprintf(fid, '%s', lineas(i, :)); % Sin salto de línea en la última línea
    end
end
fclose(fid);
fprintf('✅ Archivo formateado guardado como "%s"\n', filename_out);


%% === PARTE 3: DECODIFICACIÓN Y RECONSTRUCCIÓN DE LA IMAGEN ===

% 1. Leer el archivo de texto formateado
filename = 'espacios.txt';
fileID = fopen(filename, 'r');
data = fscanf(fileID, '%c');
fclose(fileID);

% 2. Eliminar las primeras 87 'a' y las últimas 87 'b'
if length(data) < 140
    error('El archivo no contiene suficientes caracteres para eliminar las 87 "a" y las 87 "b".');
end

data_trimmed = data(71:end-70);

% 3. Eliminar saltos de línea y espacios
data_trimmed = data_trimmed(~isspace(data_trimmed)); 

% 4. Reemplazar cualquier carácter no válido por '0'
data_cleaned = data_trimmed;
data_cleaned(~(data_cleaned >= '0' & data_cleaned <= '9')) = '0';

% Dimensiones de la imagen
rows = 93; % Número de filas de la imagen redimensionada
cols = 180; % Número de columnas de la imagen redimensionada
channels = 3; % Número de canales (RGB)

% Verificar la longitud de los datos
total_pixels = rows * cols;
expected_length = total_pixels * channels * 3; % Cada píxel tiene 3 dígitos por canal

disp(['Longitud de los datos limpiados: ', num2str(length(data_cleaned))]);
disp(['Longitud esperada: ', num2str(expected_length)]);

if length(data_cleaned) ~= expected_length
    error('La longitud de los datos no coincide con el tamaño esperado.');
end

% 5. Reconstruir los datos de la imagen
decimals_reconstructed = zeros(rows, cols, channels, 'uint8');
for c = 1:channels
    start_idx = (c-1) * total_pixels * 3 + 1;
    end_idx = c * total_pixels * 3;
    decimals_channel = reshape(str2num(reshape(data_cleaned(start_idx:end_idx), 3, [])'), rows, cols);
    decimals_reconstructed(:,:,c) = uint8(decimals_channel);
end

% 6. Mostrar la imagen reconstruida
figure;
imshow(decimals_reconstructed);
title('Imagen Reconstruida');

% 7. Crear y mostrar una versión ampliada de la imagen
ampliacion_factor = 2; % Factor de ampliación ajustado
imagen_ampliada = imresize(decimals_reconstructed, ampliacion_factor, 'nearest'); % Redimensionar
figure;
imshow(imagen_ampliada);
title('Imagen Ampliada');

% 8. Guardar las imágenes reconstruida y ampliada
imwrite(decimals_reconstructed, 'imagen_reconstruida.png');
imwrite(imagen_ampliada, 'imagen_ampliada.png');
disp('✅ Imagen reconstruida guardada como imagen_reconstruida.png');
disp('✅ Imagen ampliada guardada como imagen_ampliada.png');