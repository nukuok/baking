function file_output(filename,R)
    fid = fopen(filename, 'w');
    for ii = 1:length(R)
        fprintf(fid,'%f\n',R(ii));
    end
end