function img_ezw_stream_bit = func_huffman_encode(significance_map, refinement);

img_ezw_stream_bit = [];
strings = size(significance_map,1);

for i = 1:strings,
    % insert significance map using Huffman
    index = 1;
    while(index <= size(significance_map,2) & ~strcmp(significance_map(i,index),' ')),
        if(strcmp(significance_map(i,index),'t')),
            img_ezw_stream_bit = [img_ezw_stream_bit '0'];
        elseif(strcmp(significance_map(i,index),'z')),
            img_ezw_stream_bit = [img_ezw_stream_bit '10'];
        elseif(strcmp(significance_map(i,index),'n')),
            img_ezw_stream_bit = [img_ezw_stream_bit '110'];
        else
            img_ezw_stream_bit = [img_ezw_stream_bit '1110'];
        end
        index = index + 1;
    end
    % insert seperator
    img_ezw_stream_bit = [img_ezw_stream_bit '1111'];
    refine = size(strrep(refinement(i,:), ' ', ''),2);
    % insert length of refinement (20 bits)
    img_ezw_stream_bit = [img_ezw_stream_bit strrep(char(dec2bin(refine,20)), ' ', '')];
    % insert refinement
    img_ezw_stream_bit = [img_ezw_stream_bit strrep(refinement(i,:), ' ', '')];
end

% append end of stream
img_ezw_stream_bit = [img_ezw_stream_bit '11111'];

% stringlength should be multiple of 8: append zeros
% ASCII code for '0' is 48
append = 8 - mod(size(img_ezw_stream_bit,2), 8);
img_ezw_stream_bit = [img_ezw_stream_bit char(ones(1,append)*48)];

