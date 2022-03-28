function MSE = calcularMSE(fname1, fname2) 
% Función que calcula el MSE entre dos imágenes
% Entradas:
%   fname1: primera imagen
%   fname2: segunda imagen
% Salidas:
%   MSE: error cuadrático medio

[Xorg, ~, ~, m, n, ~, ~, ~] = imlee(fname1);
[Xrec, ~, ~, ~, ~, ~, ~, ~] = imlee(fname2);
MSE = (sum(sum(sum((double(Xrec) - double(Xorg)).^2))))/(m * n * 3);

end