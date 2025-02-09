close all;
clear all;

addpath('utils')
load('./model/weights_srnet_x2_52.mat');

im_l = imread('./data/slena.bmp');
im_gt = imread('./data/mlena.bmp');

up_scale = 2;
shave = 1;

im_gt = modcrop(im_gt,up_scale);
im_gt = double(im_gt);
im_l  = double(im_l) / 255.0;

[H,W,C] = size(im_l);
if C == 3
    im_l_ycbcr = rgb2ycbcr(im_l);
else
    im_l_ycbcr = zeros(H,W,C);
    im_l_ycbcr(:,:,1) = im_l;
    im_l_ycbcr(:,:,2) = im_l;
    im_l_ycbcr(:,:,3) = im_l;
end
im_l_y = im_l_ycbcr(:,:,1) * 255;

tic;
im_h_y = SCN(im_l_y,model,up_scale);
toc;

im_h_ycbcr = imresize(im_l_ycbcr,up_scale,'bicubic');
im_b = ycbcr2rgb(im_h_ycbcr) * 255.0;
im_h_ycbcr(:,:,1) = im_h_y / 255.0;
im_h  = ycbcr2rgb(im_h_ycbcr) * 255.0;

figure;imshow(uint8(im_b));title('Bicubic Interpolation');
figure;imshow(uint8(im_h));title('SCN Reconstruction');
figure;imshow(uint8(im_gt));title('Grouth');


sr_psnr = compute_psnr(im_h,im_gt);
bi_psnr = compute_psnr(im_b,im_gt);
fprintf('sr_psnr: %f dB\n',sr_psnr);
fprintf('bi_psnr: %f dB\n',bi_psnr);

