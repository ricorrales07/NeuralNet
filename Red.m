% Heredar de la clase handle hace que el objeto se maneje por referencia
% y no por copia.
classdef Red < handle
    properties
        numCapas %número total de capas
        numCapasH %número de capas escondidas
        numNeuronasH %neuronas en cada capa escondida
        numNeuronasE %neuronas en la capa de entrada
        numNeuronasS %neuronas en la capa de salida
        capas %vector de capas
        eta %velocidad de aprendizaje
        f = @(x) 1 ./ (1 + exp(-(x-128) ./ 128)); %función de salida
        % Apliqué una transformación para lidiar mejor con datos de
        % imágenes (números entre 0 y 255).
    end
    methods
        % Constructor. Define la cantidad de capas, neuronas por capa
        % y la velocidad de aprendizaje de la red.
        function obj = Red(numeroCapas, velocidadAprendizaje, ...
                numNeuronasEscondidas, numNeuronasEntrada, numNeuronasSalida)
            obj.numCapas = numeroCapas;
            obj.numNeuronasH = numNeuronasEscondidas;
            obj.numNeuronasE = numNeuronasEntrada;
            obj.numNeuronasS = numNeuronasSalida;
            obj.capas = Capa.empty(obj.numCapas, 0); %crea un arreglo vacío de nx1 capas
            
            % TODO: Excepción si da negativo (?)
            obj.numCapasH = obj.numCapas - 2;
            
            obj.capas(1) = Capa(obj.numNeuronasE, 0); %capa de entrada
            for ii = 2:(obj.numCapas-1)
                obj.capas(ii) = Capa(obj.numNeuronasH, obj.capas(ii-1).n); %capas escondidas
            end
            obj.capas(obj.numCapas) = Capa(obj.numNeuronasS, ...
                obj.capas(obj.numCapas-1).n); %capa de salida
            obj.eta = velocidadAprendizaje;
        end
        
        %% Métodos de propagación hacia adelante
        
        % OJO: Matlab necesita como parámetro siempre el objeto mismo
        % que tiene el método dentro.
        % ver https://www.mathworks.com/help/matlab/matlab_oop/specifying-methods-and-functions.html
        
        % Propaga la señal de una capa a la siguiente.
        function propagar_capa(red, inferior, superior)
            %size(superior.pesos)
            %size(inferior.salidas)
            superior.salidas = red.f(superior.pesos * inferior.salidas);
        end
        
        % Propaga la señal hacia delante en toda la red
        function salidas = propagar_adelante(red, entradas)
            red.capas(1).salidas = entradas;
            for ii = 1:(red.numCapas-1)
                %fprintf('Propagando señal hacia adelante de capa %d a capa %d\n', ...
                %    ii, ii+1);
                %red.capas(ii+1) = red.propagar_capa(red.capas(ii), ...
                %                                red.capas(ii+1));
                red.propagar_capa(red.capas(ii), red.capas(ii+1));
            end
            salidas = red.capas(red.numCapas).salidas;
        end
        
        %% Métodos de propagación hacia atrás
        
        % Calcula el error entre la salida de la red y el valor esperado
        % para una entrada particular 
        function error = calcular_error_salida(red, objetivo)
            salidas = red.capas(red.numCapas).salidas;
            red.capas(red.numCapas).errores = salidas .* (1 - salidas) ...
                .* (objetivo - salidas);
            error = 0.5 * sum((red.capas(red.numCapas).errores).^2);         
        end
        
        % Propaga el error hacia atrás entre dos capas
        function propagar_error_atras(red, inferior, superior)
            inferior.errores = (superior.pesos' * superior.errores) .* ...
                inferior.salidas .* (1 - inferior.salidas);
        end
        
        
        function ajustar_pesos(red)
            for ii = red.numCapas:-1:2 % Excepción de solo una capa en la 
                                       % red
                red.capas(ii).pesos = red.capas(ii).pesos + ...
                    ( red.eta * red.capas(ii).errores * red.capas(ii-1).salidas' ); 
                % Puse el eta primero por eficiencia.
            end
        end
        
        function error = entrenarUnaEntrada(red, entrada, objetivo)
            red.propagar_adelante(entrada);
            error = red.calcular_error_salida(objetivo);
            for ii = red.numCapas:-1:2
                %fprintf('Propagando error hacia atrás de capa %d a capa %d\n', ...
                %    ii, ii-1);
                red.propagar_error_atras(red.capas(ii-1), red.capas(ii));
            end
            red.ajustar_pesos();
        end
    end
end