function image_Upsample = upsample(in_Image) 
size_Upsample = size(in_Image);

image_Upsample = in_Image;
for i=1:((size_Upsample(1,2))/2-1)
  image_Upsample(:,2*i,:) = (uint16(image_Upsample(:,((2*i)-1),:))+uint16(image_Upsample(:,((2*i)+1),:)))/2;
end
for i=1:((size_Upsample(1,1))/2-1)
  image_Upsample(2*i,:,:)=(uint16(image_Upsample(((2*i)-1),:,:))+uint16(image_Upsample(((2*i)+1),:,:)))/2;
end
image_Upsample(:,size_Upsample(1,2),:)=image_Upsample(:,size_Upsample(1,2)-1,:);
image_Upsample(size_Upsample(1,1),:,:)=image_Upsample(size_Upsample(1,1)-1,:,:);
