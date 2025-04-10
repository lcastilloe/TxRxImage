%% Conversión de imagen a dígitos decimales y reconstrucción con color
clear; clc; close all;

% 1. Cargar la imagen (debe estar en la misma carpeta o dar la ruta completa)
img = imread('imagen.png'); 

% 2. Redimensionar la imagen para reducir la cantidad de dígitos
escala = 0.225; % Cambia este valor según la reducción deseada (por ejemplo, 0.25, 0.1, etc.)
img_resized = imresize(img, escala);

% Obtener tamaño de la imagen
[rows, cols, channels] = size(img_resized); % Número de filas, columnas y canales
total_pixels = rows * cols;    % Número total de píxeles

% 3. Convertir cada píxel a una representación decimal
img_decimals_vector = '';
for c = 1:channels
    img_channel = img_resized(:,:,c);
    for i = 1:numel(img_channel)
        img_decimals_vector = strcat(img_decimals_vector, sprintf('%03d', img_channel(i)));
    end
end

% 4. Mostrar información en consola
disp('=== Información de la Imagen ===');
fprintf('Tamaño de la imagen: %d x %d píxeles\n', rows, cols);
fprintf('Total de píxeles: %d\n', total_pixels);
fprintf('Total de dígitos generados: %d\n', length(img_decimals_vector));

% 5. Mostrar los primeros 500 dígitos para no saturar
disp('Cadena de dígitos generada (primeros 500 dígitos):');
disp(img_decimals_vector(1:min(500, length(img_decimals_vector))));

% 6. Guardar la cadena de dígitos en un archivo de texto
fileID = fopen('imagen_decimales_color.txt','w');
fprintf(fileID, '%s', img_decimals_vector);
fclose(fileID);
disp('Cadena de dígitos guardada en imagen_decimales_color.txt');

% 7. Reconstrucción de la imagen desde los dígitos
decimals_reconstructed = zeros(rows, cols, channels, 'uint8');
for c = 1:channels
    start_idx = (c-1) * total_pixels * 3 + 1;
    end_idx = c * total_pixels * 3;
    decimals_channel = reshape(str2num(reshape(img_decimals_vector(start_idx:end_idx), 3, [])'), rows, cols);
    decimals_reconstructed(:,:,c) = uint8(decimals_channel);
end

% 8. Mostrar la imagen original, la redimensionada y la reconstruida
figure;
subplot(1,3,1); imshow(img); title('Imagen Original');
subplot(1,3,2); imshow(img_resized); title('Imagen Redimensionada');
subplot(1,3,3); imshow(decimals_reconstructed); title('Imagen Reconstruida desde Dígitos');

disp('Conversión de imagen a dígitos decimales y reconstrucción completada.');

% 9. Preparar la cadena formateada
cadena_final = ['a'*ones(1,70), img_decimals_vector, 'b'*ones(1,70)]; % Concatenar 111 a, dígitos, 111 b

% Verificar que tenga 26462 caracteres
if length(cadena_final) ~= 150800
    error('La cadena final no tiene 150660 caracteres. Tiene %d.', length(cadena_final));
end

% Dividir en 101 líneas de 262 caracteres
lineas = reshape(cadena_final, 754, [])'; % Cada fila es una línea

% Guardar en archivo de texto
fileID = fopen('imagen_decimales_color_formato_200_lineas.txt', 'w');
for i = 1:size(lineas,1)
    fprintf(fileID, '%s\n', lineas(i,:));
end
fclose(fileID);

disp('✅ Cadena de dígitos formateada y guardada en imagen_decimales_color_formato_200_lineas.txt');