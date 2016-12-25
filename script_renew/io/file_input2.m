function A = file_input2(filename)
  a = 12345
  filename
  fid = fopen(filename,'r');
  title = fgets(fid);
  A = fscanf(fid,'%f,%f,%f,%f\n',[4,inf]);
  fclose(fid);
end
