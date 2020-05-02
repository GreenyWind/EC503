function pattern = load_image_by_name(file_name,size)
        image=imread(file_name);
        disp(file_name);
        image=imresize(image,[size size]);
        n = graythresh(image);
        image=imbinarize(image,n);
        image = not(image);
%         fhi=figure();
%         colormap gray;
        imagesc(image);
        pattern=reshape(image,size*size,1);
        pattern=2*pattern-1;
end