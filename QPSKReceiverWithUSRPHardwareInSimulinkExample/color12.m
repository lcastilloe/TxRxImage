clc; clear; close all;

%% === PARTE 1: EXTRAER BLOQUE VÁLIDO DE 78780 CARACTERES ===
longitud_total = 78780;  % 30 'a' + 78720 bits + 30 'b'
prefijo = repmat('a', 1, 30);
sufijo  = repmat('b', 1, 30);

filename = 'outputPP14.txt';  % Archivo original con cadenas largas
contenido = fileread(filename);
total_caracteres = length(contenido);

fprintf('📄 Total de caracteres en el archivo: %d\n', total_caracteres);
num_bloques = floor(total_caracteres / longitud_total);
fprintf('🔍 Se detectaron %d posibles bloques de 78780 caracteres.\n', num_bloques);

cadena_valida = '';
for i = 1:num_bloques
    inicio = (i - 1) * longitud_total + 1;
    fin = inicio + longitud_total - 1;
    bloque = contenido(inicio:fin);

    % Verificar inicio, final y longitud exacta
    if startsWith(bloque, prefijo) && endsWith(bloque, sufijo) && length(bloque) == longitud_total
        cadena_valida = bloque;
        fprintf('✅ Bloque %d válido encontrado (longitud %d).\n', i, length(bloque));
        break;
    else
        fprintf('❌ Bloque %d inválido (longitud %d, no cumple requisitos).\n', i, length(bloque));
    end
end

if isempty(cadena_valida)
    error('⚠️ No se encontró ninguna cadena válida con 30 "a", 30 "b" y 78780 caracteres.');
end

%% === PARTE 2: FORMATEAR EN 101 LÍNEAS DE 780 CARACTERES ===
lineas = reshape(cadena_valida, 780, [])';  % Cada fila es una línea de 780 caracteres
filename_out = 'espacios.txt';
fid = fopen(filename_out, 'w');
for i = 1:size(lineas,1)
    fprintf(fid, '%s\n', lineas(i,:));
end
fclose(fid);
fprintf('✅ Archivo formateado guardado como "%s"\n', filename_out);

%% === PARTE 3: DECODIFICACIÓN Y RECONSTRUCCIÓN DE LA IMAGEN ===

% Parámetros conocidos de la imagen
rows = 41;
cols = 80;
channels = 3;  % RGB
bits_per_pixel = 8;
total_pixels = rows * cols * channels;
total_bits = total_pixels * bits_per_pixel;

% Leer y unir todas las líneas del archivo formateado
fid = fopen(filename_out, 'r');
if fid == -1
    error('No se pudo abrir el archivo %s', filename_out);
end
lineas = textscan(fid, '%s', 'Delimiter', '\n'); fclose(fid);
cadena = strjoin(lineas{1}, '');

% Verificación de longitud total
if length(cadena) ~= 78780
    error('La cadena no tiene 78780 caracteres. Tiene %d.', length(cadena));
end

% Eliminar 30 'a' y 30 'b'
cadena_bits_puros = cadena(31:end-30);

% Limpiar la cadena: reemplazar todo lo que no sea '0' o '1' por '0'
mascara_binaria = (cadena_bits_puros == '0') | (cadena_bits_puros == '1');
if ~all(mascara_binaria)
    num_corruptos = sum(~mascara_binaria);
    fprintf('⚠️ Se detectaron %d caracteres no binarios. Serán reemplazados por ''0''.\n', num_corruptos);
    cadena_bits_puros(~mascara_binaria) = '0';  % O usa '1' si prefieres
end

% Convertir a vector de bits numéricos
bit_vector = double(cadena_bits_puros) - double('0');

% Asegurar tamaño correcto
if length(bit_vector) < total_bits
    bit_vector = [bit_vector, zeros(1, total_bits - length(bit_vector))];
elseif length(bit_vector) > total_bits
    bit_vector = bit_vector(1:total_bits);
end

% Reconstruir la imagen
bit_matrix = reshape(bit_vector, bits_per_pixel, []).';
pixel_values = uint8(bi2de(bit_matrix, 'left-msb'));
img_reconstruida = reshape(pixel_values, [rows, cols, channels]);

% Mostrar imagen
figure;
imshow(img_reconstruida);
title('🖼️ Imagen Color Reconstruida desde archivo TXT');

disp('✅ Imagen reconstruida correctamente.');