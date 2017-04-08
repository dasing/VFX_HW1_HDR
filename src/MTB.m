function [ x_shift, y_shift, newImg ] = MTB( imga_name, imgb_name, level )

    oriImga = imread( imga_name );
    oriImgb = imread( imgb_name );
     
    %%%turn to gray image
    imga = rgb2gray(oriImga);
    imgb = rgb2gray(oriImgb);
    
    %%%compute median
    m1 = median(imga(:));
    m2 = median(imgb(:));
        
    %%%generate binary image
    binImga = imga > m1;
    binImgb = imgb > m2;
    
    %%%generate ignore map
     offset = 4;
     diff1 = abs(single(imga) - single(m1));
     diff2 = abs(single(imgb) - single(m2));
     
     ignoreMap1 = diff1 > offset;
     ignoreMap2 = diff2 > offset;
     
     [ x_shift, y_shift ] = subMTB( binImga, binImgb, ignoreMap1, ignoreMap2, level ); 
    
    %%% Shifting  
     disp('final x_shift = ')
     disp(x_shift)
     disp('final y_shift = ')
     disp(y_shift)
     
    fileName = strcat('result/',imga_name(1:end-4), '_alignment.png');
     newImg = modifyImg( oriImga, x_shift, y_shift );
    imwrite( newImg, fileName, 'png' );
    
end