% Heredar de la clase handle hace que el objeto se maneje por referencia
% y no por copia.
classdef Capa < handle
    properties (Access = public)
        salidas % vector columna nx1, con n cantidad de neuronas en la capa
        pesos % matriz de pesos entre la capa actual y la inferior mxn, con 
              % con n cantidad de neuronas de la capa anterior
        errores % vector columna nx1, con n cantidad de neuronas de la capa 
                % anterior
        n %número de neuronas en la capa
    end
    
    methods
        function obj = Capa(tamano)
            obj.n = tamano;
            obj.salidas = zeros(tamano,1);
            obj.errores = zeros(tamano,1);
            %FUCK, ESTO ESTÁ MAL
            %Asumí que todas las capas eran del mismo tamaño...
            obj.pesos = rand(tamano); %TODO: revisar si los pesos son completamente random o deben estar entre 0 y 1
        end
    end
end