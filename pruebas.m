[a] = loadpickle('C:\Users\Ricardo\Desktop\datasets_numerico\cifar-10-matlab.tar\cifar-10-matlab\cifar-10-batches-mat\test_batch.mat')


%y = objeto(1)
%hola(y)
%y
function hola(y)
    y.x = 0;
end

function [a] = loadpickle(filename)
    if ~exist(filename,'file')
        error('%s is not a file',filename);
    end
    outname = [tempname() '.mat'];
    pyscript = ['import cPickle as pickle;import sys;import scipy.io;file=open("' filename '","r");dat=pickle.load(file);file.close();scipy.io.savemat("' outname '",dat)'];
    system(['LD_LIBRARY_PATH=/opt/intel/composer_xe_2013/mkl/lib/intel64:/opt/intel/composer_xe_2013/lib/intel64;python -c ''' pyscript '''']);
    a = load(outname);
end