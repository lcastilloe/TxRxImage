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

% 3. Redimensionar la imagen para reducir la cantidad de bits
escala = 0.1; % Cambia este valor según la reducción deseada (por ejemplo, 0.25, 0.1, etc.)
img_gray = imresize(img_gray, escala);

% Obtener tamaño de la imagen
[rows, cols] = size(img_gray); % Número de filas y columnas (alto y ancho)
total_pixels = rows * cols;    % Número total de píxeles

% 4. Convertir a bits (cada píxel tiene 8 bits)
img_bits = de2bi(img_gray(:), 8, 'left-msb'); % Matriz de bits
img_bits_vector = img_bits(:); % Convertir a vector de bits
total_bits = length(img_bits_vector); % Total de bits generados

% 5. Mostrar información en consola
disp('=== Información de la Imagen ===');
fprintf('Tamaño de la imagen: %d x %d píxeles\n', rows, cols);
fprintf('Total de píxeles: %d\n', total_pixels);
fprintf('Total de bits generados: %d\n', total_bits);

% 6. Mostrar la cadena de bits en la consola (solo los primeros 500 bits para no saturar)
disp('Cadena de bits generada (primeros 500 bits):');
disp(num2str(img_bits_vector(1:min(500, total_bits))')); % Muestra los primeros 500 bits

% 7. Guardar la cadena de bits en un archivo de texto
fileID = fopen('imagen_bits_minimo.txt','w');
fprintf(fileID, '%d', img_bits_vector);
fclose(fileID);
disp('Cadena de bits guardada en imagen_bits_minimo.txt');

% 8. Reconstrucción de la imagen desde los bits
img_reconstructed = bi2de(reshape(img_bits_vector, [], 8), 'left-msb'); 
img_reconstructed = reshape(img_reconstructed, size(img_gray)); % Restaurar dimensiones originales

% 9. Mostrar la imagen original, la de escala de grises redimensionada y la reconstruida
figure;
subplot(1,3,1); imshow(img); title('Imagen Original');
subplot(1,3,2); imshow(img_gray); title('Escala de Grises Redimensionada');
subplot(1,3,3); imshow(img_reconstructed, []); title('Imagen Reconstruida desde Bits');

disp('Conversión de imagen a bits y reconstrucción completada.');
% 7. Preparar la cadena completa con 111 'a' al inicio y 111 'b' al final
cadena_bits = char(img_bits_vector' + '0'); % Convertimos los bits a caracteres '0' y '1'
cadena_final = ['a'*ones(1,111), cadena_bits, 'b'*ones(1,111)]; % Concatenar 111 a, bits, 111 b

% Verificar que tenga 26462 caracteres
if length(cadena_final) ~= 26462
    error('La cadena final no tiene 26462 caracteres. Tiene %d.', length(cadena_final));
end

% Dividir en 101 líneas de 262 caracteres
lineas = reshape(cadena_final, 262, [])'; % Cada fila es una línea

% Guardar en archivo de texto
fileID = fopen('imagen_bits_formato_101_lineas.txt', 'w');
for i = 1:size(lineas,1)
    fprintf(fileID, '%s\n', lineas(i,:));
end
fclose(fileID);

disp('✅ Cadena de bits formateada y guardada en imagen_bits_formato_101_lineas.txt');
