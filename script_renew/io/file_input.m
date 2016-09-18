function A = file_input(filename)
    fid = fopen(filename,'r');
    title = fgets(fid);
    A = fscanf(fid,'%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f',[14,inf]);
    fclose(fid);
end