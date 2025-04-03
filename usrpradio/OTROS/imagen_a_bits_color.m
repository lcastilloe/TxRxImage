%%PARA APSRA CUALQUEIR IMAGEN A COLOR 

clc; clear; close all;

% 1. Cargar la imagen
[filename, pathname] = uigetfile({'*.png;*.jpg;*.jpeg;*.bmp;*.tif','All Image Files'}, 'Selecciona una imagen');
if isequal(filename, 0)
    error('No se seleccionó ninguna imagen.');
end
img = imread(fullfile(pathname, filename));

% 2. Mostrar la imagen original
figure;
subplot(2,2,1);
imshow(img);
title('Imagen Original');

% 3. Obtener dimensiones e información de la imagen
[rows, cols, channels] = size(img);
fprintf('Dimensiones de la imagen original: %d x %d x %d\n', rows, cols, channels);

% 4. Calcular el número de bits que generaría la imagen completa
bits_per_pixel = 8; % 8 bits por canal de color
total_bits = rows * cols * channels * bits_per_pixel;

% 5. Ajustar la imagen si el número de bits excede el límite
max_bits = 90000; % Máximo de bits permitido
if total_bits > max_bits
    scale_factor = sqrt(max_bits / (rows * cols * channels));
    img = imresize(img, scale_factor);
    [rows, cols, channels] = size(img);
    fprintf('La imagen se ha reducido a: %d x %d x %d\n', rows, cols, channels);
end

% 6. Convertir la imagen a bits
bits = reshape(de2bi(img(:), bits_per_pixel, 'left-msb')', [], 1);
num_bits = length(bits);
fprintf('Número total de bits después de la reducción: %d\n', num_bits);

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
