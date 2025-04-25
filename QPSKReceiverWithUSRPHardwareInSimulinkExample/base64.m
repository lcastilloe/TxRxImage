%% Conversión de imagen a Base64 y reconstrucción con color
clear; clc; close all;

% 1. Cargar la imagen
img = imread('imagen2.png');

% 2. Redimensionar la imagen
escala = 0.25; % Cambia según necesidad
img_resized = imresize(img, escala);

% 3. Obtener tamaño de la imagen
[rows, cols, channels] = size(img_resized);
total_pixels = rows * cols;

% 4. Convertir imagen a vector de bytes
img_bytes = reshape(img_resized, [], 1); % convierte RGB a vector lineal
img_bytes_uint8 = uint8(img_bytes);      % asegura tipo correcto

% 5. Codificar a Base64
img_base64 = matlab.net.base64encode(img_bytes_uint8);

% 6. Mostrar información
disp('=== Información de la Imagen ===');
fprintf('Tamaño redimensionado: %d x %d\n', rows, cols);
fprintf('Bytes de imagen: %d\n', numel(img_bytes_uint8));
fprintf('Longitud Base64: %d caracteres\n', strlength(img_base64));
disp('Primeros 500 caracteres:');
disp(extractBetween(img_base64, 1, min(500, strlength(img_base64))));

% 7. Guardar en archivo base64 sin formato
fileID = fopen('imagen_base64_color.txt','w');
fprintf(fileID, '%s', img_base64);
fclose(fileID);
disp('📁 Imagen codificada en Base64 guardada en imagen_base64_color.txt');

% 8. Reconstrucción desde Base64
img_decoded = matlab.net.base64decode(img_base64); % vector uint8

% Reconstruir la imagen
img_reconstructed = reshape(img_decoded, rows, cols, channels);

% 9. Mostrar las imágenes
figure;
subplot(1,3,1); imshow(img); title('Imagen Original');
subplot(1,3,2); imshow(img_resized); title('Imagen Redimensionada');
subplot(1,3,3); imshow(img_reconstructed); title('Imagen Reconstruida');

disp('✅ Reconstrucción desde Base64 completada.');

% 10. Formatear para transmisión
% Añadir delimitadores 'a'*70 y 'b'*70
cadena_final = [repmat('a',1,50), img_base64, repmat('b',1,50)];

% Dividir la cadena en líneas de máximo 754 caracteres
longitud_linea = 750;
num_lineas = ceil(strlength(cadena_final) / longitud_linea);
lineas = strings(num_lineas, 1);

for i = 1:num_lineas
    inicio = (i-1)*longitud_linea + 1;
    fin = min(i*longitud_linea, strlength(cadena_final));
    lineas(i) = extractBetween(cadena_final, inicio, fin);
end

% Guardar cadena formateada
fileID = fopen('imagen_base64_formato_lineas.txt', 'w');
for i = 1:num_lineas
    fprintf(fileID, '%s\n', lineas(i));
end
fclose(fileID);

disp("Cadena formateada dinámicamente y guardada en imagen_base64_formato_lineas.txt");
 