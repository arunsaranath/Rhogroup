function stdDevVec = stdDevImg(img,opt)
%%
%this function calculates the std dev in band for each column/row of an image
%
%-------------------------------------------------------------------------------------------------------
%                                                INPUT PARAMETERS
%-------------------------------------------------------------------------------------------------------
%img                         :- The image for which avg ais being calculated
%opt                          :- select row(1) or column(2)
%-------------------------------------------------------------------------------------------------------
%                                                OUTPUT PARAMETERS
%-------------------------------------------------------------------------------------------------------
%stdDevVec                :- the std dev for all bands (each column is a differnt spectra)


% Author:- Arun M Saranathan
%Date   : - 08/21/2013
%%
    %number of bands in the image
    [rows,cols,bands] = size(img);
    
    if(opt == 1)
    
    %initialize a matrix to hold these values
    stdDevVec = zeros(bands,rows);
    
    %calculate row means in each band
    for i=1:bands
        temp1 = std (squeeze(img(:,:,i))');
        
        stdDevVec(i,:) = temp1;
    end
    
    else
        %initialize a matrix to hold these values
        stdDevVec = zeros(bands,cols);
    
        %calculate column means in each band
        for i=1:bands
            temp = std (squeeze(img(:,:,i)));
        
           stdDevVec(i,:) = temp;
     end
    
    end
    
    

end