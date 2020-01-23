function outputArg1 = exemplar(GZ,MK,Gpic)
%EXEMPLAR この関数の概要をここに記述
%   詳細説明をここに記述

image = double(GZ); %オリジナル画像読み込み


[row,column] = size(image(:,:,1)); %オリジナル画像のサイズ
%===============maskの生成==================================================
mask = double(MK);

image_lucked = image.*mask; %欠損させた画像

b=2; %周囲b画素分
r1=rem(column,b);
r2=rem(row,b);

%Cmn&Dmnの作成
Cmn = not(logical(image_lucked(:,:,1))); %欠損領域なら1、非欠損領域なら0
Dmn = logical(image_lucked(:,:,1));      %非欠損領域なら1、欠損領域なら0

%=====================画像修復==============================================

if r1==0 && r2==0
for m=row-b+1:-b:1
    for n=column-b+1:-b:1
        
        %(m,n)から(m+b,n+b)に欠損領域があるか調べる
        c_m_n_count=0; %c_m_n_countを0にリセット
        for c_m_n_i=0:b-1
            for c_m_n_j=0:b-1
                if Cmn(m+c_m_n_i,n+c_m_n_j)==1 %欠損があればc_m_n_count=1にする
                    c_m_n_count=1;
                    break; %欠損が一つでも見つかればfor文から抜ける
                end
            end
            if c_m_n_count==1 %欠損が一つでも見つかればfor文から抜ける 
                break;
            end
        end
        
        if c_m_n_count==1 %修復領域に欠損領域があれば画像修復を行う
            g_m_n_best=Inf; %g(m,n)の初期値設定
            k_best = 1;     %k_bestの初期値設定
            l_best = 1;     %l_bestの初期値設定
            for k=1:row-b+1 %全パッチ(b*b)と順に比較する
                for l=1:column-b+1
                    
                    if Gpic(k,l) ~= 0
                    
                    k_l_count=0; %パッチの全要素が非欠損領域に属しているか調べる
                    for k_l_i=0:b-1
                        for k_l_j=0:b-1
                            if Cmn(k+k_l_i,l+k_l_j)==1
                                k_l_count=1;
                                break; %欠損領域を一つでも有していればfor文から抜ける
                            end
                        end
                        if k_l_count==1
                            break; %欠損領域を一つでも有していればfor文から抜ける
                        end
                    end
                    if k_l_count==0 %欠損領域を有していなければ比較を行う
                        g_m_n = 0; %g_m_nの初期値を設定
                        for i=0:b-1 %嶋田さんの式(10)(12)
                            for j=0:b-1
                                for RGBLOOP=1:3
                                    %==================例外処理①(画像の左上)========================================================================
                                    if m==1 && n==1
                                        g_m_n = g_m_n + (Cmn(m+i,n+j)*Dmn(m+1+i,n+j)*(image_lucked(k+i,l+j,RGBLOOP)-image_lucked(m+1+i,n+j,RGBLOOP))^2);
                                        g_m_n = g_m_n + (Cmn(m+i,n+j)*Dmn(m+i,n+1+j)*(image_lucked(k+i,l+j,RGBLOOP)-image_lucked(m+i,n+1+j,RGBLOOP))^2);
                                    %==================例外処理②(画像の上)==========================================================================
                                    elseif m==1 && n~=1 && n~=column-b+1
                                        g_m_n = g_m_n + (Cmn(m+i,n+j)*Dmn(m+1+i,n+j)*(image_lucked(k+i,l+j,RGBLOOP)-image_lucked(m+1+i,n+j,RGBLOOP))^2);
                                        g_m_n = g_m_n + (Cmn(m+i,n+j)*Dmn(m+i,n-1+j)*(image_lucked(k+i,l+j,RGBLOOP)-image_lucked(m+i,n-1+j,RGBLOOP))^2);
                                        g_m_n = g_m_n + (Cmn(m+i,n+j)*Dmn(m+i,n+1+j)*(image_lucked(k+i,l+j,RGBLOOP)-image_lucked(m+i,n+1+j,RGBLOOP))^2);
                                    %==================例外処理③(画像の右上)========================================================================
                                    elseif m==1 && n==column-b+1
                                        g_m_n = g_m_n + (Cmn(m+i,n+j)*Dmn(m+1+i,n+j)*(image_lucked(k+i,l+j,RGBLOOP)-image_lucked(m+1+i,n+j,RGBLOOP))^2);
                                        g_m_n = g_m_n + (Cmn(m+i,n+j)*Dmn(m+i,n-1+j)*(image_lucked(k+i,l+j,RGBLOOP)-image_lucked(m+i,n-1+j,RGBLOOP))^2);
                                    %==================例外処理④(画像の左)==========================================================================
                                    elseif m~=1 && m~=row-b+1 && n==1
                                        g_m_n = g_m_n + (Cmn(m+i,n+j)*Dmn(m-1+i,n+j)*(image_lucked(k+i,l+j,RGBLOOP)-image_lucked(m-1+i,n+j,RGBLOOP))^2);
                                        g_m_n = g_m_n + (Cmn(m+i,n+j)*Dmn(m+1+i,n+j)*(image_lucked(k+i,l+j,RGBLOOP)-image_lucked(m+1+i,n+j,RGBLOOP))^2);
                                        g_m_n = g_m_n + (Cmn(m+i,n+j)*Dmn(m+i,n+1+j)*(image_lucked(k+i,l+j,RGBLOOP)-image_lucked(m+i,n+1+j,RGBLOOP))^2);
                                    %==================例外処理⑤(画像の左下)========================================================================
                                    elseif m==row-b+1 && n==1
                                        g_m_n = g_m_n + (Cmn(m+i,n+j)*Dmn(m-1+i,n+j)*(image_lucked(k+i,l+j,RGBLOOP)-image_lucked(m-1+i,n+j,RGBLOOP))^2);
                                        g_m_n = g_m_n + (Cmn(m+i,n+j)*Dmn(m+i,n+1+j)*(image_lucked(k+i,l+j,RGBLOOP)-image_lucked(m+i,n+1+j,RGBLOOP))^2);
                                    %==================例外処理⑥(画像の右)==========================================================================
                                    elseif m~=1 && m~=row-b+1 && n==column-b+1
                                        g_m_n = g_m_n + (Cmn(m+i,n+j)*Dmn(m-1+i,n+j)*(image_lucked(k+i,l+j,RGBLOOP)-image_lucked(m-1+i,n+j,RGBLOOP))^2);
                                        g_m_n = g_m_n + (Cmn(m+i,n+j)*Dmn(m+1+i,n+j)*(image_lucked(k+i,l+j,RGBLOOP)-image_lucked(m+1+i,n+j,RGBLOOP))^2);
                                        g_m_n = g_m_n + (Cmn(m+i,n+j)*Dmn(m+i,n-1+j)*(image_lucked(k+i,l+j,RGBLOOP)-image_lucked(m+i,n-1+j,RGBLOOP))^2);
                                    %==================例外処理⑦(画像の右下)========================================================================
                                    elseif m==row-b+1 && n==column-b+1
                                        g_m_n = g_m_n + (Cmn(m+i,n+j)*Dmn(m-1+i,n+j)*(image_lucked(k+i,l+j,RGBLOOP)-image_lucked(m-1+i,n+j,RGBLOOP))^2);
                                        g_m_n = g_m_n + (Cmn(m+i,n+j)*Dmn(m+i,n-1+j)*(image_lucked(k+i,l+j,RGBLOOP)-image_lucked(m+i,n-1+j,RGBLOOP))^2);
                                    %==================例外処理⑧(画像の下)==========================================================================
                                    elseif m==row-b+1 && n~=1 && n~= column-b+1
                                        g_m_n = g_m_n + (Cmn(m+i,n+j)*Dmn(m-1+i,n+j)*(image_lucked(k+i,l+j,RGBLOOP)-image_lucked(m-1+i,n+j,RGBLOOP))^2);
                                        g_m_n = g_m_n + (Cmn(m+i,n+j)*Dmn(m+i,n-1+j)*(image_lucked(k+i,l+j,RGBLOOP)-image_lucked(m+i,n-1+j,RGBLOOP))^2);
                                        g_m_n = g_m_n + (Cmn(m+i,n+j)*Dmn(m+i,n+1+j)*(image_lucked(k+i,l+j,RGBLOOP)-image_lucked(m+i,n+1+j,RGBLOOP))^2);
                                    %==================画像の端以外==================================================================================
                                    else
                                        g_m_n = g_m_n + (Cmn(m+i,n+j)*Dmn(m-1+i,n+j)*(image_lucked(k+i,l+j,RGBLOOP)-image_lucked(m-1+i,n+j,RGBLOOP))^2);
                                        g_m_n = g_m_n + (Cmn(m+i,n+j)*Dmn(m+1+i,n+j)*(image_lucked(k+i,l+j,RGBLOOP)-image_lucked(m+1+i,n+j,RGBLOOP))^2);
                                        g_m_n = g_m_n + (Cmn(m+i,n+j)*Dmn(m+i,n-1+j)*(image_lucked(k+i,l+j,RGBLOOP)-image_lucked(m+i,n-1+j,RGBLOOP))^2);
                                        g_m_n = g_m_n + (Cmn(m+i,n+j)*Dmn(m+i,n+1+j)*(image_lucked(k+i,l+j,RGBLOOP)-image_lucked(m+i,n+1+j,RGBLOOP))^2);
                                    end
                                end
                            end
                        end
                        if g_m_n < g_m_n_best %g_m_n_bestより小さい値になれば更新する
                            g_m_n_best=g_m_n;
                            k_best=k; 
                            l_best=l; %小さい値が入っている座標(パッチの左上)を記録
                        end
                    end
                    end
                end
            end
%===========最良のパッチを、修復領域に当てはめる=====================================================================
            for rep_i=0:b-1
                 for rep_j=0:b-1
                     if Cmn(m+rep_i,n+rep_j)==1 && Cmn(k_best+rep_i,l_best+rep_j)==0
                         for RGBLOOP=1:3
                             image_lucked(m+rep_i,n+rep_j,RGBLOOP)=image_lucked(k_best+rep_i,l_best+rep_j,RGBLOOP);
                         end
                         Cmn(m+rep_i,n+rep_j)=0; %修復したCの要素を0にする
                         Dmn(m+rep_i,n+rep_j)=1; %修復したDの要素を1にする
                     end
                 end
             end
         end
        
    end
end






image_repaired = image_lucked;

outputArg1  = uint8(image_repaired);


end

