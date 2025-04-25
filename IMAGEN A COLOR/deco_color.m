% DECODIFICADOR COLOR DESDE ARCHIVO
clc; clear; close all;

% 1. Leer el archivo con los bits
fileID = fopen('outputPF1.txt', 'r');
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
