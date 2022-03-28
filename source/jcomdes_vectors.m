function jcomdes_vectors(fname, caliQ, cstm)

% Función que genera un vector de ratios de compresión y otro de MSE para
% poder evaluar su evolución en una gráfica.
% Entradas:
%   fname: imagen que se quiere comprimir y descomprimir
%   caliQ: vector de factores de calidad (enteros positivos >= 1)
%         100: calidad estandar
%         >100: menor calidad
%         <100: mayor calidad
%   cstm: 0 o 1, indicando si se quiere codificación custom o no

% Para cada caliQ, genero un vector de RCs y otro de MSEs para una imagen
for i = 1:length(caliQ)
   if cstm == 0 
       [MSE, RC] = jcomdes(fname, caliQ(i));
   else
       [MSE, RC] = jcomdes_cstm(fname, caliQ(i));
   end
   vRC(i) = RC;
   vMSE(i) = MSE; 
end

fprintf("Errores cuadráticos medios\n--------------------------\n");
fprintf("%d ", vRC);
fprintf("\n\nRatios de compresión\n--------------------------\n");
fprintf("%d ", vMSE);
fprintf("\n");

% Se dibuja la gráfica con puntos como * y línea que alterna entre líneas y
% puntos. La 'x' son las razones de compresión y la 'y' el MSE
% Usar el código desde consola:
 %semilogy(rc_dflt_faro, mse_faro, '--r*', rc_cstm_faro, mse_faro, '--b*', rc_faro_c, mse_faro_c, '--g*')
 %ylabel ('MSE')
 %xlabel('RC (%)')
 %ylim([100, 500])
 %xlim([87 95])
 %legend('Matlab default', 'Matlab custom', 'Caesium', 'Location', 'northwest')
 %title({'MSE vs RC para faro.bmp', 'Factores de Calidad: 50, 75, 100, 150, 200, 300, 500'})
 %grid on

end