%DATASET: MNIST
% <>

clc
red = Red(4, 0.05, 100, 784, 10);

datos = 'C:\Users\Ricardo\Desktop\datasets_numerico\MNIST\';

imgsEntrenamiento = loadMNISTImages(strcat(datos, 'train-images.idx3-ubyte'))';
labelsEntrenamiento = loadMNISTLabels(strcat(datos, 'train-labels.idx1-ubyte'));

% 1% de error aceptable
[errorPorEntrada, errorPorIteracion] = entrenarRed(red, imgsEntrenamiento, labelsEntrenamiento, 0.01);

imgsPrueba = loadMNISTImages(strcat(datos, 't10k-images.idx3-ubyte'));
labelsPrueba = loadMNISTLabels(strcat(datos, 't10k-labels.idx1-ubyte'));

%%

evaluarErrorPrueba(red, imgsPrueba, labelsPrueba);

s = input('Inserte número (1-6000): ');
I = eye(10);
while s ~= -1
    x = red.propagar_adelante(imgsPrueba(:,s))
    errorRaw = 0.5 * sum((I(:,labelsPrueba(s)+1) - x).^2)
    errorPrediccion = red.calcular_error_salida(I(:,labelsPrueba(s)+1))
    [~,salida] = max(x);
    im = reshape(imgsPrueba(:,s), 28, 28);
    imshow(im);
    title(strcat("Esperado: ", num2str(labelsPrueba(s)), " Obtenido: ", num2str(salida-1)));
    s = input('Inserte número (1-6000): ');
end

function [errorPorEntrada, errorPorIteracion] = entrenarRed(red, imgs, labels, errorAceptable)
    I = eye(10);
    conError = 1; % porcentaje de imágenes erróneamente clasificadas
    k = 0;
    while conError >= errorAceptable
        conError = 0;
            
        n = size(imgs, 1);
        for ii=1:n
            entrada = imgs(ii,:)';
            objetivo = I(:,labels(ii)+1);
            error1entrada = red.entrenarUnaEntrada(entrada, objetivo);
            errorPorEntrada(k * n + ii) = error1entrada;
            conError = conError + (error1entrada > 0);
            if mod(ii, 1000) == 0
                fprintf('Entrenando: %d imágenes de %d\n', ...
                    ii, n);
            end
        end
        
        conError = conError / n;
        k = k + 1;
        fprintf('Iteración: %d, porcentaje de error: %.2f\n', ...
            k, conError * 100);
        errorPorIteracion(k) = conError;
    end
end

function imagenesConError = evaluarErrorPrueba(red, imgs, labels)
    I = eye(10);
    conError = 0; % porcentaje de imágenes erróneamente clasificadas
            
    n = size(imgs, 2);
    for ii=1:n
        entrada = imgs(:,ii)';
        objetivo = I(:,labels(ii)+1);
        red.propagar_adelante(entrada);
        error1entrada = red.calcular_error_salida(objetivo);
        if error1entrada > 0
            conError = conError + 1;
            imagenesConError(conError) = ii;
        end
        if mod(ii, 1000) == 0
            fprintf('Evaluando: %d imágenes de %d\n', ...
                ii, n);
        end
    end
    
    conError = conError / n;
    fprintf('Fin de pruebas. Porcentaje de error: %.2f\n', ...
        conError * 100);
end