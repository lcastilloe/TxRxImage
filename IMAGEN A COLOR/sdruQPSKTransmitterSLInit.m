function SimParams = sdruQPSKTransmitterSLInit(platform, useCodegen, isHDLCompatible)
%   Copyright 2023 The MathWorks, Inc.

%% General simulation parameters

if isHDLCompatible
    SimParams.Rsym = 0.5e6;          % Symbol rate in Hertz
                                   % If HDL compatible, code will not be optimized in performance
else
    if useCodegen
        SimParams.Rsym = 5e6;      % Symbol rate in codegen path
    else
        SimParams.Rsym = 2.5e6;
    end
end

SimParams.ModulationOrder = 4;      % QPSK alphabet size
SimParams.Interpolation = 2;        % Interpolation factor
SimParams.Decimation = 1;           % Decimation factor
SimParams.Tsym = 1/SimParams.Rsym;  % Symbol time in sec
SimParams.Fs   = SimParams.Rsym * SimParams.Interpolation; % Sample rate

%% Frame Specifications
% [BarkerCode*2 | 'Hello world 000\n' | 'Hello world 001\n' ...];
SimParams.BarkerCode      = [+1 +1 +1 +1 +1 -1 -1 +1 +1 -1 +1 -1 +1];     % Bipolar Barker Code
SimParams.BarkerLength    = length(SimParams.BarkerCode);
SimParams.HeaderLength    = SimParams.BarkerLength * 2;                   % Duplicate 2 Barker codes to be as a header
%% Message generation desde archivo
filename = 'imagen_color_bits_formato_101_lineas.txt'; % Asegúrate de tener este archivo con 100 líneas

fid = fopen(filename, 'r');
if fid == -1
    error('No se pudo abrir el archivo %s', filename);
end

lines = textscan(fid, '%s',101, 'Delimiter', '\n');
fclose(fid);
mensajes = lines{1};

% Concatenar todos los caracteres de los mensajes
msgChars = char(join(mensajes, ''));  % los convierte en una sola cadena
asciiVals = double(msgChars);         % convierte cada carácter en su valor ASCII
bits = de2bi(asciiVals, 7, 'left-msb')'; % convierte ASCII a bits (7 bits por carácter)
SimParams.MessageBits = bits(:);      % vector columna con todos los bits

% Actualizar parámetros dependientes del archivo
SimParams.NumberOfMessage = numel(mensajes);
SimParams.PayloadLength   = length(SimParams.MessageBits);
SimParams.MessageLength   = round(SimParams.PayloadLength / (SimParams.NumberOfMessage * 7));
SimParams.FrameSize       = (SimParams.HeaderLength + SimParams.PayloadLength) / log2(SimParams.ModulationOrder);
SimParams.FrameTime       = SimParams.Tsym * SimParams.FrameSize;
%% Tx parameters
SimParams.RolloffFactor     = 0.5;                                        % Rolloff Factor of Raised Cosine Filter
SimParams.ScramblerBase     = 2;
SimParams.ScramblerPolynomial           = [1 1 1 0 1];
SimParams.ScramblerInitialConditions    = [0 0 0 0];
SimParams.RaisedCosineFilterSpan = 10; % Filter span of Raised Cosine Tx Rx filters (in symbols)


%% USRP transmitter parameters
switch platform
  case {'B200','B210'}
    SimParams.MasterClockRate = 20e6;           % Hz
  case {'X300','X310'}
    SimParams.MasterClockRate = 200e6;          % Hz
  case {'N300','N310'}
    SimParams.MasterClockRate = 125e6;          % Hz
  case {'N320/N321'}
    SimParams.MasterClockRate = 200e6;          % Hz
  case {'N200/N210/USRP2'}
    SimParams.MasterClockRate = 100e6;          % Hz
  otherwise
    error(message('sdru:examples:UnsupportedPlatform', ...
      platform))
end
SimParams.USRPCenterFrequency       = 915e6;
SimParams.USRPGain                  = 25;
SimParams.USRPFrontEndSampleRate    = SimParams.Rsym * 2; % Nyquist sampling theorem
SimParams.USRPInterpolationFactor   = SimParams.MasterClockRate/SimParams.USRPFrontEndSampleRate;
SimParams.USRPFrameLength           = SimParams.Interpolation * SimParams.FrameSize;

% Experiment Parameters
SimParams.USRPFrameTime = SimParams.USRPFrameLength/SimParams.USRPFrontEndSampleRate;
SimParams.StopTime=1000;