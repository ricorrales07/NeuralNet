%XOR

clc
red = Red(3, 0.5, 4, 2, 1);

datosDeEntrenamiento = rand(100,3);
datosDeEntrenamiento(:,1:2) = (datosDeEntrenamiento(:,1:2) > 0.5);
datosDeEntrenamiento(:,3) = xor(datosDeEntrenamiento(:,1),datosDeEntrenamiento(:,2));

%conError = 100;
%jj = 0;
%while(conError > 0)
%    errorAnterior = conError;
%    conError = 0;
%    for ii = 1:100
%        entrada = datosDeEntrenamiento(ii,1:2)';
%        objetivo = datosDeEntrenamiento(ii,3);
%        conError = conError + (red.entrenarUnaEntrada(entrada, objetivo) > 0);
%    end
%    jj = jj + 1;
%    fprintf("Fin de la iteración %d, error: %d\n", jj, conError);
%end

error = Inf;
jj = 0;
while(error > 1e-3)
    errorAnterior = error;
    error = 0;
    for ii = 1:100
        entrada = datosDeEntrenamiento(ii,1:2)';
        objetivo = datosDeEntrenamiento(ii,3);
        error = max(error, red.entrenarUnaEntrada(entrada, objetivo));
    end
    jj = jj + 1;
    fprintf("Fin de la iteración %d, error: %d\n", jj, error);
end