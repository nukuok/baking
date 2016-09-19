function out_dir_part = create_output_folder(out_file_dir, ii, jj)
  out_dir_part = sprintf('result_20160919/%03d-%03d/', ii, jj)
  [s, m, mi] = mkdir(out_dir_part);
end
