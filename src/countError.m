function error = countError(  xdir, ydir, shift, binImg1, binImg2, ignoreMap1, ignoreMap2, level  )

    %%% Shifting
    x_shift = xdir*shift;
    y_shift = ydir*shift;
    
    binImg1 = shiftImg( binImg1, x_shift, y_shift );
    ignoreMap1 = shiftImg( ignoreMap1, x_shift, y_shift );
    binImg2 = shiftImg( binImg2, -x_shift, -y_shift );
    ignoreMap2 = shiftImg( ignoreMap2, -x_shift, -y_shift );
    
    
%      filename1 = strcat('testData/binImg1_l',num2str(level), '_x' ,num2str(xdir*shift),'_y', num2str(ydir*shift),'.png');
%      filename2 = strcat('testData/binImg2_l',num2str(level), '_x' ,num2str(xdir*shift),'_y', num2str(ydir*shift),'.png');
%      imwrite( binImg1, filename1, 'png' );
%      imwrite( binImg2, filename2, 'png');
%      
%      fileName = strcat('testData/diffMap_l', num2str(level), '_x', num2str(xdir*shift),'_y', num2str(ydir*shift), '.png' );
%      diffMap = xor(binImg1, binImg2);
%      imwrite( diffMap, fileName, 'png' );
    
    %error = sum(sum(xor( binImg1, binImg2 )));
    error = sum(sum (xor( binImg1, binImg2 ) & ignoreMap1 & ignoreMap2 ) );
    
end