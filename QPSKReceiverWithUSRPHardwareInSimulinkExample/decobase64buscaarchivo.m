clc; clear; close all;

disp('=== PROCESAMIENTO COMPLETO: SELECCIÓN Y DECODIFICACIÓN BASE64 ===');

%% === PARTE 1: Selección de bloque válido desde archivo ===

% === Parámetros esperados ===
longitud_total = 82500;                   % 50 'a' + base64 + 50 'b'
prefijo = repmat('a', 1, 50);
sufijo  = repmat('b', 1, 50);
archivo_entrada = 'APruebaBase64_2.txt';   % Archivo a procesar

% === Leer archivo como una sola cadena ===
contenido = fileread(archivo_entrada);
total_caracteres = length(contenido);
fprintf('📄 Total de caracteres en el archivo: %d\n', total_caracteres);

% === Calcular número de bloques posibles ===
num_bloques = floor(total_caracteres / longitud_total);
fprintf('🔍 Se detectaron %d posibles bloques de %d caracteres.\n', num_bloques, longitud_total);

% === Buscar el primer bloque válido ===
cadena_valida = '';
for i = 1:num_bloques
    inicio = (i - 1) * longitud_total + 1;
    fin = inicio + longitud_total - 1;
    bloque = contenido(inicio:fin);

    if startsWith(bloque, prefijo) && endsWith(bloque, sufijo)
        cadena_valida = bloque;
        fprintf('✅ Bloque %d válido encontrado.\n', i);
        break;
    else
        fprintf('❌ Bloque %d inválido (no tiene 50 "a" y 50 "b").\n', i);
    end
end

% === Guardar bloque si fue encontrado ===
if isempty(cadena_valida)
    error('⚠️ No se encontró ningún bloque válido. Terminando ejecución.');
else
    output_file = 'cadena_valida_extraida.txt';
    fid = fopen(output_file, 'w');
    fprintf(fid, '%s', cadena_valida);
    fclose(fid);
    fprintf('📁 Cadena válida guardada en "%s"\n', output_file);
end

%% === PARTE 2: Decodificación y reconstrucción de imagen ===

% === Configuración de la imagen ===
rows = 103;         % Alto
cols = 200;         % Ancho
channels = 3;       % RGB
expected_length = 82400;

% === Leer bloque guardado ===
fid = fopen(output_file, 'r');
lines = textscan(fid, '%s', 'Delimiter', '\n');
fclose(fid);
cadena_completa = strjoin(lines{1}, '');
cadena_completa = char(cadena_completa);
disp(['📖 Longitud leída: ', num2str(strlength(cadena_completa))]);

% === Detección de delimitadores ===
num_a = 0;
while num_a < min(1000, strlength(cadena_completa)) && cadena_completa(num_a+1) == 'a'
    num_a = num_a + 1;
end

num_b = 0;
while num_b < min(1000, strlength(cadena_completa)) && cadena_completa(end-num_b) == 'b'
    num_b = num_b + 1;
end

fprintf('🔍 Detectados: %d "a" iniciales y %d "b" finales.\n', num_a, num_b);

% === Extraer base64 puro ===
if num_a > 0 || num_b > 0
    cadena_base64 = extractBetween(cadena_completa, num_a+1, strlength(cadena_completa)-num_b);
    cadena_base64 = char(cadena_base64);
else
    cadena_base64 = cadena_completa;
    disp('⚠️ No se detectaron delimitadores "a"/"b".');
end

% === Verificar longitud base64 ===
if strlength(cadena_base64) < expected_length
    ceros_necesarios = expected_length - strlength(cadena_base64);
    cadena_base64 = [repmat('0', 1, ceros_necesarios), cadena_base64];
    fprintf('🔧 Añadidos %d ceros al inicio.\n', ceros_necesarios);
elseif strlength(cadena_base64) > expected_length
    error('❌ La cadena Base64 excede el tamaño esperado.');
end

% === Decodificación Base64 ===
try
    img_decoded = matlab.net.base64decode(cadena_base64);
    disp('✅ Decodificación exitosa.');
catch ME
    error('❌ Error al decodificar: %s', ME.message);
end

% === Reconstrucción de imagen ===
try
    img_reconstructed = reshape(img_decoded, rows, cols, channels);
    fprintf('🖼️ Imagen reconstruida: %dx%dx%d\n', rows, cols, channels);
catch
    error('❌ Error al reconstruir la imagen. Verifica dimensiones.');
end

% === Visualización y guardado ===
figure;
imshow(img_reconstructed);
title(sprintf('Imagen Reconstruida (%dx%d RGB)', rows, cols));
imwrite(img_reconstructed, 'imagen_reconstruida.png');
disp('💾 Imagen guardada como "imagen_reconstruida.png"');