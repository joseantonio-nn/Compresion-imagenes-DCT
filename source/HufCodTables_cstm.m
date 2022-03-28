function [EHUF, BITS, HUFFVAL] = HufCodTables_cstm(x)

% Genera tablas de codificacion custom
% Basado en HufCodTables_dflt

% Entradas:
%   x: Posibles dos valores:
%       Diferencias entre DC de bloques adyacentes
%           Tama�o: (nbv * nbh) x 2
%           Col 1: C (Categoria)
%           Col 2: P (Posicion en categoria)
%   
%       Scan codificado c�digo/longitud de palabra
%           Tama�o: Filas indeterminadas. Columnas: 2
%           Col 1: ZCdec (Par Z/C en decimal)
%           Col 2: P (Posicion en categoria)
%
% Salidas
%   EHUF: Es la concatenacion [EHUFCO EHUFSI], donde;
%     EHUFCO: Vector columna con palabras codigo expresadas en decimal
%       Esta indexado por los 256 mensajes de la fuente, 
%       en orden creciente de estos (offset 1)
%     EHUFSI: Vector columna con las longitudes de todas las palabras codigo
%       Esta indexado por los 256 mensajes de la fuente, 
%       en orden creciente de estos (offset 1)
%   BITS: Vector columna que contiene el n�mero de palabras c�digo que se van 
%       a generar de cada tama�o (longitud de palabra), desde longitud 1 hasta 
%       longitud m�xima de 16 bits
%   HUFFVAL: Vector columna con los mensajes en orden creciente de longitud de palabra
%       En HUFFVAL estan solo los mensajes presentes en la secuencia
%       Su longitud es el n� de mensajes distintos en la secuencia
%       Los mensajes son enteros entre 0 y 255

% Obtiene frecuencias de mensajes contenidos en x
%   Hay un offset: FREQ(1) es frecuencia del entero 0
FREQ = Freq256(x);

% Construcci�n de las Tablas de Especificacion Huffman
[BITS, HUFFVAL] = HSpecTables(FREQ);

% Construcci�n de las Tablas del Codigo Huffman
[HUFFSIZE, HUFFCODE] = HCodeTables(BITS, HUFFVAL);

% Construcci�n Tablas de Codificacion Huffman
[EHUFCO, EHUFSI] = HCodingTables(HUFFSIZE, HUFFCODE, HUFFVAL);

EHUF = [EHUFCO EHUFSI];

end