% Heredar de la clase handle hace que el objeto se maneje por referencia
% y no por copia.
classdef Capa < handle
    properties (Access = public)
        salidas % vector columna nx1, con n cantidad de neuronas en la capa
        pesos % matriz de pesos entre la capa actual y la inferior nxm, 
              % con m cantidad de neuronas de la capa anterior
        errores % vector columna nx1, con n cantidad de neuronas de la capa 
                % actual
        n %número de neuronas en la capa
    end
    
    methods
        function obj = Capa(tamanoCapaActual, tamanoCapaAnterior)
            fprintf('Creando capa de tamaño %dx%d\n', ...
                tamanoCapaActual, tamanoCapaAnterior);
            obj.n = tamanoCapaActual;
            obj.salidas = zeros(obj.n,1);
            obj.errores = zeros(obj.n,1);
            obj.pesos = rand(obj.n, tamanoCapaAnterior); %TODO: revisar si los pesos son completamente random o deben estar entre 0 y 1
        end
    end
end