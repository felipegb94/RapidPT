Ut = UHat';

tic;
for i=1:100
    inds = randperm(V,subV)';
    U_inds = UHat(inds,:);
end
toc;


tic;
for i=1:100
    inds = randperm(V,subV)';
    U_inds = Ut(:,inds);
end
toc;

x = 1;
