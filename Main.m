% <>

red = Red(4, 0.1, 1000, 3072, 10);

datos = 'C:\Users\Ricardo\Desktop\datasets_numerico\cifar-10-matlab.tar\cifar-10-matlab\cifar-10-batches-mat\';

entrenarRed(red, datos, 0.01, 1);

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
    x = red.propagar_adelante((double(datosDePrueba.data(s,:))' - 128) ./ 128)
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
        for jj=1:batches
            datos = load(strcat(datosDeEntrenamiento, 'data_batch_', ...
                num2str(jj), '.mat'));
            datos.data = double(datos.data);
            datos.labels = double(datos.labels);
            n = size(datos.data, 1);
            for ii=1:n
                % Se aplica esta transformación a los datos de entrada para
                % obtener cosas entre -1 y 1.
                entrada = (datos.data(ii,:)' - 128) ./ 128;
                objetivo = I(:,datos.labels(ii)+1);
                error = max(error, red.entrenarUnaEntrada(entrada, objetivo));
                if mod(ii, 100) == 0
                    fprintf('Entrenando: %d imágenes de 10000\n', ii);
                end
            end
        end
        k = k + 1;
        fprintf('Iteración: %d, error: %f\n', k, error);
    end
end