%% 识别动作，视频输出，骨架线画在RGB图上
% close all；
imaqhwinfo
colorVid = videoinput('kinect',1);
depthVid = videoinput('kinect',2);
triggerconfig(depthVid,'manual');
triggerconfig(colorVid,'manual');
depthVid.FramesPerTrigger = 1;
depthVid.TriggerRepeat = inf;
set(getselectedsource(depthVid),'EnableBodyTracking','on')
colorVid.FramesPerTrigger = 1;
colorVid.TriggerRepeat = inf;

nnet = skeletonnet%载入训练好的网络
start(depthVid);
start(colorVid);
image2 = 255.*ones(1080,1920,3,'uint8');

himg = figure(2);
while ishandle(himg)
    trigger(colorVid);
    trigger(depthVid);
    image = getdata(colorVid);
    [depthMap,~,depthMetadata] = getdata(depthVid);
    
    if sum(depthMetadata.IsBodyTracked) > 0
        trackedSkeletons = find(depthMetadata.IsBodyTracked);
        skeletonJoints = depthMetadata.ColorJointIndices(:, :, trackedSkeletons);
        fh = figure(1);
        set(fh,'Visible','off');
        skeletonViewer2(skeletonJoints,image2,1);
        
        I = getframe(gcf);
        pic = I.cdata;
        picture = imresize(pic,[227,227]);
        label = classify(nnet, picture);
        close
        
        fl = figure(2);
        set(fl,'Visible','on');
        skeletonViewer2(skeletonJoints,image,1);
        title(char(label)); 
        drawnow; 
    else
        imshow(image);
    end
end
stop(colorVid);
stop(depthVid);