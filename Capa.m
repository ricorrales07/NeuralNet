% Heredar de la clase handle hace que el objeto se maneje por referencia
% y no por copia.
classdef Capa < handle
    properties (Access = public)
        salidas %vector
        pesos %matriz de pesos entre la capa actual y la inferior
        errores %vector
        n %número de neuronas en la capa
    end
    
    methods
        function obj = Capa(tamano)
            obj.n = tamano;
            obj.salidas = zeros(tamano,1);
            obj.errores = zeros(tamano,1);
            obj.pesos = rand(tamano); %TODO: revisar si los pesos son completamente random o deben estar entre 0 y 1
        end
    end
end