%% Reconstrucción de la imagen desde el archivo de texto
clear; clc; close all;

% === Parámetros conocidos ===
rows = 41;
cols = 80;
bits_por_pixel = 8;
total_pixels = rows * cols;
total_bits = total_pixels * bits_por_pixel;

% === Leer el archivo de texto con los bloques de bits ===
filename = 'imagen_bits_formato_101_lineas.txt';
fid = fopen(filename, 'r');
if fid == -1
    error('No se pudo abrir el archivo %s', filename);
end

lines = textscan(fid, '%s', 'Delimiter', '\n');
fclose(fid);
lineas = lines{1};

% === Convertir líneas de texto a bits (0s y 1s) ===
bit_vector = [];
for i = 1:length(lineas)
    linea = regexprep(lineas{i}, '[^01]', '');  % Elimina todo excepto '0' y '1'
    bits = double(linea) - double('0');         % Convierte caracteres a números
    bit_vector = [bit_vector; bits(:)]; %#ok<AGROW>
end

% === Verificación de longitud esperada ===
if length(bit_vector) ~= total_bits
    error('El número de bits (%d) no coincide con el tamaño esperado (%d)', length(bit_vector), total_bits);
end

% === Comprobar que solo haya 0s y 1s ===
valores_unicos = unique(bit_vector);
if ~all(ismember(valores_unicos, [0 1]))
    error('Se detectaron valores distintos de 0 y 1 en el vector de bits.');
end

% === Reconstrucción de la imagen ===
bits_reshape = reshape(bit_vector, [], bits_por_pixel);
pixel_vals = bi2de(bits_reshape, 'left-msb');
img_reconstruida = reshape(pixel_vals, [rows, cols]);

% === Mostrar la imagen reconstruida ===
figure;
imshow(img_reconstruida, []);
title('Imagen Reconstruida desde archivo');

disp('✅ Imagen reconstruida correctamente desde imagen_recibida_pero_completada.txt');
