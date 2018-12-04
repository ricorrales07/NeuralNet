% <>

clc
red = Red(4, 0.05, 1000, 3072, 10);

datos = 'C:\Users\Ricardo\Desktop\datasets_numerico\cifar-10-matlab.tar\cifar-10-matlab\cifar-10-batches-mat\';

entrenarRed2(red, datos, 0.1, 1);

datosDePrueba = load(strcat(datos, 'test_batch.mat'));

categorias = ["avión";
    "carro";
    "pájaro";
    "gato";
    "venado";
    "perro";
    "rana";
    "caballo";
    "barco";
    "camión"];

s = input('Inserte número: ');
I = eye(10);
while num2str(s) ~= 'q'
    x = red.propagar_adelante(((double(datosDePrueba.data(s,:)) - mu) ./ sigma)');
    error = 0.5 * sum((double(I(:,datosDePrueba.labels(s)+1)) - x).^2)
    error2 = red.calcular_error_salida(double(I(:,datosDePrueba.labels(s)+1)))
    [~,salida] = max(x);
    im = reshape(datosDePrueba.data(s,:), 32,32,3);
    imshow(im);
    title(strcat("Esperado: ", categorias(datosDePrueba.labels(s)+1), "; Obtenido: ", categorias(salida)));
    s = input('Inserte número: ');
end

% La idea es que datosDeEntrenamiento sea solo el nombre de la carpeta
% o algo así, de donde se puedan ir sacando los datos uno por uno.
% No se pasan todos de un solo porque se quedaría sin memoria.
function entrenarRed(red, datosDeEntrenamiento, errorAceptable, batches)
    I = eye(10);
    error = Inf;
    k = 0;
    while error >= errorAceptable
        error = 0;
        errorMin = Inf;
        for jj=1:batches
            datos = load(strcat(datosDeEntrenamiento, 'data_batch_', ...
                num2str(jj), '.mat'));
            datos.data = double(datos.data);
            datos.labels = double(datos.labels);
            n = size(datos.data, 1) / 100;
            for ii=1:n
                % Se aplica esta transformación a los datos de entrada para
                % obtener cosas entre -1 y 1.
                entrada = (datos.data(ii,:)' - 128) ./ 128;
                objetivo = I(:,datos.labels(ii)+1);
                error1entrada = red.entrenarUnaEntrada(entrada, objetivo);
                errorMin = min(errorMin, error1entrada);
                error = max(error, error1entrada);
                if mod(ii, 100) == 0
                    fprintf('Entrenando: %d imágenes de 10000, error de esta entrada: %f, error mínimo: %f\n', ii, error1entrada, errorMin);
                end
            end
        end
        k = k + 1;
        fprintf('Iteración: %d, error: %f\n', k, error);
    end
end

function entrenarRed2(red, datosDeEntrenamiento, errorAceptable, batches)
    I = eye(10);
    conError = 1; % porcentaje de imágenes erróneamente clasificadas
    k = 0;
    while conError >= errorAceptable
        conError = 0;
        for jj=1:batches
            datos = load(strcat(datosDeEntrenamiento, 'data_batch_', ...
                num2str(jj), '.mat'));
            datos.data = double(datos.data);
            datos.labels = double(datos.labels);
            
            mu = mean(datos.data(1:100,:));
            sigma = var(datos.data(1:100,:));
            
            n = size(datos.data, 1) / 100;
            for ii=1:n
                % Se aplica esta transformación a los datos de entrada para
                % obtener cosas entre -1 y 1.
                %entrada = (datos.data(ii,:)' - 128) ./ 128;
                entrada = ((datos.data(ii,:) - mu) ./ sigma)';
                objetivo = I(:,datos.labels(ii)+1);
                error1entrada = red.entrenarUnaEntrada(entrada, objetivo);
                conError = conError + (error1entrada > 0);
                if mod(ii, 100) == 0
                    fprintf('Entrenando: %d imágenes de 10000\n', ii);
                end
            end
        end
        conError = conError / (n * batches); %asumo que todos los batches tienen el mismo tamaño
        k = k + 1;
        fprintf('Iteración: %d, error: %f\n', k, conError * 100);
    end
end