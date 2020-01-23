function outputArg1 = exemplar(GZ,MK,Gpic)
%EXEMPLAR ���̊֐��̊T�v�������ɋL�q
%   �ڍא����������ɋL�q

image = double(GZ); %�I���W�i���摜�ǂݍ���


[row,column] = size(image(:,:,1)); %�I���W�i���摜�̃T�C�Y
%===============mask�̐���==================================================
mask = double(MK);

image_lucked = image.*mask; %�����������摜

b=2; %����b��f��
r1=rem(column,b);
r2=rem(row,b);

%Cmn&Dmn�̍쐬
Cmn = not(logical(image_lucked(:,:,1))); %�����̈�Ȃ�1�A�񌇑��̈�Ȃ�0
Dmn = logical(image_lucked(:,:,1));      %�񌇑��̈�Ȃ�1�A�����̈�Ȃ�0

%=====================�摜�C��==============================================

if r1==0 && r2==0
for m=row-b+1:-b:1
    for n=column-b+1:-b:1
        
        %(m,n)����(m+b,n+b)�Ɍ����̈悪���邩���ׂ�
        c_m_n_count=0; %c_m_n_count��0�Ƀ��Z�b�g
        for c_m_n_i=0:b-1
            for c_m_n_j=0:b-1
                if Cmn(m+c_m_n_i,n+c_m_n_j)==1 %�����������c_m_n_count=1�ɂ���
                    c_m_n_count=1;
                    break; %��������ł��������for�����甲����
                end
            end
            if c_m_n_count==1 %��������ł��������for�����甲���� 
                break;
            end
        end
        
        if c_m_n_count==1 %�C���̈�Ɍ����̈悪����Ή摜�C�����s��
            g_m_n_best=Inf; %g(m,n)�̏����l�ݒ�
            k_best = 1;     %k_best�̏����l�ݒ�
            l_best = 1;     %l_best�̏����l�ݒ�
            for k=1:row-b+1 %�S�p�b�`(b*b)�Ə��ɔ�r����
                for l=1:column-b+1
                    
                    if Gpic(k,l) ~= 0
                    
                    k_l_count=0; %�p�b�`�̑S�v�f���񌇑��̈�ɑ����Ă��邩���ׂ�
                    for k_l_i=0:b-1
                        for k_l_j=0:b-1
                            if Cmn(k+k_l_i,l+k_l_j)==1
                                k_l_count=1;
                                break; %�����̈����ł��L���Ă����for�����甲����
                            end
                        end
                        if k_l_count==1
                            break; %�����̈����ł��L���Ă����for�����甲����
                        end
                    end
                    if k_l_count==0 %�����̈��L���Ă��Ȃ���Δ�r���s��
                        g_m_n = 0; %g_m_n�̏����l��ݒ�
                        for i=0:b-1 %���c����̎�(10)(12)
                            for j=0:b-1
                                for RGBLOOP=1:3
                                    %==================��O�����@(�摜�̍���)========================================================================
                                    if m==1 && n==1
                                        g_m_n = g_m_n + (Cmn(m+i,n+j)*Dmn(m+1+i,n+j)*(image_lucked(k+i,l+j,RGBLOOP)-image_lucked(m+1+i,n+j,RGBLOOP))^2);
                                        g_m_n = g_m_n + (Cmn(m+i,n+j)*Dmn(m+i,n+1+j)*(image_lucked(k+i,l+j,RGBLOOP)-image_lucked(m+i,n+1+j,RGBLOOP))^2);
                                    %==================��O�����A(�摜�̏�)==========================================================================
                                    elseif m==1 && n~=1 && n~=column-b+1
                                        g_m_n = g_m_n + (Cmn(m+i,n+j)*Dmn(m+1+i,n+j)*(image_lucked(k+i,l+j,RGBLOOP)-image_lucked(m+1+i,n+j,RGBLOOP))^2);
                                        g_m_n = g_m_n + (Cmn(m+i,n+j)*Dmn(m+i,n-1+j)*(image_lucked(k+i,l+j,RGBLOOP)-image_lucked(m+i,n-1+j,RGBLOOP))^2);
                                        g_m_n = g_m_n + (Cmn(m+i,n+j)*Dmn(m+i,n+1+j)*(image_lucked(k+i,l+j,RGBLOOP)-image_lucked(m+i,n+1+j,RGBLOOP))^2);
                                    %==================��O�����B(�摜�̉E��)========================================================================
                                    elseif m==1 && n==column-b+1
                                        g_m_n = g_m_n + (Cmn(m+i,n+j)*Dmn(m+1+i,n+j)*(image_lucked(k+i,l+j,RGBLOOP)-image_lucked(m+1+i,n+j,RGBLOOP))^2);
                                        g_m_n = g_m_n + (Cmn(m+i,n+j)*Dmn(m+i,n-1+j)*(image_lucked(k+i,l+j,RGBLOOP)-image_lucked(m+i,n-1+j,RGBLOOP))^2);
                                    %==================��O�����C(�摜�̍�)==========================================================================
                                    elseif m~=1 && m~=row-b+1 && n==1
                                        g_m_n = g_m_n + (Cmn(m+i,n+j)*Dmn(m-1+i,n+j)*(image_lucked(k+i,l+j,RGBLOOP)-image_lucked(m-1+i,n+j,RGBLOOP))^2);
                                        g_m_n = g_m_n + (Cmn(m+i,n+j)*Dmn(m+1+i,n+j)*(image_lucked(k+i,l+j,RGBLOOP)-image_lucked(m+1+i,n+j,RGBLOOP))^2);
                                        g_m_n = g_m_n + (Cmn(m+i,n+j)*Dmn(m+i,n+1+j)*(image_lucked(k+i,l+j,RGBLOOP)-image_lucked(m+i,n+1+j,RGBLOOP))^2);
                                    %==================��O�����D(�摜�̍���)========================================================================
                                    elseif m==row-b+1 && n==1
                                        g_m_n = g_m_n + (Cmn(m+i,n+j)*Dmn(m-1+i,n+j)*(image_lucked(k+i,l+j,RGBLOOP)-image_lucked(m-1+i,n+j,RGBLOOP))^2);
                                        g_m_n = g_m_n + (Cmn(m+i,n+j)*Dmn(m+i,n+1+j)*(image_lucked(k+i,l+j,RGBLOOP)-image_lucked(m+i,n+1+j,RGBLOOP))^2);
                                    %==================��O�����E(�摜�̉E)==========================================================================
                                    elseif m~=1 && m~=row-b+1 && n==column-b+1
                                        g_m_n = g_m_n + (Cmn(m+i,n+j)*Dmn(m-1+i,n+j)*(image_lucked(k+i,l+j,RGBLOOP)-image_lucked(m-1+i,n+j,RGBLOOP))^2);
                                        g_m_n = g_m_n + (Cmn(m+i,n+j)*Dmn(m+1+i,n+j)*(image_lucked(k+i,l+j,RGBLOOP)-image_lucked(m+1+i,n+j,RGBLOOP))^2);
                                        g_m_n = g_m_n + (Cmn(m+i,n+j)*Dmn(m+i,n-1+j)*(image_lucked(k+i,l+j,RGBLOOP)-image_lucked(m+i,n-1+j,RGBLOOP))^2);
                                    %==================��O�����F(�摜�̉E��)========================================================================
                                    elseif m==row-b+1 && n==column-b+1
                                        g_m_n = g_m_n + (Cmn(m+i,n+j)*Dmn(m-1+i,n+j)*(image_lucked(k+i,l+j,RGBLOOP)-image_lucked(m-1+i,n+j,RGBLOOP))^2);
                                        g_m_n = g_m_n + (Cmn(m+i,n+j)*Dmn(m+i,n-1+j)*(image_lucked(k+i,l+j,RGBLOOP)-image_lucked(m+i,n-1+j,RGBLOOP))^2);
                                    %==================��O�����G(�摜�̉�)==========================================================================
                                    elseif m==row-b+1 && n~=1 && n~= column-b+1
                                        g_m_n = g_m_n + (Cmn(m+i,n+j)*Dmn(m-1+i,n+j)*(image_lucked(k+i,l+j,RGBLOOP)-image_lucked(m-1+i,n+j,RGBLOOP))^2);
                                        g_m_n = g_m_n + (Cmn(m+i,n+j)*Dmn(m+i,n-1+j)*(image_lucked(k+i,l+j,RGBLOOP)-image_lucked(m+i,n-1+j,RGBLOOP))^2);
                                        g_m_n = g_m_n + (Cmn(m+i,n+j)*Dmn(m+i,n+1+j)*(image_lucked(k+i,l+j,RGBLOOP)-image_lucked(m+i,n+1+j,RGBLOOP))^2);
                                    %==================�摜�̒[�ȊO==================================================================================
                                    else
                                        g_m_n = g_m_n + (Cmn(m+i,n+j)*Dmn(m-1+i,n+j)*(image_lucked(k+i,l+j,RGBLOOP)-image_lucked(m-1+i,n+j,RGBLOOP))^2);
                                        g_m_n = g_m_n + (Cmn(m+i,n+j)*Dmn(m+1+i,n+j)*(image_lucked(k+i,l+j,RGBLOOP)-image_lucked(m+1+i,n+j,RGBLOOP))^2);
                                        g_m_n = g_m_n + (Cmn(m+i,n+j)*Dmn(m+i,n-1+j)*(image_lucked(k+i,l+j,RGBLOOP)-image_lucked(m+i,n-1+j,RGBLOOP))^2);
                                        g_m_n = g_m_n + (Cmn(m+i,n+j)*Dmn(m+i,n+1+j)*(image_lucked(k+i,l+j,RGBLOOP)-image_lucked(m+i,n+1+j,RGBLOOP))^2);
                                    end
                                end
                            end
                        end
                        if g_m_n < g_m_n_best %g_m_n_best��菬�����l�ɂȂ�΍X�V����
                            g_m_n_best=g_m_n;
                            k_best=k; 
                            l_best=l; %�������l�������Ă�����W(�p�b�`�̍���)���L�^
                        end
                    end
                    end
                end
            end
%===========�ŗǂ̃p�b�`���A�C���̈�ɓ��Ă͂߂�=====================================================================
            for rep_i=0:b-1
                 for rep_j=0:b-1
                     if Cmn(m+rep_i,n+rep_j)==1 && Cmn(k_best+rep_i,l_best+rep_j)==0
                         for RGBLOOP=1:3
                             image_lucked(m+rep_i,n+rep_j,RGBLOOP)=image_lucked(k_best+rep_i,l_best+rep_j,RGBLOOP);
                         end
                         Cmn(m+rep_i,n+rep_j)=0; %�C������C�̗v�f��0�ɂ���
                         Dmn(m+rep_i,n+rep_j)=1; %�C������D�̗v�f��1�ɂ���
                     end
                 end
             end
         end
        
    end
end






image_repaired = image_lucked;

outputArg1  = uint8(image_repaired);


end

