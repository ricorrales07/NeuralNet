redTonta = Red(5,0.5,2,2,1)

entrenarRed()

function entrenarRed(red, datosDeEntrenamiento, errorAceptable, batches)
    I = eye(10);
    error = Inf;
    while error >= errorAceptable
        error = 0;
        for jj = 1:batches
            datos = load(strcat(datosDeEntrenamiento, 'data_batch_', ...
                num2str(jj), '.mat'));
            n = size(datos.data, 1);
            for ii=1:n
                entrada = datos.data(ii,:);
                objetivo = I(:,datos.labels(ii)+1);
                error = max(error, red.entrenarUnaEntrada(entrada, objetivo));
            end
        end
    end
end