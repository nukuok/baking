function result = up_or_down(column, target_index, view_length)
    half_view_length = ceil(view_length / 2);
    base_value = column(target_index);
    view_region = column(target_index + 1: target_index + view_length);
    larger_than_base = sum(view_region > base_value);
    result = 2 * ((larger_than_base >= half_view_length) - 0.5);
end