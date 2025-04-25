%% --- DECODIFICADOR BASE64 CORREGIDO ---
% 1. Configuración inicial
clear; clc; close all;
disp('=== DECODIFICADOR FLEXIBLE DE IMÁGENES BASE64 ===');

% 2. Parámetros de la imagen (ajustar según necesidad)
rows = 103;         % Alto en píxeles
cols = 200;         % Ancho en píxeles
channels = 3;       % Canales de color (3 = RGB)
expected_length = 82500;  % 1,308,800 caracteres Base64 para 409x800x3

% 3. Leer archivo de transmisión
filename = 'outputBAe64si6.txt';
try
    fid = fopen(filename, 'r');
    lines = textscan(fid, '%s', 'Delimiter', '\n');
    fclose(fid);
    cadena_completa = strjoin(lines{1}, '');
    cadena_completa = char(cadena_completa); % Conversión a char explícita
    disp(['📄 Archivo leído: ', filename, ' (', num2str(strlength(cadena_completa)), ' caracteres)']);
catch
    error('❌ No se pudo leer el archivo. Verifica nombre o permisos.');
end

% 4. Detección automática de delimitadores
num_a = 0;
while num_a < min(1000, strlength(cadena_completa)) && cadena_completa(num_a+1) == 'a'
    num_a = num_a + 1;
end

num_b = 0;
while num_b < min(1000, strlength(cadena_completa)) && cadena_completa(end-num_b) == 'b'
    num_b = num_b + 1;
end

disp(['🔍 Delimitadores detectados: ', num2str(num_a), ' "a" iniciales y ', num2str(num_b), ' "b" finales']);

% 5. Extraer Base64 puro (asegurando tipo char)
if num_a > 0 || num_b > 0
    cadena_base64 = char(extractBetween(cadena_completa, num_a+1, strlength(cadena_completa)-num_b));
else
    cadena_base64 = cadena_completa;
    disp('⚠️ No se detectaron delimitadores "a"/"b". Procesando cadena completa.');
end

% 6. Verificar y corregir longitud
if strlength(cadena_base64) < expected_length
    ceros_necesarios = expected_length - strlength(cadena_base64);
    cadena_base64 = [repmat('0', 1, ceros_necesarios), cadena_base64];
    disp(['🔧 Corrección: Añadidos ', num2str(ceros_necesarios), ' ceros al inicio']);
elseif strlength(cadena_base64) > expected_length
    error('❌ La cadena Base64 excede el tamaño esperado. Verifica dimensiones.');
end

% 7. Decodificación (con verificación final de tipo)
cadena_base64 = char(cadena_base64); % Garantiza tipo char
try
    img_decoded = matlab.net.base64decode(cadena_base64);
    disp('✅ Base64 decodificado correctamente');
catch ME
    error('❌ Error al decodificar: %s', ME.message);
end

% 8. Reconstrucción de imagen
try
    img_reconstructed = reshape(img_decoded, rows, cols, channels);
    disp(['🖼️ Imagen reconstruida: ', num2str(rows), 'x', num2str(cols), 'x', num2str(channels)]);
catch
    error('❌ Error al reconstruir imagen. Verifica rows/cols/channels.');
end

% 9. Visualización
figure;
imshow(img_reconstructed);
title(['Imagen Reconstruida (', num2str(rows), 'x', num2str(cols), ' RGB)']);
imwrite(img_reconstructed, 'imagen_reconstruida.png');
disp('💾 Imagen guardada como "imagen_reconstruida.png"');