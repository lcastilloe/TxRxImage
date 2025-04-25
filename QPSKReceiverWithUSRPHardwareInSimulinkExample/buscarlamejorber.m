clc;
clear;
close all;

% === PARTE 1: EXTRAER BLOQUE VÁLIDO DE 78780 CARACTERES ===
longitud_total = 78780;  % 30 'a' + 78720 bits + 30 'b'
prefijo = repmat('a', 1, 30);
sufijo  = repmat('b', 1, 30);

% Archivo original con cadenas largas
archivo_tramas = 'Prueba40TX20RX.txt';
contenido = fileread(archivo_tramas);
total_caracteres = length(contenido);

fprintf('📄 Total de caracteres en el archivo: %d\n', total_caracteres);
num_bloques = floor(total_caracteres / longitud_total);
fprintf('🔍 Se detectaron %d posibles bloques de 78780 caracteres.\n', num_bloques);

% Preasignar la celda tramas
tramas = cell(num_bloques, 1);

% Extraer bloques válidos
for i = 1:num_bloques
    inicio = (i - 1) * longitud_total + 1;
    fin = inicio + longitud_total - 1;
    bloque = contenido(inicio:fin);

    % Verificar inicio, final y longitud exacta
    if startsWith(bloque, prefijo) && endsWith(bloque, sufijo) && length(bloque) == longitud_total
        tramas{i} = bloque;  % Guardar la trama válida
        fprintf('✅ Bloque %d válido encontrado (longitud %d).\n', i, length(bloque));
    end
end

% === PARTE 2: LEER EL ARCHIVO DE REFERENCIA Y CALCULAR SIMILITUD ===
archivo_referencia = 'imagen_color_bits_formato_101_lineas.txt';
contenido_referencia = fileread(archivo_referencia);

% Comparar las tramas utilizando la distancia Hamming
num_tramas = length(tramas);
distancias = zeros(num_tramas, 1);

% Asegurarse de que ambas cadenas sean del mismo tamaño
contenido_referencia = contenido_referencia(1:longitud_total);  % Ajustar tamaño de referencia si es necesario

for i = 1:num_tramas
    % Comparar cada trama con el archivo de referencia (puede ser con un bloque de referencia o todo el contenido)
    trama_binaria = double(tramas{i}) - double('0');
    referencia_binaria = double(contenido_referencia) - double('0');
    
    % Asegurarse de que ambas tramas tengan el mismo tamaño
    if length(trama_binaria) ~= length(referencia_binaria)
        % Si no coinciden en tamaño, recortar o rellenar con ceros
        if length(trama_binaria) < length(referencia_binaria)
            trama_binaria = [trama_binaria, zeros(1, length(referencia_binaria) - length(trama_binaria))];
        else
            referencia_binaria = [referencia_binaria, zeros(1, length(trama_binaria) - length(referencia_binaria))];
        end
    end
    
    % Comparar las tramas utilizando la distancia Hamming
    distancias(i) = sum(trama_binaria ~= referencia_binaria) / longitud_total;  % Distancia Hamming normalizada
end

% Ordenar las tramas por distancia de similitud (menor distancia = más similar)
[~, indices_similares] = sort(distancias);

% === PARTE 3: CALCULAR EL BER PARA LAS 50 TRAMAS MÁS SIMILARES ===
num_tramas_comparadas = 50;  % Número de tramas a comparar
ber_values = zeros(num_tramas_comparadas, 1);

% Leer la trama original (referencia) para comparar
original_bit_vector = double(contenido_referencia) - double('0');

for i = 1:num_tramas_comparadas
    % Obtener la trama más parecida
    trama_decodificada = tramas{indices_similares(i)};
    
    % Decodificar la trama a vector de bits
    bit_vector_trama = double(trama_decodificada) - double('0');
    
    % Comparar el bit_vector_trama con el original
    bit_errors = sum(bit_vector_trama ~= original_bit_vector);  % Número de errores de bits
    total_bits = length(original_bit_vector);
    
    % Calcular BER
    ber_values(i) = bit_errors / total_bits;
end

% === PARTE 4: CALCULAR EL PROMEDIO DEL BER ===
ber_promedio = mean(ber_values);
fprintf('El BER promedio de las 50 tramas más similares es: %.5e\n', ber_promedio);

% Mostrar los resultados de BER para cada una de las 50 tramas más similares
disp('BER para las 50 tramas más similares:');
disp(ber_values);

% === PARTE 5: GUARDAR LOS 50 VALORES DE BER EN UN ARCHIVO DE TEXTO ===
archivo_ber = 'valores_ber.txt';  % Nombre del archivo de salida
fid = fopen(archivo_ber, 'w');  % Abrir el archivo en modo escritura

% Verificar si se abrió correctamente el archivo
if fid == -1
    error('No se pudo abrir el archivo %s para escritura.', archivo_ber);
end

% Escribir los valores de BER en el archivo
fprintf(fid, 'Índice\tBER\n');  % Encabezado
for i = 1:num_tramas_comparadas
    fprintf(fid, '%d\t%.5e\n', i, ber_values(i));
end

fclose(fid);  % Cerrar el archivo

fprintf('✅ Los valores de BER fueron guardados en "%s"\n', archivo_ber);

% === PARTE 6: GUARDAR LOS 50 VALORES DE BER EN UN ARCHIVO CSV ===
archivo_ber_csv = 'valores_ber.csv';  % Nombre del archivo de salida

% Crear una matriz de valores para guardar
resultados_ber = [(1:num_tramas_comparadas)', ber_values];

% Guardar la matriz en formato CSV
writematrix(resultados_ber, archivo_ber_csv);

fprintf('✅ Los valores de BER fueron guardados en "%s"\n', archivo_ber_csv);
