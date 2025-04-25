%% Crear nuevo archivo sin saltos de línea
clear; clc;

% 1. Nombre del archivo original
archivo_entrada = 'imagen_base64_formato_lineas.txt';  % ← Cámbialo por el tuyo

% 2. Nombre del nuevo archivo
archivo_salida = 'archivo_sin_saltos.txt';

% 3. Leer todo el contenido como texto plano
texto = fileread(archivo_entrada);

% 4. Eliminar todos los saltos de línea (\n)
texto_sin_saltos = erase(texto, newline);

% 5. Guardar el texto limpio en un nuevo archivo
fid = fopen(archivo_salida, 'w');
fprintf(fid, '%s', texto_sin_saltos);
fclose(fid);

% 6. Confirmación
disp(['✅ Archivo limpio guardado como: ', archivo_salida]);
