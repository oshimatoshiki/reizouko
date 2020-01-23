
%�@�摜�t�H���_�ւ̃p�X
ps='./psnr/choco/';

% ���摜�@
ogl = dir([ps,'*orgl.jpg*']);
orgl=imread([ps,ogl.name]);
orgl = reSZ(orgl);

% �w�i�摜
bck = dir([ps,'*back.jpg*']);
bk=imread([ps,bck.name]);
bk=reSZ(bk);

% �}�X�N�摜
mama = dir([ps,'*mask.jpg*']);
msk=imread([ps,mama.name]);
msk=reSZ(msk);

% Edgeconnect�C���摜
dede = dir([ps,'*deep.jpg*']);
or_d=imread([ps,dede.name]);
or_d = reSZ(or_d);


% superpixel�̌v�Z
A = or_d;
[L,N] = superpixels(A,500);

% �̈�̕��ϒl�̌v�Z
A_out = superpx(A,L,N);
bk_out = superpx(bk,L,N);
orgl_out = superpx(orgl,L,N);

% ���̗̈�̒��o------�w�i��Edgeconnect�摜�̍���
mask = bk - or_d;
mask = rgb2gray(mask);
mask(mask < 20) = 0;       %�@20��臒l�Œ��߉\
mask(mask~=0)=1;


% ���̗̈�̒��o(superpixel)------���E�̕��ϒl�摜�̍���
Outs = bk_out - A_out;
Outs=rgb2gray(Outs);
Outs(Outs < 5) = 0;       %�@5��臒l�Œ��߉\
Outs(Outs ~=  0 )=1;


sa =A_out .*mask .*Outs;

% superpixel�摜�ŕ��̗̈�̂�
SAP = A_out .*Outs;
SAPP = rgb2gray(SAP);
SAPP(SAPP~=0) = 1;

% �w�i�̈�ƕ��̂𒣂荇�킹��
Haikei = ~SAPP;
Image = orgl.* SAPP  +  bk .* uint8(Haikei);

% ���o�������̗̈�ƃ}�X�N�摜���d�Ȃ�̈�
Keson = SAPP & msk;
New_keson = Image .* uint8(~Keson);

figure
imshow(New_keson)

Mask_TV = uint8(~Keson);


MM = bk - New_keson;
MM = rgb2gray(MM);
MM(MM<5)=0;         %�@5��臒l�Œ��߉\
MM(MM~=0)=1;


GAZOU = New_keson;
MASK = Mask_TV;
Gpic = New_keson .* MM .* mask;

image_TV = inpaintTV(GAZOU,MASK);

figure 
imshow(image_TV)

%2���

[L2,N2] = superpixels(image_TV,500);

A2_out = superpx(image_TV,L2,N2);
bk_out = superpx(bk,L2,N2);

SS = bk_out - A2_out;
SS = rgb2gray(SS);
SS(SS<5)=0;
SS(SS~=0)=1;

Haikei = ~SS;
Image = orgl.* SS  +  bk .* uint8(Haikei);

Keson2 = SS & msk;
New_keson2 = Image .* uint8(~Keson2);
Mask_TV2 = uint8(~Keson2);

GAZOU2 = New_keson2;
MASK2 = Mask_TV2;
%Gpic = New_keson .* MM;


ol = orgl .* uint8(~msk) + bk .* msk;

% for Exemplar 
GZ = GAZOU2;
MK = MASK2;

Last_result = exemplar(GZ,MK,Gpic);

figure
imshow(Last_result)

















