function A = file_input2(filename)
    fid = fopen(filename,'r');
    A = fscanf(fid,'"%f","%f"\n',[2 inf]);
    fclose(fid);
end
