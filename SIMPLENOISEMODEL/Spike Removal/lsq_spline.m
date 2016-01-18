function lsq_spline(x,y)
%LSQ_SPLINE  Reconstruct figure in SPLINETOOL.
%
%   LSQ_SPLINE(X,Y) creates a plot, similar to the plot in SPLINETOOL,
%   using the data that you provide as input.
%   You can apply this function to the same data you used with
%   SPLINETOOL or with different data. You may want to edit the
%   function to customize the code or even this help message.

%   Make sure the data are in rows ...
x = x(:).'; y = y(:).';
% ... and start by plotting the data specific to the highlighted spline fit.

firstbox = [0.1300  0.4900  0.7750  0.4850];
subplot('Position',firstbox)
plot(x,y,'ok'), hold on
names={'data'};
ylabel('im_dpix_mean')
xtick = get(gca,'Xtick');
set(gca,'xtick',[])

% we are starting off with the least squares polynomial approximation of 
% order 4:
spline1 = spap2(1,4,x,y); 
names{end+1} = 'spline1'; fnplt(spline1,'-',2)


%   Plot the second graph from SPLINETOOL

subplot('Position',[ 0.1300  0.1300  0.7750  0.3100])
plot(xtick([1 end]),zeros(1,2),'LineWidth',2,'Color',repmat(.6,1,3))
hold on
plot(x,y-fnval(spline1,x),'LineWidth',2)
hold off
ylabel('Error in spline1')
xlabel('wavelength')


%   Return to plotting the first graph
subplot('Position', firstbox)


legend(names{:})
hold off
set(gcf,'NextPlot','replace')
