function MSE = jdes_cstm(fname)

% Descomprime una imagen usando las tablas de codificación Huffman custom
% almacenadas en ella

% Entradas:
%   fname: string con el nombre de la imagen a comprimir (incluido formato)
%   Admite .huc
% Salidas:
%   MSE: error cuadrático medio de la imagen recuperada con respecto a la
%   original

% Lectura de los datos comprimidos
fid = fopen(fname, 'r');
m = double(fread(fid, 1, 'uint32'));  
n = double(fread(fid, 1, 'uint32'));  
mamp = double(fread(fid, 1, 'uint32'));   
namp = double(fread(fid, 1, 'uint32'));
caliQ = double(fread(fid, 1, 'uint32')); 
lenSbytesY = double(fread(fid, 1, 'uint32'));   
lenSbytesCb = double(fread(fid, 1, 'uint32'));
lenSbytesCr = double(fread(fid, 1, 'uint32'));     
ultlY = double(fread(fid, 1, 'uint8'));              
ultlCb = double(fread(fid, 1, 'uint8'));
ultlCr = double(fread(fid, 1, 'uint8'));

sbytesY = double(fread(fid, lenSbytesY, 'uint8'));   
sbytesCb = double(fread(fid, lenSbytesCb, 'uint8'));
sbytesCr = double(fread(fid, lenSbytesCr, 'uint8')); 
ulenbits_y_dc = double(fread(fid, 1, 'uint8'));
ubits_y_dc = double(fread(fid, ulenbits_y_dc, 'uint8'));
ulenbits_y_ac = double(fread(fid, 1, 'uint8'));
ubits_y_ac = double(fread(fid, ulenbits_y_ac, 'uint8'));
ulenbits_c_dc = double(fread(fid, 1, 'uint8'));
ubits_c_dc = double(fread(fid, ulenbits_c_dc, 'uint8'));
ulenbits_c_ac = double(fread(fid, 1, 'uint8'));
ubits_c_ac = double(fread(fid, ulenbits_c_ac, 'uint8'));

ulenhuffval_y_dc = double(fread(fid, 1, 'uint8'));
uhuffval_y_dc = double(fread(fid, ulenhuffval_y_dc, 'uint8'));
ulenhuffval_y_ac = double(fread(fid, 1, 'uint8'));
uhuffval_y_ac = double(fread(fid, ulenhuffval_y_ac, 'uint8'));
ulenhuffval_c_dc = double(fread(fid, 1, 'uint8'));
uhuffval_c_dc = double(fread(fid, ulenhuffval_c_dc, 'uint8'));
ulenhuffval_c_ac = double(fread(fid, 1, 'uint8'));
uhuffval_c_ac = double(fread(fid, ulenhuffval_c_ac, 'uint8'));
fclose(fid);

CodedY = bytes2bits(sbytesY, ultlY);
CodedCb = bytes2bits(sbytesCb, ultlCb);
CodedCr = bytes2bits(sbytesCr, ultlCr);

% Se decodifican los tres Scans a partir de strings binarios
XScanrec = DecodeScans_cstm(CodedY, CodedCb, CodedCr, [mamp namp], ubits_y_dc, ubits_y_ac, ubits_c_dc, ubits_c_ac, uhuffval_y_dc, uhuffval_y_ac, uhuffval_c_dc, uhuffval_c_ac);

% Recupera matrices de etiquetas en orden natural
%  a partir de orden zigzag
Xlabrec = invscan(XScanrec);

% Descuantizacion de etiquetas
Xtransrec = desquantmat(Xlabrec, caliQ);

% Calcula iDCT bidimensional en bloques de 8 x 8 pixeles
% Como resultado, reconstruye una imagen YCbCr con tamaño ampliado
Xamprec = imidct(Xtransrec, m, n);

% Convierte a espacio de color RGB
% Para ycbcr2rgb: % Intervalo [0,255]->[0,1]->[0,255]
Xrecrd = round(ycbcr2rgb(Xamprec/255)*255);
Xrec = uint8(Xrecrd);

% Repone el tamaño original
Xrec = Xrec(1:m, 1:n, 1:3);

% Se crea la imagen descomprimida
[~, name, ~] = fileparts(fname);
img_rec = strcat(name, '_des_cstm.bmp');
imwrite(Xrec, img_rec, 'bmp');

% Se calcula el error cuadrático medio
[X, ~, ~, m, n, ~, ~, TO] = imlee(strcat(name, '.bmp'));
MSE = (sum(sum(sum((double(Xrec) - double(X)).^2))))/(m * n * 3);

% Test visual
disptext=1; % Flag de verbosidad
if disptext
    [m,n,~] = size(X);
    figure('Units','pixels','Position',[100 100 n m]);
    set(gca,'Position',[0 0 1 1]);
    image(X); 
    set(gcf,'Name','Imagen original X');
    figure('Units','pixels','Position',[100 100 n m]);
    set(gca,'Position',[0 0 1 1]);
    image(Xrec);
    set(gcf,'Name','Imagen reconstruida Xrec');
end

end