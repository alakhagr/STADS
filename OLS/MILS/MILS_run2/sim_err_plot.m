c = [];
d = [];
e = [];
f = [];
g = [];
img_no = [];
for i=1:100
    a = load(['../MILS_run2/Output/MILS_iter_' num2str(i) '.mat']);
    b = a.sim_err;
    d = [d height(a.sm_output.Verified)];
    f = [f height(a.sm_output.Matched)];
    e = [e height(a.sm_output.bi)];
    c = [c;b];
    g = [g a.es_output.q_bi]; 
    img_no = [img_no ;i];
end
% subplot(4,1,1);
c(37,4) = 0;
c(39,4) = 0;
h = zeros(2,1);
figure
h(1) = plot(c(:,4));

hold on 
h(2) = plot([37;39],[0;0], 'rp', 'MarkerFaceColor','g','DisplayName','Faulty Cases');
% plot(39,0, 'rp', 'MarkerFaceColor','g');
hold off

title("Attitude Error (arcseconds)");
xlabel("Image Number");
ylabel("Attitude Error (arcseconds)");
legend(h(2));

figure
histogram(c(:,4),27);
title('Histogram of attitude error (arcseconds)');
xlabel('Attitude error (arcseconds)');
ylabel('Number of images');

% subplot(4,1,2);
% plot(f);
% title("Stars after SM (before verification)");
% 
% subplot(4,1,3);
% plot(d);
% title("Stars after SM");
% 
% subplot(4,1,4);
% plot(e);
% title("Stars after RGA");

idx = c(:,4) > 150;
g_smart = transpose(g);
disp(g_smart(idx,:));
% disp(length(g_smart(idx,:)));
% disp(img_no(idx,:));
% Image 37 has only 1 star as output of SM and es_output unnormalised - eliminate
% Image 33 has error 132 only, its not blowing up. 
% Hypothesis: The rest 9 images have false matches out of verification step

corrupt_img = img_no(idx,:);
for i=1:size(corrupt_img)
    a = load(['../Simulation_4/Output/MILS_iter_' num2str(corrupt_img(i)) '.mat']);
    b = load(['../SIS_run13_6.5/Output/SIS_iter_' num2str(corrupt_img(i)) '.mat']);
    verified = a.sm_output.Verified.SSP_ID;
    original_stars = b.sis_output.data_table.SSP_ID;
%     disp([verified,intersect(verified,original_stars)]);
    if length(intersect(verified,original_stars))==length(verified)
        disp([corrupt_img(i) "yay!"])
    else
        disp([corrupt_img(i) "fuck" length(verified)-length(intersect(verified,original_stars)) c(corrupt_img(i),4)])
    end
end

    
    