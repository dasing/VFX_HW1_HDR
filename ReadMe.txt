#### Compile Environment ####
macOS Sierra
10.12.3
MATLAB

#### Execute ####
alignment program: ./src/alignment( dirname, targetName, resultDirName ) 
//dirname-> dir stores photos, targetName->target photo name, resultDirName->dir to store result photos

HDR program: ./src/HDR( dirname ) ------> dirname->dir stores photos
//this function will generate a hdr file in original dir

tone mapping program: ./src/toneMap( eMap, keyValue, saturation, mode )
//eMap-> radiance map, keyValue-> user specified, saturation->user specified, mode->global or local


