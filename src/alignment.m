function alignment( dirname, targetName, resultDirName )

    %% Parameter
    level = 6;
    max_x_shift = 0;
    max_y_shift = 0;
    shutter = [];
    
    %% Readfile
    file = dir([dirname '/' '*.jpg']);
    pNum = size(file, 1);
    
    %% Alignment
    img= {};
    for i = 1:pNum
        
        if( strcmp(file(i).name, targetName) == 0 )
            objName = [ dirname '/' file(i).name ];
            tarName = [ dirname '/' targetName ];
            [ x_shift, y_shift, img{i} ] = MTB( objName, tarName, level );
            if( abs(x_shift) > abs(max_x_shift ) )
                max_x_shift = x_shift;
            end
            
            if( abs(y_shift) > abs(max_y_shift ) )
                max_y_shift = y_shift;
            end
        else
            img{i} = imread([ dirname '/' file(i).name ]);
        end
    end
    
    disp( max_x_shift )
    disp( max_y_shift)
    
    %% Crop Image
    [ h, w, c ] = size(img{1});
    
    
    if( max_x_shift > 0 )
        for i = 1:pNum
            img{i} = imcrop( img{i}, [ max_x_shift+1 1 w-max_x_shift h ] );
        end
    else
        for i = 1:pNum
            img{i} = imcrop( img{i}, [ 1 1 w+max_x_shift h ] );
        end
    end
    
    if( max_y_shift > 0 )
        for i = 1:pNum
            img{i} = imcrop( img{i}, [ 1 max_y_shift w h-max_y_shift ] );
        end
    else
        for i = 1:pNum
            img{i} = imcrop( img{i}, [ 1 1 w h+max_y_shift ] );
        end
    end
    
    %% Write Image
    for i = 1:pNum
        fileName = [ resultDirName '/' file(i).name ];
        imwrite( img{i}, fileName, 'jpg' );
    end
end