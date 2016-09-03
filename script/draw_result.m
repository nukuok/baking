    fg = figure;
    hold on;
    plot(column,'r');

    % column(x1-6:x1+6)
    % column(x1+delta_x1-6:x1+delta_x1+6)
    for ii_dr = [1:3]
        plot([x(ii_dr),x(ii_dr)+delta_x(ii_dr)],...
            [column(x(ii_dr)),column(x(ii_dr))])
        plot([x(ii_dr)+delta_x(ii_dr),x(ii_dr)+delta_x(ii_dr)],...
            [column(x(ii_dr)),column(x(ii_dr)+delta_x(ii_dr))])
        text(x(ii_dr)+delta_x(ii_dr),...
            column(x(ii_dr)),...
            int2str(ii_dr))
    end
    
    plot([extracted_region_lower, extracted_region_lower], ...
            [15,25],'g--')
    plot([extracted_region_upper, extracted_region_upper], ...
            [15,25],'g--')
    text(extracted_region_lower, column(extracted_region_upper) + 2, ...
        int2str(extracted_region_lower)) 
    text(extracted_region_upper, column(extracted_region_upper) + 2, ...
        int2str(extracted_region_upper)) 
    % plot(region_updown)
    
    save_name = sprintf('/home/nukuok/Desktop/20160802/figure_time_region/%d.png', ii);
    saveas(fg,save_name);
    close(fg);
