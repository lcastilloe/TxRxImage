%% Conversión de imagen a bits y reconstrucción 
clear; clc; close all;

% 1. Cargar la imagen (debe estar en la misma carpeta o dar la ruta completa)
img = imread('imagen2.png'); 

% 2. Convertir a escala de grises si es RGB
if size(img,3) == 3
    img_gray = rgb2gray(img);
else
    img_gray = img; % Ya es escala de grises
end

% Obtener tamaño de la imagen
[rows, cols] = size(img_gray); % Número de filas y columnas (alto y ancho)
total_pixels = rows * cols;    % Número total de píxeles

% 3. Convertir a bits (cada píxel tiene 8 bits)
img_bits = de2bi(img_gray(:), 8, 'left-msb'); % Matriz de bits
img_bits_vector = img_bits(:); % Convertir a vector de bits
total_bits = length(img_bits_vector); % Total de bits generados

% 4. Mostrar información en consola
disp('=== Información de la Imagen ===');
fprintf('Tamaño de la imagen: %d x %d píxeles\n', rows, cols);
fprintf('Total de píxeles: %d\n', total_pixels);
fprintf('Total de bits generados: %d\n', total_bits);

% 5. Mostrar la cadena de bits en la consola (solo los primeros 500 bits para no saturar)
disp('Cadena de bits generada (primeros 500 bits):');
disp(num2str(img_bits_vector(1:500)')); % Muestra los primeros 500 bits

% 6. Guardar la cadena de bits en un archivo de texto
fileID = fopen('imagen_bits.txt','w');
fprintf(fileID, '%d', img_bits_vector);
fclose(fileID);
disp('Cadena de bits guardada en imagen_bits.txt');

% 7. Reconstrucción de la imagen desde los bits
img_reconstructed = bi2de(reshape(img_bits_vector, [], 8), 'left-msb'); 
img_reconstructed = reshape(img_reconstructed, size(img_gray)); % Restaurar dimensiones originales

% 8. Mostrar la imagen original, la de escala de grises y la reconstruida
figure;
subplot(1,3,1); imshow(img); title('Imagen Original');
subplot(1,3,2); imshow(img_gray); title('Imagen en Escala de Grises');
subplot(1,3,3); imshow(img_reconstructed, []); title('Imagen Reconstruida desde Bits');

disp('Conversión de imagen a bits y reconstrucción completada.');
