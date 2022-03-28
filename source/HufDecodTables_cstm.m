function [MINCODE, MAXCODE, VALPTR] = HufDecodTables_cstm(BITS, HUFFVAL) 

% Genera tablas de decodificacion custom
% Basado en HufDecodTables_dflt

% Entradas:
%   BITS: Vector columna que contiene el n�mero de palabras c�digo que se van 
%       a generar de cada tama�o (longitud de palabra), desde longitud 1 hasta 
%       longitud m�xima de 16 bits
%   HUFFVAL: Vector columna con los mensajes en orden creciente de longitud de palabra
%       En HUFFVAL estan solo los mensajes presentes en la secuencia
%       Su longitud es el n� de mensajes distintos en la secuencia
%       Los mensajes son enteros entre 0 y 255

% Salidas:
%   MINCODE: Codigo mas peque�o de cada longitud
%       Vector columna g x 1, con g igual a n� de grupos de longitdes
%   MAXCODE: Codigo mas grande de cada longitud
%       Vector columna g x 1, con g igual a n� de grupos de longitdes
%   VALPTR: Indice al primer valor de HUFFVAL que
%       se decodifica con una palabra de long. i
%       Vector columna g x 1, con g igual a n� de grupos de longitdes


% Construcci�n de las tablas del c�digo Huffman
[~, HUFFCODE] = HCodeTables(BITS, HUFFVAL);

% Generaci�n de las tablas MINCODE, MAXCODE y VALPTR
[MINCODE, MAXCODE, VALPTR] = HDecodingTables(BITS, HUFFCODE);

end