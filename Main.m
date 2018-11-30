% <>

red = Red(3, 0.1, 1000, 3072, 10);

datos = 'C:\Users\Ricardo\Desktop\datasets_numerico\cifar-10-matlab.tar\cifar-10-matlab\cifar-10-batches-mat\';

entrenarRed(red, datos, 0.01, 1);

datosDePrueba = load(strcat(datosDeEntrenamiento, 'test_batch.mat'));

categorias = ['avión';
    'carro';
    'pájaro';
    'gato';
    'venado';
    'perro';
    'rana';
    'caballo';
    'barco';
    'camión'];

s = '';
while s ~= 'q'
    s = input('Inserte número:');
    [~,salida] = max(red.propagar_adelante(datosDePrueba.data(s,:)));
    im = reshape(datosDePrueba.data(s,:), 32,32,3);
    imshow(im);
    title(categorias(salida));
end

% La idea es que datosDeEntrenamiento sea solo el nombre de la carpeta
% o algo así, de donde se puedan ir sacando los datos uno por uno.
% No se pasan todos de un solo porque se quedaría sin memoria.
function entrenarRed(red, datosDeEntrenamiento, errorAceptable, batches)
    I = eye(10);
    error = Inf;
    while error >= errorAceptable
        error = 0;
        for jj=1:batches
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