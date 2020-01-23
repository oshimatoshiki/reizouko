function outputArg1 = superpx(inputArg1,inputArg2,inputArg3)
%SUPERPX この関数の概要をここに記述
%   詳細説明をここに記述
in1 = inputArg1;
in2 = inputArg2;
in3 = inputArg3;


outputImage = zeros(size(in1),'like',in1);
idx = label2idx(in2);
numRows = size(in1,1);
numCols = size(in1,2);
for labelVal = 1:in3
    redIdx = idx{labelVal};
    greenIdx = idx{labelVal}+numRows*numCols;
    blueIdx = idx{labelVal}+2*numRows*numCols;
    outputImage(redIdx) = mean(in1(redIdx));
    outputImage(greenIdx) = mean(in1(greenIdx));
    outputImage(blueIdx) = mean(in1(blueIdx));
end 

outputArg1 = outputImage;

end

