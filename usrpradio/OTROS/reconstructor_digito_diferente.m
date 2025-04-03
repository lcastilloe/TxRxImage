%% Reconstrucción de la imagen desde archivo con 111 'a' y 111 'b'
%%RECONSTURCTOR CUANDO TIENE ALGUN DIGITITOP MAL LO ASOCIA A OTRO NUMERO 
clear; clc; close all;

% === Parámetros conocidos ===
rows = 41;
cols = 80;
bits_por_pixel = 8;
total_pixels = rows * cols;
total_bits = total_pixels * bits_por_pixel; % 26240

% === Leer el archivo de texto ===
filename = 'imagen_bits_formato_101_lineas.txt';  % Cambia si es necesario
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
