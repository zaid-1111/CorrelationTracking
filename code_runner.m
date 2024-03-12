clear all
close all
% EXAMPLE EMAILED BY MARK
% frame n=1
load('track005a_rev1000030826_210636_0009.mat')
n=1;
dx=bsxfun(@minus,px(1:250,n+1),px(1:250,n)');
dy=bsxfun(@minus,py(1:250,n+1),py(1:250,n)');
[mn ii]=min(hypot(dx,dy));
plot([px(1:250,n) px(ii,n+1)]' ,[py(1:250,n) py(ii,n+1)]','.-');

% load in position data:
% px and py are NBallMax x Nframes positions
% Npf is the number of particles per frame
% Often Npf is a constant, but in this data particles are entering and leaving the frame
% so the x positions of the particles in frame nf are px(1:Npf(nf),nf)
% Set diameter of particles
D=14;
% this script finds matches for the particle in frame nf with those in nf+1
% It works in several passes. On each pass it calculates an average
% displacement field dx(x,y), dy(x,y) using script calcfield. Then it finds the
% best match between the positions frame nf and the positions minus the displacements in
% frame nf+1; by adding the displacement field, we have a better guess where the particle
% will have moved. If your particles don’t have a mean velocity then you can ignore that part. 
%connnew02
% show a movie of the results cc is the connection matrix. 
%showcc2
% connect all of the pairwise connections to full trajectories
connect03
% show the results and make sxx and syy lists of the trajectories
calctr