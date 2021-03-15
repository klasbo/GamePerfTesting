function colors = qual_seq(seq_variants, varargin)

    p = inputParser;
    p.KeepUnmatched = true;
    addParameter(p, 'flat',     false,          @islogical);
    addParameter(p, 'scheme',   'lines',        @(a) ismember(a, {'cartocolor' 'colorbrewer2' 'macsspring' 'lines'}));
    parse(p, varargin{:});
    
    scheme_cartocolor = {
        'd1eeea' 'a8dbd9' '85c4c9' '68abb8' '4f90a6' '3b738f' '2a5674' 
        'ecda9a' 'efc47e' 'f3ad6a' 'f7945d' 'f97b57' 'f66356' 'ee4d5a' 
        'f3e0f7' 'e4c7f1' 'd1afe8' 'b998dd' '9f82ce' '826dba' '63589f'
        'c4e6c3' '96d2a4' '6dbc90' '4da284' '36877a' '266b6e' '1d4f60'
        'ffc6c4' 'f4a3a8' 'e38191' 'cc607d' 'ad466c' '8b3058' '672044'  
    };

    scheme_colorbrewer2 = {
        'eff3ff' 'c6dbef' '9ecae1' '6baed6' '3182bd' '08519c'
        'feedde' 'fdd0a2' 'fdae6b' 'fd8d3c' 'e6550d' 'a63603'
        'edf8e9' 'c7e9c0' 'a1d99b' '74c476' '31a354' '006d2c'
        'f2f0f7' 'dadaeb' 'bcbddc' '9e9ac8' '756bb1' '54278f'
    };

    scheme_macsspring = {
        'D4EFFB' 'A6DEF4' '79CDEE' '4ABBE7' '1CAAE0' '1C99CF' '1C86BD' '20739F' '265D81'
        'FFEDBE' 'FAD79D' 'F4C07D' 'EEAA5C' 'E9923B' 'D68134' 'C46E2E' 'B25C27' '9F4920'
        'F2E6F1' 'E1D2E5' 'D0BDDA' 'BFA9CD' 'AE94C2' '9A7CB4' '8966A8' '775699' '6B4A90'
        'E8F1CD' 'D3E7AD' 'B9DB84' '9ECD5D' '8AC046' '79B041' '6D9D44' '608844' '547644'
        'FFE5D7' 'FECFC0' 'F8B2A2' 'F49787' 'F17C6C' 'E16458' 'CF4A46' 'B8323B' 'A32034'
        'FBF2BD' 'F8E399' 'F5D672' 'F2C951' 'EFBA38' 'D8AA45' 'C19A3F' 'A98A39' '927A36' 
        'D7EEED' 'B2E1E1' '8ED3D5' '69C6C8' '4CB7BB' '39A5AA' '33929A' '2E8189' '286E79'
        'FBE5EF' 'F8CEE2' 'F7B2D0' 'F396BF' 'F073AC' 'E05F96' 'CD4D83' 'B53A6A' 'A12D58'
    };
    scheme_lines = {
        '99E6FF' '85C7EC' '72A9D9' '608BC6' '506FB2' '42549F' '353C8C' '2B2979' '291F66'
        'FFDD66' 'F9CA57' 'F2B649' 'ECA13B' 'E58C2E' 'DF7521' 'D95F16' 'D2480B' 'CC3100'
        'ABE62E' '89D72B' '6AC928' '4EBA25' '36AC22' '209E20' '1D8F2C' '1A8135' '17733C'
        'FFCCFA' 'EFAAEF' 'D78BDF' 'BD6FCF' 'A156BF' '8440AF' '672C9F' '4C1B8F' '310D80'
        'FF4D00' 'EC2F03' 'D91505' 'C6070F' 'B20922' '9F0A31' '8C0B3B' '790B40' '660A41'
        'B2FFE8' '8FE9D1' '6ED2BC' '52BCA8' '3AA696' '268F84' '157972' '09635F' '004D4D'
        'FFE666' 'ECD053' 'D9BA41' 'C6A431' 'B28F24' '9F7A18' '8C670E' '795506' '664300'
    };
    %{
    scheme_bold = {
        '3969AC' '3969AC'
        'E68310' 'E68310'
        '7F3C8D' '7F3C8D'
        '11A579' '11A579'
        'F2B701' 'F2B701'
        'E73F74' 'E73F74'
        '80BA5A' '80BA5A'
        '008695' '008695'
        'CF1C90' 'CF1C90'
        'F97B72' 'F97B72'
        '4B4B8F' '4B4B8F'
        'A5AA99' 'A5AA99'
    };
    %}

    switch p.Results.scheme
        case 'cartocolor'
            scheme_hex = scheme_cartocolor;
        case 'colorbrewer2'
            scheme_hex = scheme_colorbrewer2;
        case 'macsspring'
            scheme_hex = scheme_macsspring;
        case 'lines'
            scheme_hex = scheme_lines;
        %case 'bold'
        %    scheme_hex = scheme_bold;
    end
    
    scheme = cellfun(@(a) hex2dec(reshape(a,2,[])')./255, scheme_hex, 'UniformOutput', false);
    
    [numColors, scheme_variants] = size(scheme_hex);
    numVariants = ones(1,numColors);
    if isscalar(seq_variants)
        numVariants = ones(1,numColors)*seq_variants;
    else
        numVariants(1:length(seq_variants)) = seq_variants;
    end
    
    polyfits = cell(numColors, 3);
    colors = cell(numColors,1);
    
    
    for color = 1:numColors
        rgb = [scheme{color,:}];
        for primary = 1:3
            polyfits{color,primary} = polyfit(linspace(0, 1, scheme_variants), rgb(primary,:), 2);
        end
        
        %{ 
        % plot polyfit match
        figure(color); clf; hold on;
            set(gca(), 'ColorOrder', eye(3));
            plot(rgb');
            plot(1:scheme_variants, cell2mat(arrayfun(@(primary) {polyval(polyfits{color, primary}, linspace(0,1,scheme_variants))'}, [1:3])));
            ylim([0 1]);
        %}
        
        if numVariants(color) > 1
            colors{color} = arrayfun( ...
                @(variant) {arrayfun( ...
                    @(primary) limit(polyval(polyfits{color, primary}, variant),[0,1]), ...
                    1:3)}, ...
                linspace(0, 1, numVariants(color)) ...
            )';
        else
            colors{color} = {arrayfun(@(primary) limit(polyval(polyfits{color, primary}, 0.5), [0,1]), 1:3)};
        end
    end
    
    %{ 
    % plot output colors
    figure(22); clf; hold on;
    for c = 1:numColors
        for v = 1:numVariants(c)
            col = colors{c}{v};
            plot(v, -c, 'o', 'markersize',50, 'markeredgecolor',col, 'markerfacecolor',col)
        end
    end
    %}
    
    if p.Results.flat
        colors = cell2mat(cellfun(@(a) cell2mat(a), colors, 'UniformOutput', false));
    end
    
end