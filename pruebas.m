%XOR

clc
red = Red(3, 1e-3, 4, 2, 1);

datosDeEntrenamiento = rand(100,3);
datosDeEntrenamiento(:,1:2) = (datosDeEntrenamiento(:,1:2) > 0.5);
datosDeEntrenamiento(:,3) = xor(datosDeEntrenamiento(:,1),datosDeEntrenamiento(:,2));

error = Inf;
jj = 0;
while(error > 0.1 && red.eta ~= 0)
    errorAnterior = error;
    error = 0;
    for ii = 1:100
        entrada = datosDeEntrenamiento(ii,1:2)';
        objetivo = datosDeEntrenamiento(ii,3);
        error = max(error, red.entrenarUnaEntrada(entrada, objetivo));
    end
    jj = jj + 1;
    fprintf("Fin de la iteración %d, error: %.8f\n", jj, error);
    if error >= errorAnterior %si el error comienza a subir, bajamos el factor de aprendizaje
        red.eta = red.eta * 0.1;
        fprintf("Disminuyendo eta a %f\n", red.eta);
    end
end