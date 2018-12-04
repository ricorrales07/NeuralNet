%DATASET: MNIST
% <>

clc
red = Red(4, 0.05, 100, 784, 10);

datos = 'C:\Users\Ricardo\Desktop\datasets_numerico\MNIST\';

imgsEntrenamiento = loadMNISTImages(strcat(datos, 'train-images.idx3-ubyte'))';
labelsEntrenamiento = loadMNISTLabels(strcat(datos, 'train-labels.idx1-ubyte'));

% 30% de error aceptable
entrenarRed(red, imgsEntrenamiento, labelsEntrenamiento, 0.3);

imgsPrueba = loadMNISTImages(strcat(datos, 't10k-images.idx3-ubyte'));
labelsPrueba = loadMNISTLabels(strcat(datos, 't10k-labels.idx1-ubyte'));

s = input('Inserte n�mero (1-6000): ');
I = eye(10);
while num2str(s) ~= 'q'
    x = red.propagar_adelante(imgsPrueba(:,s));
    errorRaw = 0.5 * sum((I(:,labelsPrueba(s)+1) - x).^2)
    errorPrediccion = red.calcular_error_salida(I(:,labelsPrueba(s)+1))
    [~,salida] = max(x);
    im = reshape(imgsPrueba(:,s), 28, 28);
    imshow(im);
    title(strcat("Esperado: ", num2str(labelsPrueba(s)), " Obtenido: ", num2str(salida-1)));
    s = input('Inserte n�mero: ');
end

function entrenarRed(red, imgs, labels, errorAceptable)
    I = eye(10);
    conError = 1; % porcentaje de im�genes err�neamente clasificadas
    k = 0;
    while conError >= errorAceptable
        conError = 0;
            
        n = size(imgs, 1);
        for ii=1:n
            entrada = imgs(ii,:)';
            objetivo = I(:,labels(ii)+1);
            error1entrada = red.entrenarUnaEntrada(entrada, objetivo);
            conError = conError + (error1entrada > 0);
            if mod(ii, 1000) == 0
                fprintf('Entrenando: %d im�genes de %d\n', ...
                    ii, n);
            end
        end
        
        conError = conError / n;
        k = k + 1;
        fprintf('Iteraci�n: %d, porcentaje de error: %.2f\n', ...
            k, conError * 100);
    end
end
