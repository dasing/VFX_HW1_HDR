function toneMap( eMap, keyValue, saturation, mode )
%% Parameter
    delta = 1e-3;
    phi = 2;
    epsilon = 0.05;
    level = 9;
    w = size( eMap, 2 );
    h = size( eMap, 1 );
    N = size(eMap, 1 ) * size(eMap, 2);

     for i = 1:3
           average = exp( sum(sum(log( delta + eMap(:,:,i) ) ) )/N );
           eMap(:,:,i) = eMap(:, :, i )./average;
           eMap(:,:,i) = eMap(:, :, i )./ (1+eMap(:, :, i) );
     end
    
    Lw = 0.2989*eMap(:,:,1) +  0.5870*eMap(:,:,2) + 0.1140*eMap(:,:,3);
    
    Lw_average = exp( sum( sum( log( delta + Lw ) ) )/ N );
    Lm = ( keyValue * Lw )./ Lw_average;
    Lwhite = max(Lm(:));
    
    %% Global
    if( strcmp(mode, 'global') )
        Ld = (Lm.*(1+Lm./(Lwhite*Lwhite)))./(1+Lm);
    end
    
    %% Local
    
    if( strcmp(mode ,'local') )
         LsBlur = {};
         alpha = 1/(2*sqrt(2));
         Smax = zeros(h,w);
         
         for i = 1:level
            S(i) =  1.6^(i-1);
         end

         LsBlur{1} = Lm;
         %%% construct LsBlur
         for i = 2:level+1
             s = S(i-1);
             
             sigma = s*alpha;
             kernelRadius = ceil(2*sigma);
             kernelSize = 2*kernelRadius+1;
            
             Gs = fspecial('gaussian',[kernelSize, kernelSize], sigma );
             LsBlur{i} = imfilter( Lm, Gs );
             %Lm1 = log(Lm);
             %tmp = imfilter(Lm1, Gs);
             %LsBlur{i} = exp(tmp);
         end

         %%% compute Vs
        V={};
        for i = 2:level
            V{i} = ( LsBlur{i} - LsBlur{i+1} )./( 2^phi*keyValue/(S(i)^2)+LsBlur{i} );
        end

        for i = 2:level
             indices = find( abs(V{i}) < epsilon );
             Smax(indices) = i;
        end

         indices = find( Smax == 0 );
         Smax(indices) = 1;

        Ld = zeros(size(Lw));
        for i = 1:h
            for j = 1:w
                Ld( i, j ) = Lm( i, j )/(1+LsBlur{Smax(i,j)}(i,j));
            end
        end
    end

    %% Display
    color = 3;

    ldrPic = zeros(size(eMap));
    for i = 1: color
        ldrPic( :, :, i ) = ( (eMap( :, :, i )./Lw) .^ saturation ).*(Ld);
    end
    
    indices = find( ldrPic > 1 );
    ldrPic(indices) = 1;
    
    figure, imshow(ldrPic)
     if( strcmp(mode, 'global') )
        
        fileName = strcat( 'result_global.png ');
        imwrite( ldrPic, fileName, 'png' );
    else
        fileName = strcat( 'result_local.png ');
        imwrite( ldrPic, fileName, 'png' );
    end
    
    
end