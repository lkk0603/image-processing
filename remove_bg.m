function img2 = remove_bg(img)
% È¥³ý±³¾°
J = rgb2hsv(img);
v = mat2gray(J(:,:,3));
bw = imbinarize(v,'adaptive','ForegroundPolarity','dark','Sensitivity',0.5);
img_1 = img(:,:,1); img_1(bw) = 255;
img_2 = img(:,:,2); img_2(bw) = 255;
img_3 = img(:,:,3); img_3(bw) = 255;
img2 = cat(3, img_1, img_2, img_3);
