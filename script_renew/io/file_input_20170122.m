function A = file_input_20170122(filename)
  filename
  fid = fopen(filename,'r');
  title = fgets(fid);
  A = fscanf(fid,'%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f',[14,inf]);
  fclose(fid);
end
