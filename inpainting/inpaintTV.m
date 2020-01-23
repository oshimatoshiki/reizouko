function outputArg1 = inpaintTV(inputArg1,inputArg2)
%INPAINTTV この関数の概要をここに記述
%   詳細説明をここに記述


p=1; %Lpノルムのpにあたる
lambda=10^(6);
epsilon=10^(-6);

%画像の読み込み
% I = imread('camera1_029_4.png');
image1=double(inputArg1);

%原画像の表示
% figure
% imshow(uint8(image1));
% % 
%行数をm、列数をnとする
[m,n,~]=size(image1);

% for jj = 1:10:m
%     mask(jj,:) = 1;
% end


mask = double(inputArg2);

%maskした画像を表示
% figure
%  imshow(uint8(image1 .* mask));
% % 
%画像の輝度を求める
im=rgb2ycbcr(uint8(image1));
im=double(im);

%maskの値をベクタライズする
mask_vec=mask(:);

%mask_vecの成分を対角成分に持つMの作成
M=spdiags(mask_vec,0,m*n,m*n);

%縦成分の差分を計算する
%C1=eye(n);
%A=speye(m-1,m);
%B=spdiags(ones(m-1,1),1,m-1,m);
%C2=A-B;
%D1=kron(C1,C2);
%横成分の差分を計算する
%E=speye(m*(n-1),m*n);
%F=spdiags(ones(m*(n-1),1),m,m*(n-1),m*n);
%D2=E-F;
D1 = kron(speye(n,n),speye(m-1,m)-spdiags(ones(m-1,1),1,m-1,m));
D2 = speye((n-1)*m,n*m)-spdiags(ones((n-1)*m,1),m,(n-1)*m,n*m);

% D=vertcat(D1,D2);
D=[D1;D2];
[a,b]=size(D);

%numはIRLSの繰り返す回数
num=50;

image_repaired=zeros(m,n,3);

for ii=1:3
imycbcr=im(:,:,ii);

%ベクタライズする
imycbcr_vec=imycbcr(:);

%重みの初期値は1
w=ones(a,1);
w_st(:,1)=w;
x=ones(m*n,1);
x_st(:,1)=x;

for i=1:1:num
%重みの値を対角成分に持つ行列の生成
W=spdiags(w,0,a,a);
x=(D'*(W')*W*D+lambda*(M')*M)\(lambda*(M')*M*imycbcr_vec);
%求めた解を保存する
x_st(:,i)=x;
%重み関数wを再作成する
w=(abs(D*x_st(:,i))+epsilon).^((p/2)-1);
%重み関数を保存する
w_st(:,i+1)=w;
end

%ベクタライズしたものをm*nの行列に直す
image_repaired_rgb=reshape(x,m,n);
image_repaired(:,:,ii) = image_repaired_rgb;
%修復した画像を出力
%figure
%imshow(uint8(X));
end
%修復した画像を出力
image_repaired1 = ycbcr2rgb(uint8(image_repaired));

outputArg1 = image_repaired1;

% %PSNRを求める
% image1 = uint8(image1);
% PSNR = psnr(image_repaired,image1);
% SSIM = ssim(image_repaired,image1);
% 
% %欠損率を求める
% count = 0;
% for lri=1:1:m
%     for lrj=1:1:n
%         if mask(lri,lrj)==0
%             count = count+1;
%         end
%     end
% end
% LR = count/(m*n);



end

