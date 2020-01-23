function outputArg1 = inpaintTV(inputArg1,inputArg2)
%INPAINTTV ���̊֐��̊T�v�������ɋL�q
%   �ڍא����������ɋL�q


p=1; %Lp�m������p�ɂ�����
lambda=10^(6);
epsilon=10^(-6);

%�摜�̓ǂݍ���
% I = imread('camera1_029_4.png');
image1=double(inputArg1);

%���摜�̕\��
% figure
% imshow(uint8(image1));
% % 
%�s����m�A�񐔂�n�Ƃ���
[m,n,~]=size(image1);

% for jj = 1:10:m
%     mask(jj,:) = 1;
% end


mask = double(inputArg2);

%mask�����摜��\��
% figure
%  imshow(uint8(image1 .* mask));
% % 
%�摜�̋P�x�����߂�
im=rgb2ycbcr(uint8(image1));
im=double(im);

%mask�̒l���x�N�^���C�Y����
mask_vec=mask(:);

%mask_vec�̐�����Ίp�����Ɏ���M�̍쐬
M=spdiags(mask_vec,0,m*n,m*n);

%�c�����̍������v�Z����
%C1=eye(n);
%A=speye(m-1,m);
%B=spdiags(ones(m-1,1),1,m-1,m);
%C2=A-B;
%D1=kron(C1,C2);
%�������̍������v�Z����
%E=speye(m*(n-1),m*n);
%F=spdiags(ones(m*(n-1),1),m,m*(n-1),m*n);
%D2=E-F;
D1 = kron(speye(n,n),speye(m-1,m)-spdiags(ones(m-1,1),1,m-1,m));
D2 = speye((n-1)*m,n*m)-spdiags(ones((n-1)*m,1),m,(n-1)*m,n*m);

% D=vertcat(D1,D2);
D=[D1;D2];
[a,b]=size(D);

%num��IRLS�̌J��Ԃ���
num=50;

image_repaired=zeros(m,n,3);

for ii=1:3
imycbcr=im(:,:,ii);

%�x�N�^���C�Y����
imycbcr_vec=imycbcr(:);

%�d�݂̏����l��1
w=ones(a,1);
w_st(:,1)=w;
x=ones(m*n,1);
x_st(:,1)=x;

for i=1:1:num
%�d�݂̒l��Ίp�����Ɏ��s��̐���
W=spdiags(w,0,a,a);
x=(D'*(W')*W*D+lambda*(M')*M)\(lambda*(M')*M*imycbcr_vec);
%���߂�����ۑ�����
x_st(:,i)=x;
%�d�݊֐�w���č쐬����
w=(abs(D*x_st(:,i))+epsilon).^((p/2)-1);
%�d�݊֐���ۑ�����
w_st(:,i+1)=w;
end

%�x�N�^���C�Y�������̂�m*n�̍s��ɒ���
image_repaired_rgb=reshape(x,m,n);
image_repaired(:,:,ii) = image_repaired_rgb;
%�C�������摜���o��
%figure
%imshow(uint8(X));
end
%�C�������摜���o��
image_repaired1 = ycbcr2rgb(uint8(image_repaired));

outputArg1 = image_repaired1;

% %PSNR�����߂�
% image1 = uint8(image1);
% PSNR = psnr(image_repaired,image1);
% SSIM = ssim(image_repaired,image1);
% 
% %�����������߂�
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

