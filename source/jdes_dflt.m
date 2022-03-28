function MSE = jdes_dflt(fname) 

% jdes_dflt: Descompresion de imagenes

% Entradas:
%  fname: Un string con nombre de archivo, sufijo incluido
%         Admite .hud 
% Salidas:
%  MSE:    Error cuadrático medio

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
fclose(fid);

CodedY = bytes2bits(sbytesY, ultlY);
CodedCb = bytes2bits(sbytesCb, ultlCb);
CodedCr = bytes2bits(sbytesCr, ultlCr);

% Decodifica los tres Scans a partir de strings binarios
XScanrec=DecodeScans_dflt(CodedY,CodedCb,CodedCr,[mamp namp]);

% Recupera matrices de etiquetas en orden natural
%  a partir de orden zigzag
Xlabrec=invscan(XScanrec);

% Descuantizacion de etiquetas
Xtransrec=desquantmat(Xlabrec, caliQ);

% Calcula iDCT bidimensional en bloques de 8 x 8 pixeles
% Como resultado, reconstruye una imagen YCbCr con tamaño ampliado
Xamprec = imidct(Xtransrec,m, n);

% Convierte a espacio de color RGB
% Para ycbcr2rgb: % Intervalo [0,255]->[0,1]->[0,255]
Xrecrd=round(ycbcr2rgb(Xamprec/255)*255);
Xrec=uint8(Xrecrd);

% Repone el tamaño original
Xrec=Xrec(1:m,1:n, 1:3);

% Creo el fichero
[~, name, ~] = fileparts(fname);
ficherorec = strcat(name, '_des_def.bmp');

% Guarda archivo descomprimido
imwrite(Xrec,ficherorec,'bmp');

% Error cuadrático medio
[X, ~, ~, m, n, ~, ~, ~] = imlee(strcat(name, '.bmp'));
MSE = (sum(sum(sum((double(Xrec) - double(X)).^2))))/(m * n * 3);

% Test visual
disptext=1; % Flag de verbosidad
if disptext
    [m,n,~] = size(X);
    figure('Units','pixels','Position',[100 100 n m]);
    set(gca,'Position',[0 0 1 1],'Visible','off');
    image(X); 
    set(gcf,'Name','Imagen original X');
    figure('Units','pixels','Position',[100 100 n m]);
    set(gca,'Position',[0 0 1 1]);
    image(Xrec);
    set(gcf,'Name','Imagen reconstruida Xrec');
    figure('Units','pixels','Position',[100 100 n m]);
    set(gca,'Position',[0 0 1 1]);
    image(abs(X - Xrec)*4);
    set(gcf,'Name','Diferencia de imágenes');
end

end
