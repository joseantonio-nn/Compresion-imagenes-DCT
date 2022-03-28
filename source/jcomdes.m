function [RC, MSE] = jcomdes(fname, caliQ)

% jcomdes: Compresion y descompresion de imagenes basada en transformadas
%          y usando tablas Huffman por defecto para codificar y decodificar

% Entradas:
%  fname: Un string con nombre de archivo, incluido sufijo
%         Admite BMP y JPEG, indexado y truecolor
%  caliQ: Factor de calidad (entero positivo >= 1)
%         100: calidad estandar
%         >100: menor calidad
%         <100: mayor calidad
% Salidas:
%  Ninguna. Solo visualizaci�n de imagenes original y procesada

disptext=1; % Flag de verbosidad
if disptext
    disp('--------------------------------------------------');
    disp('Funcion jcomdes:');
end

% Instante inicial
tc = cputime;

% Compresor
[RC, H, Hc, notZeroCoef, fichero_comp] = jcom_dflt(fname, caliQ);
% Descompresor
MSE = jdes_dflt(fichero_comp);

% Tiempo de ejecucion
e = cputime - tc;

if disptext
disp('Compresi�n y descompresi�n terminadas');
disp('--------------------------------------------------');
fprintf('%s %1.6f\n', 'Tiempo total de CPU:', e);
fprintf("RC: %f\n", RC);
fprintf("MSE: %f\n", MSE);
fprintf("Entrop�a de la imagen: %f\n", H);
fprintf("Entrop�a pre-codificaci�n: %f\n", Hc);
fprintf("N�mero de coeficientes no nulos: %d\n", notZeroCoef);
disp('--------------------------------------------------');
disp('Terminado jcomdes');
disp('--------------------------------------------------');
end