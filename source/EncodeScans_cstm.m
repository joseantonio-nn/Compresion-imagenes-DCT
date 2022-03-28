function [CodedY, CodedCb, CodedCr, bits_Y_DC, bits_Y_AC, bits_C_DC, bits_C_AC, huffval_Y_DC, huffval_Y_AC, huffval_C_DC, huffval_C_AC] = EncodeScans_cstm(XScan)

% EncodeScans_custom: Codifica en binario los tres scan usando códigos
% Huffman custom
% Basado en el script que realiza lo mismo con tablas Huffman por defecto

% Entradas:
%  XScan: Scans de luminancia Y y crominancia Cb y Cr: Matriz mamp x namp X 3
%  compuesta de:
%   YScan: Scan de luminancia Y: Matriz mamp x namp
%   CbScan: Scan de crominancia Cb: Matriz mamp x namp
%   CrScan: Scan de crominancia Cr: Matriz mamp x namp
% Salidas:
% Entradas:
%   CodedY: String binario con scan Y codificado
%   CodedCb: String binario con scan Cb codificado
%   CodedCr: String binario con scan Cr codificado
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

disptext=1; % Flag de verbosidad
if disptext
    disp('--------------------------------------------------');
    disp('Funcion EncodeScans_cstm:');
end

% Instante inicial
tc = cputime;

% Separación de las matrices bidimensionales 
%  para procesar separadamente
YScan = XScan(:,:,1);
CbScan = XScan(:,:,2);
CrScan = XScan(:,:,3);

% Recolección de los valores a codificar
[Y_DC_CP, Y_AC_ZCP] = CollectScan(YScan);
[Cb_DC_CP, Cb_AC_ZCP] = CollectScan(CbScan);
[Cr_DC_CP, Cr_AC_ZCP] = CollectScan(CrScan);

% Unión de las matrices de crominancias a codificar
C_DC_CP = [Cb_DC_CP(:,1); Cr_DC_CP(:,1)]; 
C_AC_ZCP = [Cb_AC_ZCP(:,1); Cr_AC_ZCP(:,1)]; 

% Construcción de tablas Huffman para Luminancia y Crominancia
% Genera Tablas Huffman custom que serán archivadas
% La variable ehuf_X_X es la concatenacion [EHUFCO EHUFSI]
% Tablas de luminancia
% Tabla Y_DC
[ehuf_Y_DC, bits_Y_DC, huffval_Y_DC] = HufCodTables_cstm(Y_DC_CP);
% Tabla Y_AC
[ehuf_Y_AC, bits_Y_AC, huffval_Y_AC] = HufCodTables_cstm(Y_AC_ZCP);

% Tablas de crominancia
% Tabla C_DC
[ehuf_C_DC, bits_C_DC, huffval_C_DC] = HufCodTables_cstm(C_DC_CP);
% Tabla C_AC
[ehuf_C_AC, bits_C_AC, huffval_C_AC] = HufCodTables_cstm(C_AC_ZCP);


% Codificación en binario cada Scan
% Las tablas de crominancia, ehuf_C_DC y ehuf_C_AC, se aplican, tanto a Cb, como a Cr
CodedY = EncodeSingleScan(YScan, Y_DC_CP, Y_AC_ZCP, ehuf_Y_DC, ehuf_Y_AC);
CodedCb = EncodeSingleScan(CbScan, Cb_DC_CP, Cb_AC_ZCP, ehuf_C_DC, ehuf_C_AC);
CodedCr = EncodeSingleScan(CrScan, Cr_DC_CP, Cr_AC_ZCP, ehuf_C_DC, ehuf_C_AC);

% Tiempo de ejecucion
e = cputime - tc;

if disptext
    disp('Componentes codificadas en binario');
    fprintf('%s %1.6f\n', 'Tiempo de CPU:', e);
    disp('Terminado EncodeScans_cstm');
end

end