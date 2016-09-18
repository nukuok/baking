function R_output_to_file(filename,R)
    fid = fopen(filename, 'w');
    for ii = 1:length(R)
        fprintf(fid,'%f\n',R(ii));
    end
end
