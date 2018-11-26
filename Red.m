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
        f = @(x) 1/(1 + exp(-x)); %función de salida
    end
    methods
        % Constructor. Define la cantidad de capas, neuronas por capa
        % y la velocidad de aprendizaje de la red.
        function obj = Red(numeroCapas, velocidadAprendizaje, ...
                neuronasEscondidas, neuronasEntrada, neuronasSalida)
            obj.numCapas = numeroCapas;
            obj.numNeuronasH = neuronasEscondidas;
            obj.numNeuronasE = neuronasEntrada;
            obj.numNeuronasS = neuronasSalida;
            obj.capas(numCapas) = obj.capas; %hack para reservar memoria
            
            % TODO: Excepción si da negativo (?)
            obj.numCapasH = numCapas - 2;
            
            obj.capas(1) = Capa(obj.numNeuronasE); %capa de entrada
            for ii=2:obj.numCapas-1
                obj.capas(ii) = Capa(obj.numNeuronasH); %capas escondidas
            end
            obj.capas(obj.numCapas) = Capa(obj.numNeuronasS); %capa de salida
            obj.eta = velocidadAprendizaje;
        end
        
        %% Métodos de propagación hacia adelante
        
        % OJO: Matlab necesita como parámetro siempre el objeto mismo
        % que tiene el método dentro.
        % ver https://www.mathworks.com/help/matlab/matlab_oop/specifying-methods-and-functions.html
        
        % Propaga la señal de una capa a la siguiente.
        function propagar_capa(red, inferior, superior)
            superior.salidas = red.f(superior.pesos * inferior.salidas);
        end
        
        % Arnoldo
        %function salidas = propagar_adelante(red, ...)
        %        
        %end
        
        %% Métodos de propagación hacia atrás
        
        % Calcula el error entre la salida de la red y el valor esperado
        % para una entrada particular 
        function error = calcular_error_salida(red, objetivo)
            salidas = red.capas(red.numCapas).salidas;
            red.capas(red.numCapas).errores = salidas .* (1 - salidas) ...
                .* (objetivo - salidas);
            error = 0.5 * sum((red.capas(red.numCapas).errores)^2);
        end
        
        % Arnoldo
        %function propagar_error_atras(red, ...)
        %        
        %end
        
        % Arnoldo
        %function ajustar_pesos(red, ...)
        %        
        %end
        
        function error = entrenarUnaEntrada(red, entrada, objetivo)
            red.propagar_adelante(entrada);
            error = red.calcular_error_salida(objetivo);
            for ii = red.numCapas:-1:3
                red.propagar_error_atras(red.capas(ii), red.capas(ii-1));
            end
            red.ajustar_pesos();
        end
    end
end