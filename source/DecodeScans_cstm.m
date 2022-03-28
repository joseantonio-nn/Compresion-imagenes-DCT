function XScanrec = DecodeScans_cstm(CodedY, CodedCb, CodedCr, tam, bits_Y_DC, bits_Y_AC, bits_C_DC, bits_C_AC, huffval_Y_DC, huffval_Y_AC, huffval_C_DC, huffval_C_AC)

% DecodeScans_custom: Decodifica los tres scans binarios usando Huffman

% Entradas:
%   CodedY: String binario con scan Y codificado
%   CodedCb: String binario con scan Cb codificado
%   CodedCr: String binario con scan Cr codificado
%   tam: Tamaño del scan a devolver [mamp namp]
%   bits_Y_DC: Vector columna que contiene el número de palabras código que 
%       se van a generar de cada tamaño, desde longitud 1 hasta longitud 
%       máxima de 16 bits, para la matriz de los coeficientes DC de la luminancia
%   bits_Y_AC: Vector columna que contiene el número de palabras código que 
%       se van a generar de cada tamaño, desde longitud 1 hasta longitud 
%       máxima de 16 bits, para la matriz de los coeficientes AC de la luminancia
%   bits_C_DC: Vector columna que contiene el número de palabras código que 
%       se van a generar de cada tamaño, desde longitud 1 hasta longitud 
%       máxima de 16 bits, para la matriz de los coeficientes DC de las
%       crominancias
%   bits_C_AC: Vector columna que contiene el número de palabras código que 
%       se van a generar de cada tamaño, desde longitud 1 hasta longitud 
%       máxima de 16 bits, para la matriz de los coeficientes AC de las
%       crominancias
%   huffval_Y_DC: Vector columna que contiene los símbolos de la fuente cuantizados, 
%       ordenados por longitudes crecientes de la palabra código que les
%       corresponderá, para la matriz de los coeficientes DC de la luminancia
%   huffval_Y_AC: Vector columna que contiene los símbolos de la fuente cuantizados, 
%       ordenados por longitudes crecientes de la palabra código que les
%       corresponderá, para la matriz de los coeficientes AC de la luminancia
%   huffval_C_DC: Vector columna que contiene los símbolos de la fuente cuantizados, 
%       ordenados por longitudes crecientes de la palabra código que les
%       corresponderá, para la matriz de los coeficientes DC de las
%       crominancias
%   huffval_C_AC: Vector columna que contiene los símbolos de la fuente cuantizados, 
%       ordenados por longitudes crecientes de la palabra código que les
%       corresponderá, para la matriz de los coeficientes AC de las
%       crominancias
%
% Salidas:
%  XScanrec: Scans reconstruidos de luminancia Y y crominancia Cb y Cr: Matriz mamp x namp X 3

disptext=1; % Flag de verbosidad
if disptext
    disp('--------------------------------------------------');
    disp('Funcion DecodeScans_cstm:');
end

% Instante inicial
tc = cputime;

% Generación de las tablas de decodificación
% Tablas de luminancia
% Tabla Y_DC
[mincode_Y_DC, maxcode_Y_DC, valptr_Y_DC] = HufDecodTables_cstm(bits_Y_DC, huffval_Y_DC);
% Tabla Y_AC
[mincode_Y_AC, maxcode_Y_AC, valptr_Y_AC] = HufDecodTables_cstm(bits_Y_AC, huffval_Y_AC);

% Tablas de crominancia
% Tabla Cb y Cr
[mincode_C_DC, maxcode_C_DC, valptr_C_DC] = HufDecodTables_cstm(bits_C_DC, huffval_C_DC);
[mincode_C_AC, maxcode_C_AC, valptr_C_AC] = HufDecodTables_cstm(bits_C_AC, huffval_C_AC);

% Decodificación en binario de cada Scan
% Las tablas de crominancia se aplican, tanto a Cb, como a Cr
YScanrec = DecodeSingleScan(CodedY, mincode_Y_DC, maxcode_Y_DC, valptr_Y_DC, huffval_Y_DC, mincode_Y_AC, maxcode_Y_AC, valptr_Y_AC, huffval_Y_AC, tam);
CbScanrec = DecodeSingleScan(CodedCb, mincode_C_DC, maxcode_C_DC, valptr_C_DC, huffval_C_DC, mincode_C_AC, maxcode_C_AC, valptr_C_AC, huffval_C_AC, tam);
CrScanrec = DecodeSingleScan(CodedCr, mincode_C_DC, maxcode_C_DC, valptr_C_DC, huffval_C_DC, mincode_C_AC, maxcode_C_AC, valptr_C_AC, huffval_C_AC, tam);

% Reconstrucción de la matriz 3-D
XScanrec = cat(3, YScanrec, CbScanrec, CrScanrec);

% Tiempo de ejecucion
e = cputime - tc;

if disptext
    disp('Scans decodificados');
    fprintf('%s %1.6f\n', 'Tiempo de CPU:', e);
    disp('Terminado DecodeScans_cstm');
end