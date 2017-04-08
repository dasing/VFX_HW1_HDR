function [ xdir_shift, ydir_shift ] = subMTB( binImg1, binImg2, ignoreMap1, ignoreMap2, l )

    preX_shift = 0;
    preY_shift = 0;

    if( l ~= 0 )
        
        %%% DownSampling
        dwnbinImg1 = imresize( binImg1, 0.5 );
        dwnbinImg2 = imresize( binImg2, 0.5 );
        dwnignoreMap1 = imresize( ignoreMap1, 0.5 );
        dwnignoreMap2 = imresize( ignoreMap2, 0.5 );
        
        [ xdir, ydir ] = subMTB( dwnbinImg1, dwnbinImg2, dwnignoreMap1, dwnignoreMap2, l-1 );
        
        %%% Update Shifting
        preX_shift = xdir*2;
        preY_shift = ydir*2;
        
        binImg1 = shiftImg( binImg1, preX_shift, preY_shift );
        ignoreMap1 = shiftImg( ignoreMap1, preX_shift, preY_shift );
        binImg2 = shiftImg( binImg2, -preX_shift, -preY_shift );
        ignoreMap2 = shiftImg( ignoreMap2, -preX_shift, -preY_shift );

    end

    %%%Dir: 1 -> (-1, -1), 
    %%%     2 -> (-1, 0 ), 
    %%%     3 -> (-1, 1 ), 
    %%%     4 -> ( 0, -1) , 
    %%%     5 -> (0, 0 ), 
    %%%     6 -> ( 0, 1 ), 
    %%%     7 -> ( 1, -1 ),
    %%%     8 -> ( 1, 0 ),
    %%%     9 -> ( 1, 1 )
    
      filename1 = strcat('testData/binImg1',num2str(l),'.png');
      filename2 = strcat('testData/binImg2',num2str(l),'.png');
      imwrite( binImg1, filename1, 'png' );
      imwrite( binImg2, filename2, 'png');
%     
      fileName = strcat('testData/diffMap', num2str(l), '.png' );
      diffMap = xor(binImg1, binImg2);
      imwrite( diffMap, fileName, 'png' );
    
    
    %%%Find best dir and shift, open a matrix with size 9*max_shift to
    %%%store the error
    max_shift = 1;
    errorMatrix = zeros(size( 9, max_shift ));
    
    for i = 1:max_shift
        errorMatrix( 1, i ) = countError( -1, -1, i, binImg1, binImg2, ignoreMap1, ignoreMap2, l );
        errorMatrix( 2, i ) = countError( -1, 0, i, binImg1, binImg2, ignoreMap1, ignoreMap2, l );
        errorMatrix( 3, i ) = countError( -1, 1, i, binImg1, binImg2, ignoreMap1, ignoreMap2, l );
        errorMatrix( 4, i ) = countError( 0, -1, i, binImg1, binImg2, ignoreMap1, ignoreMap2, l );
        errorMatrix( 5, i ) = countError( 0, 0, i, binImg1, binImg2, ignoreMap1, ignoreMap2, l );
        errorMatrix( 6, i ) = countError( 0, 1, i, binImg1, binImg2, ignoreMap1, ignoreMap2, l );
        errorMatrix( 7, i ) = countError( 1, -1, i, binImg1, binImg2, ignoreMap1, ignoreMap2, l );
        errorMatrix( 8, i ) = countError( 1, 0, i, binImg1, binImg2, ignoreMap1, ignoreMap2, l );
        errorMatrix( 9, i ) = countError( 1, 1, i, binImg1, binImg2, ignoreMap1, ignoreMap2, l );
    end
    
%     disp('level = ')
%     disp(l)
%     disp('errorMatrix')
%     disp(errorMatrix)
    
    %%%Find Min as best dir and shift
     [ M, I ] = min(errorMatrix(:));
    
    %%%Check if (0,0) is min
    min_nonShift = min(errorMatrix( 5, : ) );
    
    if min_nonShift <= M
        xdir_shift = preX_shift;
        ydir_shift = preY_shift;
    else
        shift_best = floor((I-1)/9) +1;
        dir = rem( I, 9 );
        if( dir == 0 )
            dir = 9;
        end
        
        xdir_shift = (floor((dir-1)/3)-1)*shift_best + preX_shift;
        ydir_shift = (rem( dir-1, 3 )-1)*shift_best + preY_shift;
    end
    
%     disp('min error is ')
%     disp(M)
%     disp('idx is')
%     disp(I)
%     
%     disp('x_dir is ');
%     disp(xdir_shift);
%     disp('y_dir is');
%     disp(ydir_shift);
    
    return;
    
end