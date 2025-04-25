% ORGANIZADOR DE ARCHIVO EN 101 LÍNEAS DE 780 CARACTERES
clc; clear; close all;

% 1. Leer el archivo con una sola línea
input_filename = 'tramaquellego.txt'; % Archivo con una sola línea larga
fileID = fopen(input_filename, 'r');
linea_unica = fgetl(fileID); % Leer la única línea del archivo
fclose(fileID);

% 2. Verificar que la longitud sea 78,780 caracteres
if length(linea_unica) ~= 78780
    error('La longitud de la línea no es la esperada (78,780 caracteres). Tiene %d caracteres.', length(linea_unica));
end

% 3. Dividir la línea en 101 filas de 780 caracteres
lineas = reshape(linea_unica, 780, [])'; % Crear una matriz donde cada fila tiene 780 caracteres

% 4. Guardar las líneas formateadas en un nuevo archivo
output_filename = 'borrar_formateado.txt'; % Nombre del archivo de salida
fileID = fopen(output_filename, 'w');
for i = 1:size(lineas, 1)
    fprintf(fileID, '%s\n', lineas(i, :));
end
fclose(fileID);

disp(['✅ Archivo organizado y guardado como "', output_filename, '".']);
