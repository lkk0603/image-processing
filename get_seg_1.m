function mask = get_seg_1(img)
% ��ɫת��
J = rgb2lab(img);
im = mat2gray(J(:,:,2));
% ��ֵ���ָ�
bw = imbinarize(im,'adaptive','ForegroundPolarity','dark','Sensitivity',0.9);
% ��̬ѧ�˲�
bw2 = imclose(bw, strel('disk', 5));
bw2 = imclose(bw2, strel('line', 15, 45));
bw2 = imclose(bw2, strel('line', 15, -45));
% ��ͨ�����
[L, num] = bwlabel(bw2);
stats = regionprops(L);
for i = 1 : num
    % ����ɸѡ
    recti = stats(i).BoundingBox;
    if max(recti(3:4)) < 250
        bw2(L == i) = 0;
    end
end
mask = logical(bw2);
mask = imfill(mask, 'holes');