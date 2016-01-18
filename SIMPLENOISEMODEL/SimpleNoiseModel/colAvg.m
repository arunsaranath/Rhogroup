function meanCol = colAvg(img,opt)
%%
%this function calculates the average spectra in each column/row of an image
%
%-------------------------------------------------------------------------------------------------------
%                                                INPUT PARAMETERS
%-------------------------------------------------------------------------------------------------------
%img                         :- The image for which avg ais being calculated
%opt                          :- select row(1) or column(2)
%-------------------------------------------------------------------------------------------------------
%                                                OUTPUT PARAMETERS
%-------------------------------------------------------------------------------------------------------
%meanCol                :- the mean spectra (each column is a differnt spectra)


% Author:- Arun M Saranathan
%Date   : - 07/11/2013

%%
    %number of bands in the image
    [rows,cols,bands] = size(img);
    
    if(opt == 1)
    
    %initialize a matrix to hold these values
    meanCol = zeros(bands,rows);
    
    %calculate column means in each band
    for i=1:bands
        temp = mean (squeeze(img(:,:,i))');
        
        meanCol(i,:) = temp;
    end
    
    else
        %initialize a matrix to hold these values
        meanCol = zeros(bands,cols);
    
        %calculate column means in each band
        for i=1:bands
            temp = mean (squeeze(img(:,:,i)));
        
            meanCol(i,:) = temp;
     end
    
    end
    
    

end