% Heredar de la clase handle hace que el objeto se maneje por referencia
% y no por copia.
classdef Red < handle
    properties
        numCapas %n�mero de capas
        numNeuronas %neuronas por capa
        capas %vector de capas
        eta %velocidad de aprendizaje
        f = @(x) 1/(1 + exp(-x)); %funci�n de salida
    end
    methods
        % Constructor. Define la cantidad de capas, neuronas por capa
        % y la velocidad de aprendizaje de la red.
        function obj = Red(numeroCapas, neuronasPorCapa, velocidadAprendizaje)
            obj.numCapas = numeroCapas;
            obj.numNeuronas = neuronasPorCapa;
            obj.capas(numCapas) = obj.capas; %hack para reservar memoria
            
            % TODO: Revisar bien los tama�os de la capa de entrada y la
            % capa de salida.
            for ii=1:numCapas
                obj.capas(ii) = Capa(numNeuronas);
            end
            obj.eta = velocidadAprendizaje;
        end
        
        %% M�todos de propagaci�n hacia adelante
        
        % OJO: Matlab necesita como par�metro siempre el objeto mismo
        % que tiene el m�todo dentro.
        % ver https://www.mathworks.com/help/matlab/matlab_oop/specifying-methods-and-functions.html
        
        % Propaga la se�al de una capa a la siguiente.
        function propagar_capa(red, inferior, superior)
            superior.salidas = red.f(superior.pesos * inferior.salidas);
        end
        
        %% M�todos de propagaci�n hacia atr�s
        
        % Calcula el error entre la salida de la red y el valor esperado
        % para una entrada particular 
        function calcular_error_salida(red, objetivo)
            salidas = red.capas(red.numCapas).salidas;
            red.capas(red.numCapas).errores = salidas .* (1 - salidas) ...
                .* (objetivo - salidas);
        end
    end
end