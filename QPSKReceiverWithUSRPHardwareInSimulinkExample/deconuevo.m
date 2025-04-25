%% Decodificador desde imagen_base64_formato_lineas.txt
clear; clc; close all;

% 1. Leer las líneas del archivo
filename = 'outputPF1.txt';
lineas = readlines(filename);  % Lee todas las líneas (110 líneas)

% 2. Unir todas las líneas en una sola cadena
cadena_total = join(lineas, "");  % ahora tiene 82500 caracteres

% 3. Extraer la cadena base64 sin los delimitadores (50 'a' al inicio, 50 'b' al final)
base64_data = extractBetween(cadena_total, 51, 82450);  % Del carácter 51 al 82450

% 4. Decodificar la cadena Base64
img_decoded = matlab.net.base64decode(base64_data);

% 5. Reconstruir imagen
rows = 103;       % Altura de la imagen redimensionada usada
cols = 200;       % Anchura de la imagen redimensionada usada
channels = 3;     % RGB

img_reconstructed = reshape(img_decoded, rows, cols, channels);

% 6. Mostrar imagen
figure;
imshow(img_reconstructed);
title('Imagen reconstruida desde archivo Base64');

disp('✅ Imagen reconstruida exitosamente desde imagen_base64_formato_lineas.txt');
