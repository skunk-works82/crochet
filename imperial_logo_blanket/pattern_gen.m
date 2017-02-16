%% Load in the file

pattern = imread('pattern.jpg');
pattern = pattern(:,:,1);
% pattern = rot90( pattern );

%Force symmetry
pattern = pattern(1:320, 1:160);
pattern = cat(2, pattern, fliplr(pattern) );
pattern = cat(1, pattern, flipud(pattern) );

%pattern size based on 12S/15R stitch gauge
width  = 108;
height = 270;

imr = imresize( pattern, [height, width] );
imr = imr > 128;

figure(1);
clf;
imagesc( imr );
axis image;

%% Print the pattern matrix %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
file = 'pattern.txt';
fid = fopen(file, 'w+');

fprintf(fid, '-------------------------------------------\n');

for i=1:size( imr, 1 )
   row = double(imr(i,:));
   
   fprintf(fid,  '%3.1i:  ', i);
   fprintf(fid,  '%3.1i  ', row );
   fprintf(fid, '\n'); 
    
   if mod(i,10) == 0
       fprintf(fid, '---------------------------------------------\n      ');
       fprintf(fid, '%3.0i  ', 1:numel(row));
       fprintf(fid, '\n'); 
   end
end


fclose(fid);

%% Reduce pattern into stitch counts %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
file = 'pattern_reduced.txt';
fid = fopen(file, 'w+');

fprintf(fid, '-------------------------------------------\n');

for i=1:size( imr, 1 )
   row = double(imr(i,:));
   
   
   current_idx = 0;
   counts = 0;
   idxs   = 0;
   for j=1:numel(row)
       if row(j) == current_idx
           counts(end) = counts(end)+1; 
       else
           counts(end+1) = 1;
           idxs(end+1)   = row(j);
           current_idx = row(j);           
       end     
   end
   
   fprintf(fid, '%3.0i| ', i);
   arrayfun(@(a,b) fprintf(fid, '%2.0i:%i ', a, b), counts, idxs );
   fprintf(fid, '\n'); 
    
   if mod(i,10) == 0
       fprintf(fid, '---------------------------------------------\n'); 
   end
end


fclose(fid);

%% Print the ascii image of the pattern %%%%%%%%%%%%%%%%%%%%%%%%
file = 'pattern_matrix.txt';
fid = fopen(file, 'w+');


for i=1:size( imr, 1 )
   row = double(imr(i,:));
   
   fprintf(fid,  '%i', row );
   fprintf(fid, '\n'); 
    
end


fclose(fid);