function extracted_A = extract(A, item, lower, upper)
    [size_row, size_column] = size(A);
    indexes = A(item:size_row:size_row * size_column);
    extracted_A = A(:,(lower <= indexes & indexes <= upper)); 
end