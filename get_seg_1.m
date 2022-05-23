function mask = get_seg_1(img)
% 颜色转换
J = rgb2lab(img);
im = mat2gray(J(:,:,2));
% 二值化分割
bw = imbinarize(im,'adaptive','ForegroundPolarity','dark','Sensitivity',0.9);
% 形态学滤波
bw2 = imclose(bw, strel('disk', 5));
bw2 = imclose(bw2, strel('line', 15, 45));
bw2 = imclose(bw2, strel('line', 15, -45));
% 连通域分析
[L, num] = bwlabel(bw2);
stats = regionprops(L);
for i = 1 : num
    % 区域筛选
    recti = stats(i).BoundingBox;
    if max(recti(3:4)) < 250
        bw2(L == i) = 0;
    end
end
mask = logical(bw2);
mask = imfill(mask, 'holes');