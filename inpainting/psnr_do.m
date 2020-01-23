

PR= dir([ps,'*ps.jpg*']);
ps_mask = imread([ps,PR.name]);
ps_mask = reSZ(ps_mask);

ps_mask(ps_mask ==255) =1;

deep_ps = psnr(or_d .* ps_mask, orgl .* ps_mask);

super_ps = psnr(Last_result .* ps_mask, orgl .* ps_mask);


psnr_table = table(deep_ps,super_ps);

psnr_table


