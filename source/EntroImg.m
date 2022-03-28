function H = EntroImg(x)

% Dada una imagen, calcula su entropia H

% Entradas:
%   x: Matriz con enteros en [0, 255] que representa a una imagen 

% Salidas:
%   H: Entropia de x en bits

n = size(x, 2) * size(x, 1);
v = FreqMatrix(x);
p = v ./ n;

H = Entro(p);

end