function eMap = HDR( dirname )

    %% Readfile
    file = dir([dirname '/' '*.jpg']);
    pNum = size(file, 1);
    img = {};
    shutter = [];
    
    %% Store img and Shutter speed
     for i = 1: pNum
         img{i} = imread([dirname '/' file(i).name]);
         subString = strsplit( file(i).name, '_');
         info = subString{4};
         tmp = info(1:end-4);
         shutter(i) = str2num(tmp);
     end

    
%     for i = 1: pNum
%         
%         img{i} = imread([dirname '/' file(i).name]);
%         tmp = imfinfo([dirname '/' file(i).name]);
%         shutter(i) = tmp.DigitalCamera.ExposureTime;
%     end
    B = log(shutter);
    
    %% Construct W
    W = 1:256; 
    for i = 1:256
        if( i <= 127 )
            W(i) = i;
        else
            W(i) = 256-i;
        end
    end
    
    
    %% Construct Z
    p = 200;
    w = size(img{1}, 2);
    h = size(img{1}, 1);
    point = zeros( p, 2 );
    %%% Choose Brightest pixel
    %%% Use the lastest picture to choose
    manualP = 0;
%     figure, imshow(img{pNum})
%     grayImg = rgb2gray(img{pNum});
%     maximum = max(grayImg(:));
%     a = maximum-grayImg;
%     indices = find( a == 0, manualP );
    
%     idx = randperm(length(indices));
%     indices = indices(idx);
%     
%     
%     [ idx_h, idx_w ] = ind2sub( [ h, w ] ,indices );
%     
%     point( 1:manualP, 1 ) = idx_h(:);
%     point( 1:manualP, 2 ) = idx_w(:);
    
    %%% Random pixel
    randomP = p - manualP;
   
    rand_pixel_h = randi([ 1 h ], [ randomP 1 ], 'int32' );
    rand_pixel_w = randi([ 1 w ], [ randomP 1 ], 'int32' );
    
    point( manualP+1: p, 1 ) = rand_pixel_h;
    point( manualP+1: p, 2 ) = rand_pixel_w;
    
    
    Z = {};
    color = 3;
    for j = 1:pNum
        for i = 1:p
            for k = 1:color
                Z{k}( i, j ) = img{j}( point(i,1), point(i,2), k );
            end
        end
    end
    
    %% Solve linear equation
     g = {};
     lE = {};
     lamda = 0.1;
     for i = 1: color
         [g{i}, lE{i}] = gsolve(Z{i}, B, lamda, W);
     end
     
%       figure, title('R'), plot(g{1});
%       figure, title('G'), plot(g{2});
%       figure, title('B'), plot(g{3});
      
    
    %% Construct radiance map
    c = 3;
    eMap = zeros(h, w, c);
    
    for i = 1: h
        for j = 1: w
            for k = 1: c
                numerator = 0;
                denominator = 0;
                for t = 1: pNum
                    numerator = numerator + W(img{t}(i,j,k) + 1) * (g{k}(img{t}(i,j,k) + 1) - B(t));
                    denominator = denominator + W(img{t}(i,j,k) + 1);
                end
                if denominator == 0
                    eMap(i, j, k) = 1;
              
                else
                    eMap(i, j, k) = exp(numerator / denominator);
                end
            end
        end
    end
    
    
    name = strcat( dirname, '/', 'result_emap.hdr ');
    hdrwrite( eMap, name );
    
    
    %% ToneMapping
    
     hdr = tonemap(eMap);
     %figure, imshow(hdr);
     
end