function mask3 = get_seg_3(img, mask, mask2)
% ��ɫת��
J = rgb2ycbcr(img);
im = mat2gray(J(:,:,1));
im = imcomplement(im);
% ����ָ�
bw = imbinarize(im,'adaptive','ForegroundPolarity','dark','Sensitivity',0.95);
bw2 = imclose(bw, strel('disk', 50));
bw2 = imclose(bw2, strel('line', 15, 45));
bw2 = imclose(bw2, strel('line', 15, -45));
bw2 = imfill(bw2, 'holes');
% ��ͨ�����
[L, ~] = bwlabel(bw2);
stats = regionprops(L);
ar = cat(1, stats.Area);
[~, ind_max_ar] = max(ar);
bw2(L ~= ind_max_ar) = 0;
bw2 = imclose(bw2, strel('disk', 100));
bw2 = imclose(bw2, strel('square', 500));
% ����ɸѡ
mask = imdilate(mask, strel('disk', 50));
mask2 = imdilate(mask2, strel('disk', 50));
bw2(mask) = 0;
bw2(mask2) = 0;
mask3 = logical(bw2);
[L, ~] = bwlabel(mask3);
stats = regionprops(L);
ar = cat(1, stats.Area);
[~, ind_max_ar] = max(ar);
mask3(L ~= ind_max_ar) = 0;

