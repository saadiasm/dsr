function saveFinalRegions()
global final;
global cc;
global pd;
global const;

final.num_ellipses
% To save all final's data use below
% save('tmp.dat','-struct','final.regions');

% To save only regions, do this
r=final.regions;
fname = sprintf('%s\\FinalRegions.dat',pd.outDir);
save(fname,'r');

% To get 'r' in workspace again, use this:
% load(fname,'r','-mat');
end
