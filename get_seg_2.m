function mask2 = get_seg_2(img, mask)
% 颜色转换
mask = imdilate(mask, strel('disk', 50));
J = rgb2lab(img);
% 提取边缘
im = mat2gray(J(:,:,1));
ed = edge(im, 'sobel', 'both');
ed(mask) = 0;
% 形态学滤波
ed2 = imclose(ed, strel('disk', 5));
ed2 = imopen(ed2, strel('square', 8));
ed2 = bwareaopen(ed2, 20);
ed2 = imclose(ed2, strel('disk', 25));
ed2 = bwareaopen(ed2, 100);
ed2 = imclose(ed2, strel('line', 50, 45));
ed2 = imclose(ed2, strel('line', 50, -45));
% 连通域分析1
[L, num] = bwlabel(ed2);
stats = regionprops(L);
for i = 1 : num
    % 区域筛选
    recti = stats(i).BoundingBox;
    if max(recti(3:4)) < 100
        ed2(L == i) = 0;
    end
end
ed2 = imclose(ed2, strel('disk', 100));
% 连通域分析2
[L, num] = bwlabel(ed2);
stats = regionprops(L, 'BoundingBox', 'Solidity');
rects = cat(1, stats.BoundingBox);
mrc = max(max(rects(:, 3:4)));
for i = 1 : num
    % 区域筛选
    if stats(i).Solidity < 0.6 || min(stats(i).BoundingBox(:, 3:4)) < 70
        ed2(L == i) = 0;
    end
end
mask2 = logical(ed2);
mask2 = imfill(mask2, 'holes');