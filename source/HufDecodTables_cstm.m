function [MINCODE, MAXCODE, VALPTR] = HufDecodTables_cstm(BITS, HUFFVAL) 

% Genera tablas de decodificacion custom
% Basado en HufDecodTables_dflt

% Entradas:
%   BITS: Vector columna que contiene el número de palabras código que se van 
%       a generar de cada tamaño (longitud de palabra), desde longitud 1 hasta 
%       longitud máxima de 16 bits
%   HUFFVAL: Vector columna con los mensajes en orden creciente de longitud de palabra
%       En HUFFVAL estan solo los mensajes presentes en la secuencia
%       Su longitud es el nº de mensajes distintos en la secuencia
%       Los mensajes son enteros entre 0 y 255

% Salidas:
%   MINCODE: Codigo mas pequeño de cada longitud
%       Vector columna g x 1, con g igual a nº de grupos de longitdes
%   MAXCODE: Codigo mas grande de cada longitud
%       Vector columna g x 1, con g igual a nº de grupos de longitdes
%   VALPTR: Indice al primer valor de HUFFVAL que
%       se decodifica con una palabra de long. i
%       Vector columna g x 1, con g igual a nº de grupos de longitdes


% Construcción de las tablas del código Huffman
[~, HUFFCODE] = HCodeTables(BITS, HUFFVAL);

% Generación de las tablas MINCODE, MAXCODE y VALPTR
[MINCODE, MAXCODE, VALPTR] = HDecodingTables(BITS, HUFFCODE);

end