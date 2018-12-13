clc

datos = "C:\Users\Ricardo\Desktop\datasets_numerico\MNIST\";

imgsEntrenamiento = loadMNISTImages(strcat(datos, 'train-images.idx3-ubyte'))';
labelsEntrenamiento = loadMNISTLabels(strcat(datos, 'train-labels.idx1-ubyte'));

imgsPrueba = loadMNISTImages(strcat(datos, 't10k-images.idx3-ubyte'));
labelsPrueba = loadMNISTLabels(strcat(datos, 't10k-labels.idx1-ubyte'));

errorEntrenamiento = zeros(10,1);
for ii = 1:10
    red = Red(3, 0.05, 100, 784, 10);
    [~,errorPorIteracion] = entrenarRed(red, imgsEntrenamiento, ...
        labelsEntrenamiento, 0.01 * ii);
    errorEntrenamiento(ii) = errorPorIteracion(end);
    errorPrueba(ii) = evaluarErrorPrueba(red, imgsPrueba, labelsPrueba);
end

plot(errorEntrenamiento, errorPrueba)

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

function error = evaluarErrorPrueba(red, imgs, labels)
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
        end
        if mod(ii, 1000) == 0
            fprintf('Evaluando: %d imágenes de %d\n', ...
                ii, n);
        end
    end
    
    conError = conError / n;
    fprintf('Fin de pruebas. Porcentaje de error: %.2f\n', ...
        conError * 100);
    
    error = conError;
end