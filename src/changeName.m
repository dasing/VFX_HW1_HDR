function changeName(dirName)
    file = dir([dirName '/' '*.jpg']);
    pNum = size(file, 1);

    for i = 1:pNum
        fileName = [dirName '/' file(i).name];
        info = imfinfo(fileName);
        shutter_time = info.DigitalCamera.ExposureTime;        
        tmp = fileName(1:end-4);
         fileFormat = fileName(end-3:end);
         newFileName = [ tmp '_shutter_' num2str(shutter_time) fileFormat ];
         disp(newFileName)
         movefile( fileName, newFileName );
        
    end
end