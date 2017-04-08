function newImg = shiftImg( img, x_shift, y_shift )

    %%% Positive Direction: right and down

    [ h, w, c ] = size( img );
   
    img = padarray( img, [ abs(y_shift) abs(x_shift) ] );
    img = circshift( img, [ y_shift x_shift ] );
    if( c == 1 )
        if( y_shift >= 0 && x_shift >= 0 )
            newImg = img( 2*y_shift+1:h+y_shift, 2*x_shift+1:w+x_shift );
        elseif( y_shift >= 0 && x_shift <= 0 )
            newImg = img( 2*y_shift+1:h+y_shift, abs(x_shift)+1:w );
        elseif( y_shift <= 0 && x_shift >= 0 )
            newImg = img(  abs(y_shift)+1:h,  2*x_shift+1:w+x_shift );
        elseif( y_shift <= 0 && x_shift <= 0 )
            newImg = img( abs(y_shift)+1:h, abs(x_shift)+1:w );
        end
    else
        if( y_shift >= 0 && x_shift >= 0 )
            newImg = img( 2*y_shift+1:h+y_shift, 2*x_shift+1:w+x_shift, : );
        elseif( y_shift >= 0 && x_shift <= 0 )
            newImg = img( 2*y_shift+1:h+y_shift, abs(x_shift)+1:w, : );
        elseif( y_shift <= 0 && x_shift >= 0 )
            newImg = img(  abs(y_shift)+1:h,  2*x_shift+1:w+x_shift, : );
        elseif( y_shift <= 0 && x_shift <= 0 )
            newImg = img( abs(y_shift)+1:h, abs(x_shift)+1:w, : );
        end
    end
    
    
    
end