function [Vfinal] = main(learning_rule,sizes,custom_load,updatepara,inputpara,learning_rate)

%main('oja', 28, ["./images/img_1.jpg", "./images/img_2.jpg", "./images/img_3.jpg"], [10, 2], 20, 0.1)
%main('oja', 28, ["./images/img_2.jpg","./images/img_1.jpg","./images/img_3.jpg","./images/img_4.jpg","./images/img_5.jpg",
%"./images/img_6.jpg","./images/img_7.jpg","./images/img_8.jpg","./images/img_9.jpg","./images/img_10.jpg"], [10, 2], 20 , 0.1)


%parameter definitions.
% learning rule = 'hebbian' (outer product), 'oja'
% 10 = number of patterns to store, the routine customize load decides the
% sequence and collection of the images to store.
% updatepara = [x,y] x = number of iterations, y= number of checkpoints to print out intermediate result
% inputpara = noise point wants to add for corrupt 
% or parameters for partial_image function [p,x,y] p = size of the patch visible, 
% (x, y) is the upper left corner coordinate of the visible patch by default, we run corrupt function,if want to run 
% partial_image function, go comment the corrupt one uncommant the nextline and change the command line as below
%  main('oja', 28, ["./images/img_1.jpg", "./images/img_2.jpg", "./images/img_3.jpg"], [10, 2], [20,5,5], 0.1)

num_iterations=updatepara(1);
checkpoint_number=updatepara(2);
numNeurons = sizes*sizes;
numPatterns = length(custom_load);
%load mypattern.mat
mypatterns = zeros(sizes*sizes,1,numPatterns);
for i =1:numPatterns
    mypatterns(:,:,i)=load_image_by_name(custom_load(i),sizes);
end

colormap gray;
for i=1:numPatterns
    subplot(1,numPatterns,i);
    imagesc(reshape(mypatterns(:,:,i),sizes,sizes));
end
fhi = figure();
colormap gray;
T = zeros(numNeurons);
disp(learning_rule);
if strcmp(learning_rule,'hebbian')
    for alpha=1:numPatterns
        data = reshape(mypatterns(:, :, alpha),1,numNeurons);
        T = T + data'*data;
    end
    T = T./numPatterns;   % this normalized by the number of patterns.

elseif strcmp(learning_rule,'oja')
    T=ones(numNeurons);
    T = T./numNeurons;    
    learning_rate=(0.7/numNeurons)*learning_rate;
    for iter = 1:numPatterns
        for epoch = 1:100
            xcur = mypatterns(:,:,1:iter);
            xcur = reshape(xcur,sizes*sizes,iter);
            ycur = xcur'*T';
            deltaT = learning_rate*(xcur - T*ycur')*ycur;
            T=T+deltaT;
        end
    end
end

imagesc(T);
fhi = figure();
colormap gray;


for i = 1 : numPatterns
    Vss =corrupt(mypatterns(:,:,i),inputpara);
    %Vss =partial_image(mypatterns(:,:,i),inputpara(1),inputpara(2),inputpara(3));
    imagesc(reshape(Vss,sizes,sizes));
    fhi=figure();
    colormap gray;
    Vfinal = runHopnet(T,num_iterations,checkpoint_number,Vss,"all");
    %subplot(1,numPatterns,i);
    fhi = figure();
    colormap gray;
    imagesc(reshape(Vfinal,sizes,sizes));
end

end
