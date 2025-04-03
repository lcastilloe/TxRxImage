%% Reconstrucción de imagen desde bits guardados en imagen_bits.txt
clear; clc; close all;

% === 1. Cargar los bits desde el archivo de texto ===
fileID = fopen('imagen_bits.txt', 'r'); 
bitstream = fscanf(fileID, '%1d'); % Leer como vector de bits
fclose(fileID);

% === 2. Verificar que el número de bits sea múltiplo de 8 ===
if mod(length(bitstream), 8) ~= 0
    warning('El número de bits no es múltiplo de 8. Se descartan bits sobrantes.');
    bitstream = bitstream(1:end - mod(length(bitstream), 8));
end

% === 3. Convertir los bits en valores de píxeles (escala de grises 8 bits) ===
pixels = bi2de(reshape(bitstream, [], 8), 'left-msb');

% === 4. Definir el tamaño original de la imagen MANUALMENTE ===
rows = 76;  % AJUSTA ESTE VALOR SEGÚN EL TAMAÑO ORIGINAL
cols = length(pixels) / rows;

if mod(length(pixels), rows) ~= 0
    error('⚠ No se puede ajustar automáticamente el tamaño de la imagen. Define "rows" manualmente.');
end

% === 5. Reconstruir la imagen en formato matriz ===
img_reconstructed = reshape(pixels, rows, cols);

% === 6. Mostrar la imagen reconstruida ===
figure;
imshow(img_reconstructed, []);
title('Imagen Reconstruida desde Bits');

% === 7. Guardar la imagen reconstruida ===
imwrite(uint8(img_reconstructed), 'imagen_reconstruida.png');

disp('✅ Imagen reconstruida y guardada como imagen_reconstruida.png');
fprintf('Tamaño estimado de la imagen: %d x %d píxeles\n', rows, cols);
fprintf('Total de bits procesados: %d\n', length(bitstream));
