function BND = get_BND(input_filename);
  BND_index = regexp(input_filename, 'BND[12]');
  BND = input_filename(BND_index + 3);
end
