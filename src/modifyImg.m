function newImg = modifyImg( oriImg, x_shift, y_shift )

    [ h, w, c ] = size(oriImg);
    if x_shift >= 0
        oriImg = padarray( oriImg, [ 0 x_shift ], 'pre' );
    else
        oriImg = padarray( oriImg, [ 0 abs(x_shift) ], 'post' );
    end
    
    if y_shift >= 0
        oriImg = padarray( oriImg, [ y_shift 0 ], 'pre' );
    else
        oriImg = padarray( oriImg, [ abs(y_shift) 0 ], 'post' );
    end
    
    if( x_shift <= 0 && y_shift <= 0 )
        newImg = oriImg( abs(y_shift)+1:h+abs(y_shift), 1+abs(x_shift):w+abs(x_shift), : );
    elseif( x_shift <= 0 && y_shift >= 0 )
        newImg = oriImg( 1:h,  1+abs(x_shift):w+abs(x_shift), : );
    elseif( y_shift <= 0 && x_shift >= 0 )
        newImg = oriImg( abs(y_shift)+1:h+abs(y_shift), 1:w, : );
    else
        newImg = oriImg( 1:h, 1:w, : );
    end
end