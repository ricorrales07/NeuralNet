classdef Red
    properties
        capas %vector de capas
        eta %velocidad de aprendizaje
    end
    methods
        function obj = Red(numCapas, neuronasPorCapa, velocidadAprendizaje)
            obj.capas(numCapas) = obj.capas; %hack para reservar memoria
            for i=1:numCapas
                obj.capas(i) = Capa(neuronasPorCapa);
            end
            obj.eta = velocidadAprendizaje;
        end
        
        function propagar_capa(inferior, superior)
            superior.salidas = superior.pesos * inferior.salidas;
        end
    end
end