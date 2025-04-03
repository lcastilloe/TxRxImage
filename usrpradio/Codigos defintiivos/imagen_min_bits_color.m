%%PASAR LA IMAGEN A COLOR A BITS 
clc; clear; close all;

% 1. Cargar la imagen
img = imread('imagen2.png');  % La imagen se llama 'imagen2.jpg' y está en la misma carpeta

% 2. Redimensionar la imagen a 41x80 píxeles
img = imresize(img, [41, 80]);

% 3. Mostrar la imagen original
figure;
subplot(2,2,1);
imshow(img);
title('Imagen Original');

% 4. Obtener dimensiones e información de la imagen
[rows, cols, channels] = size(img);
fprintf('Dimensiones de la imagen redimensionada: %d x %d x %d\n', rows, cols, channels);

% 5. Calcular el número de bits que generaría la imagen completa
bits_per_pixel = 8; % 8 bits por canal de color
total_bits = rows * cols * channels * bits_per_pixel;

% 6. Convertir la imagen a bits
bits = reshape(de2bi(img(:), bits_per_pixel, 'left-msb')', [], 1);
num_bits = length(bits);
fprintf('Número total de bits después de la conversión: %d\n', num_bits);

% 7. Mostrar una parte de los bits generados (solo los primeros 100 bits)
subplot(2,2,2);
text(0.1, 0.5, num2str(bits(1:100)'), 'FontSize', 10);
axis off;
title('Primeros 100 bits generados');

% 8. Reconstruir la imagen desde los bits
img_reconstruida = uint8(reshape(bi2de(reshape(bits, bits_per_pixel, []).', 'left-msb'), rows, cols, channels));

% 9. Mostrar la imagen reconstruida
subplot(2,2,3);
imshow(img_reconstruida);
title('Imagen Reconstruida');

% 10. Validar si la imagen reconstruida es igual a la original
if isequal(img, img_reconstruida)
    fprintf('La conversión a bits y la reconstrucción son correctas.\n');
else
    fprintf('¡Error en la reconstrucción de la imagen!\n');
end

% 11. Guardar los bits en un archivo
fileID = fopen('bits_imagen_color.txt', 'w');
fprintf(fileID, '%d\n', bits);
fclose(fileID);
