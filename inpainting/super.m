
%　画像フォルダへのパス
ps='./psnr/choco/';

% 元画像　
ogl = dir([ps,'*orgl.jpg*']);
orgl=imread([ps,ogl.name]);
orgl = reSZ(orgl);

% 背景画像
bck = dir([ps,'*back.jpg*']);
bk=imread([ps,bck.name]);
bk=reSZ(bk);

% マスク画像
mama = dir([ps,'*mask.jpg*']);
msk=imread([ps,mama.name]);
msk=reSZ(msk);

% Edgeconnect修復画像
dede = dir([ps,'*deep.jpg*']);
or_d=imread([ps,dede.name]);
or_d = reSZ(or_d);


% superpixelの計算
A = or_d;
[L,N] = superpixels(A,500);

% 領域の平均値の計算
A_out = superpx(A,L,N);
bk_out = superpx(bk,L,N);
orgl_out = superpx(orgl,L,N);

% 物体領域の抽出------背景とEdgeconnect画像の差分
mask = bk - or_d;
mask = rgb2gray(mask);
mask(mask < 20) = 0;       %　20は閾値で調節可能
mask(mask~=0)=1;


% 物体領域の抽出(superpixel)------境界の平均値画像の差分
Outs = bk_out - A_out;
Outs=rgb2gray(Outs);
Outs(Outs < 5) = 0;       %　5は閾値で調節可能
Outs(Outs ~=  0 )=1;


sa =A_out .*mask .*Outs;

% superpixel画像で物体領域のみ
SAP = A_out .*Outs;
SAPP = rgb2gray(SAP);
SAPP(SAPP~=0) = 1;

% 背景領域と物体を張り合わせる
Haikei = ~SAPP;
Image = orgl.* SAPP  +  bk .* uint8(Haikei);

% 抽出した物体領域とマスク画像が重なる領域
Keson = SAPP & msk;
New_keson = Image .* uint8(~Keson);

figure
imshow(New_keson)

Mask_TV = uint8(~Keson);


MM = bk - New_keson;
MM = rgb2gray(MM);
MM(MM<5)=0;         %　5は閾値で調節可能
MM(MM~=0)=1;


GAZOU = New_keson;
MASK = Mask_TV;
Gpic = New_keson .* MM .* mask;

image_TV = inpaintTV(GAZOU,MASK);

figure 
imshow(image_TV)

%2回目

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

















