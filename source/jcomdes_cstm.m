function [RC, MSE] = jcomdes_cstm(fname, caliQ)

% jcomdes_cstm: Compresion y descompresion de imagenes basada en transformadas
%               y usando tablas Huffman custom para codificar y decodificar

% Entradas:
%  fname: Un string con nombre de archivo, incluido sufijo
%         Admite BMP y JPEG, indexado y truecolor
%  caliQ: Factor de calidad (entero positivo >= 1)
%         100: calidad estandar
%         >100: menor calidad
%         <100: mayor calidad
% Salidas:
%  Ninguna. Solo visualización de imagenes original y procesada

disptext=1; % Flag de verbosidad
if disptext
    disp('--------------------------------------------------');
    disp('Funcion jcomdes:');
end

% Instante inicial
tc = cputime;

% Compresor
[RC, H, notZeroCoef, fichero_comp] = jcom_cstm(fname, caliQ);
% Descompresor
MSE = jdes_cstm(fichero_comp);

% Tiempo de ejecucion
e = cputime - tc;

if disptext
disp('Compresión y descompresión terminadas');
disp('--------------------------------------------------');
fprintf('%s %1.6f\n', 'Tiempo total de CPU:', e);
fprintf("RC: %f\n", RC);
fprintf("MSE: %f\n", MSE);
fprintf("Entropía de la imagen: %f\n", H);
fprintf("Número de coeficientes no nulos: %d\n", notZeroCoef);
disp('--------------------------------------------------');
disp('Terminado jcomdes_cstm');
disp('--------------------------------------------------');
end

end