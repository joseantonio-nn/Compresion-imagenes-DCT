function FreqM = FreqMatrix(x)

% Cuenta frecuencia de caracteres en una matriz x con enteros en [0,255]

% Entradas
%   x: Matriz con enteros en [0, 255] (Secuencia de mensajes de una fuente)
%
% Salidas
%   FreqM: Vector columna de 256 enteros con las frecuencias de los enteros presentes 
%       en la secuencia x indexada por enteros 0 a 255 

ncolumnas = size(x, 2);
z = zeros(256, 1);

for i = 1:ncolumnas
    z = z + Freq256(x(:,i));
end

FreqM = z;

end