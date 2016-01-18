S = shaperead('spectra_other_2015.shp');S
for i=1:length(S)
   name = S(i,1).SiteName;
   if(~isempty(name))
      disp(name) 
   end
end