function out_dir_part = create_output_folder(out_file_dir, ii, jj)
  out_dir_part = sprintf('%s/%03d-%03d/', out_file_dir, ii, jj)
  [s, m, mi] = mkdir(out_dir_part);
end
