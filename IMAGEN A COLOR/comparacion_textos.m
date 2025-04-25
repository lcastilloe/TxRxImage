% Leer el archivo de texto original
filename = 'outputPP10.txt'; % Cambia este nombre por el de tu archivo
fileID = fopen(filename, 'r');
data = fread(fileID, '*char')';
fclose(fileID);

% Buscar el patrón que comienza con entre 106 y 116 'a' y termina con entre 106 y 116 'b'
pattern = '(a{106,116})(.*?)(b{106,116})'; % Captura inicio, contenido y fin
matches = regexp(data, pattern, 'tokens'); % Busca coincidencias y separa en grupos

% Inicializar variables para almacenar resultados filtrados
filtered_matches = [];
filtered_differences = [];

% Analizar cada coincidencia
for i = 1:length(matches)
    match = matches{i}; % Extraer el grupo actual
    content = match{2}; % Contenido entre las 'a' y las 'b'
    
    % Contar caracteres diferentes a '0' y '1'
    non_binary_count = sum(~ismember(content, '01'));
    
    % Guardar solo las cadenas válidas y sus diferencias
    if non_binary_count > 0
        filtered_matches = [filtered_matches; join(match, '')]; %#ok<AGROW>
        filtered_differences = [filtered_differences; non_binary_count]; %#ok<AGROW>
    end
end

% Seleccionar las 3 cadenas con la menor cantidad de caracteres no binarios
[~, indices] = sort(filtered_differences); % Ordenar por menor cantidad de diferencias
selected_matches = filtered_matches(indices(1:min(3, length(indices)))); % Tomar las primeras 3

% Evaluar las cadenas seleccionadas para encontrar la más cercana a 26,240 caracteres entre la última 'a' y la última 'b'
closest_match = '';
min_difference = inf;

for i = 1:length(selected_matches)
    current_match = selected_matches{i};
    
    % Encontrar la posición de la última 'a' y la última 'b'
    last_a_idx = find(current_match == 'a', 1, 'last');
    last_b_idx = find(current_match == 'b', 1, 'last');
    
    % Calcular la cantidad de caracteres entre la última 'a' y la última 'b'
    char_count = last_b_idx - last_a_idx - 1;
    
    % Verificar si es más cercana a 26,240 caracteres
    difference = abs(char_count - 26240);
    if difference < min_difference
        min_difference = difference;
        closest_match = current_match;
    end
end

% Guardar la cadena más cercana en un tercer archivo
output_filename = 'borrar.txt';
fileID = fopen(output_filename, 'w');

if ~isempty(closest_match)
    fprintf(fileID, '%s\n', closest_match);
    fprintf('La cadena más cercana a 26,240 caracteres guardada en "%s".\n', output_filename);
else
    fprintf('No se encontró una cadena válida para guardar.\n');
end

fclose(fileID);
