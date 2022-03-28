function [RC, H, notZeroCoef, fichero_comp] = jcom_cstm(fname, caliQ)

% Comprime una imagen usando tablas de codificación Huffman custom

% Entradas:
%   fname: Un string con nombre de archivo, incluido sufijo
%          Admite BMP y JPEG, indexado y truecolor
%   caliQ: factor de calidad 
%
% Salidas:
%  RC:    Relacion de compresión
%  H:     Entropía
%  notZeroCoef: Número de coeficientes no nulos
%  fichero_comp: String con el nombre del fichero comprimido

disptext=1; % Flag de verbosidad
if disptext
    disp('--------------------------------------------------');
    disp('Funcion jcom_cstm:');
end

% Lee archivo de imagen
% Convierte a espacio de color YCbCr
% Amplia dimensiones a multiplos de 8
%  X: Matriz original de la imagen en espacio RGB
%  Xamp: Matriz ampliada de la imagen en espacio YCbCr
[X, Xamp, ~, ~, ~, ~, ~, TO] = imlee(fname);

% Calcula DCT bidimensional en bloques de 8 x 8 pixeles
Xtrans = imdct(Xamp);

% Cuantizacion de coeficientes
Xlab=quantmat(Xtrans, caliQ);

% Genera un scan por cada componente de color
%  Cada scan es una matriz mamp x namp
%  Cada bloque se reordena en zigzag
XScan=scan(Xlab);

% Se codifican los tres scans, usando Huffman custom
[CodedY,CodedCb,CodedCr,bits_Y_DC, bits_Y_AC, bits_C_DC, bits_C_AC,huffval_Y_DC, huffval_Y_AC, huffval_C_DC, huffval_C_AC]=EncodeScans_cstm(XScan);

[sbytesY, ultlY]=bits2bytes(CodedY);
[sbytesCb, ultlCb]=bits2bytes(CodedCb);
[sbytesCr, ultlCr]=bits2bytes(CodedCr);

% Se crea el fichero para pasar toda la información necesaria para
% recuperar la imagen
[~, name, ~] = fileparts(fname);
fichero_comp = strcat(name, '.huc');

a = size(X);
b = size(Xamp);
ulenbits_y_dc = uint8(length(bits_Y_DC));       
ubits_y_dc = uint8(bits_Y_DC);    
ulenbits_y_ac = uint8(length(bits_Y_AC));       
ubits_y_ac = uint8(bits_Y_AC);
ulenbits_c_dc = uint8(length(bits_C_DC));       
ubits_c_dc = uint8(bits_C_DC); 
ulenbits_c_ac = uint8(length(bits_C_AC));       
ubits_c_ac = uint8(bits_C_AC); 
ulenhuffval_y_dc = uint8(length(huffval_Y_DC));       
uhuffval_y_dc = uint8(huffval_Y_DC);  
ulenhuffval_y_ac = uint8(length(huffval_Y_AC));       
uhuffval_y_ac = uint8(huffval_Y_AC);
ulenhuffval_c_dc = uint8(length(huffval_C_DC));       
uhuffval_c_dc = uint8(huffval_C_DC); 
ulenhuffval_c_ac = uint8(length(huffval_C_AC));       
uhuffval_c_ac = uint8(huffval_C_AC);
         
% Se escribe la información necesaria en el fichero
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
fwrite(fid, ulenbits_y_dc, 'uint8');
fwrite(fid, ubits_y_dc, 'uint8');
fwrite(fid, ulenbits_y_ac, 'uint8');
fwrite(fid, ubits_y_ac, 'uint8');
fwrite(fid, ulenbits_c_dc, 'uint8');
fwrite(fid, ubits_c_dc, 'uint8');
fwrite(fid, ulenbits_c_ac, 'uint8');
fwrite(fid, ubits_c_ac, 'uint8');

fwrite(fid, ulenhuffval_y_dc, 'uint8');
fwrite(fid, uhuffval_y_dc, 'uint8');
fwrite(fid, ulenhuffval_y_ac, 'uint8');
fwrite(fid, uhuffval_y_ac, 'uint8');
fwrite(fid, ulenhuffval_c_dc, 'uint8');
fwrite(fid, uhuffval_c_dc, 'uint8');
fwrite(fid, ulenhuffval_c_ac, 'uint8');
fwrite(fid, uhuffval_c_ac, 'uint8');

% Se guarda el tamano del fichero comprimido para calcular el RC
fseek(fid, 0, 'eof');
tam_fichero_comp = ftell(fid);
fclose(fid);

% TASA (rate) de compresión
RC = (TO - tam_fichero_comp)/TO * 100;
% Entropía de la imagen
H = EntroImg(X);
% Número de coeficientes no nulos
notZeroCoef = nnz(Xlab);

end