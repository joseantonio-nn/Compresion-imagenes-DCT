function [RC, H, Hc, notZeroCoef, fichero_comp] = jcom_dflt(fname, caliQ)

% jcom_dflt: Compresion de imagenes basada en transformadas

% Entradas:
%  fname: Un string con nombre de archivo, incluido sufijo
%         Admite BMP y JPEG, indexado y truecolor
%  caliQ: Factor de calidad (entero positivo >= 1)
%         100: calidad estandar
%         >100: menor calidad
%         <100: mayor calidad
% Salidas:
%  RC:    Relacion de compresión
%  H:     Entropía
%  notZeroCoef: Número de coeficientes no nulos
%  fichero_comp: String con el nombre del fichero comprimido

disptext=1; % Flag de verbosidad
if disptext
    disp('--------------------------------------------------');
    disp('Funcion jcom_dflt:');
end

% Lee archivo de imagen
% Convierte a espacio de color YCbCr
% Amplia dimensiones a multiplos de 8
%  X: Matriz original de la imagen en espacio RGB
%  Xamp: Matriz ampliada de la imagen en espacio YCbCr
[X, Xamp, ~, ~, ~, ~, ~, TO]=imlee(fname);

% Calcula DCT bidimensional en bloques de 8 x 8 pixeles
Xtrans = imdct(Xamp);

% Cuantizacion de coeficientes
Xlab = quantmat(Xtrans, caliQ);

% Genera un scan por cada componente de color
%  Cada scan es una matriz mamp x namp
%  Cada bloque se reordena en zigzag
XScan=scan(Xlab);

% Codifica los tres scans, usando Huffman por defecto
[CodedY,CodedCb,CodedCr]=EncodeScans_dflt(XScan);

[sbytesY, ultlY]=bits2bytes(CodedY);
[sbytesCb, ultlCb]=bits2bytes(CodedCb);
[sbytesCr, ultlCr]=bits2bytes(CodedCr);

% Se crea el fichero con la información comprimida
[~, name, ~] = fileparts(fname);
fichero_comp = strcat(name, '.hud');

a = size(X);
b = size(Xamp);

% Se escriben los datos en el archivo comprimido
fid = fopen(fichero_comp, 'w');
fwrite(fid, a(1), 'uint32');
fwrite(fid, a(2), 'uint32');
fwrite(fid, b(1), 'uint32');  
fwrite(fid, b(2), 'uint32');
fwrite(fid, caliQ, 'uint32'); 
fwrite(fid, length(sbytesY), 'uint32');   
fwrite(fid, length(sbytesCb), 'uint32');
fwrite(fid, length(sbytesCr), 'uint32');     
fwrite(fid, ultlY, 'uint8');              
fwrite(fid, ultlCb, 'uint8');
fwrite(fid, ultlCr, 'uint8');
fwrite(fid, sbytesY', 'uint8');   
fwrite(fid, sbytesCb', 'uint8');
fwrite(fid, sbytesCr', 'uint8'); 

% Se guarda el tamano del fichero para calcular RC
fseek(fid, 0, 'eof');
tam_fichero_comp = ftell(fid);
fclose(fid);

% Tasa/ratio de compresión
RC = (TO - tam_fichero_comp)/TO * 100;
% Entropía de la imagen
H = EntroImg(X);
% Entropía pre-codificación
Hc = EntroImg(Xlab);
% Número de coeficientes no nulos
notZeroCoef = nnz(Xlab);

end