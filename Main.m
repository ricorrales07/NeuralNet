% <>

% La idea es que datosDeEntrenamiento sea solo el nombre de la carpeta
% o algo as�, de donde se puedan ir sacando los datos uno por uno.
% No se pasan todos de un solo porque se quedar�a sin memoria.
function entrenarRed(red, datosDeEntrenamiento, errorAceptable)
    n = %n�mero de vectores de entrenamiento
    error = Inf;
    while error >= errorAceptable
        error = 0;
        for ii=1:n
            [entrada, objetivo] = %obtener el dato de entrenamiento
            error = max(error, red.entrenarUnaEntrada(entrada, objetivo);
        end
    end
end