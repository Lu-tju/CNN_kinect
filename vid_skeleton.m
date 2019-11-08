%% 在RGB图像上绘制骨架线，视频输出
%% 预设
imaqhwinfo
colorVid = videoinput('kinect',1);
depthVid = videoinput('kinect',2);
triggerconfig(depthVid,'manual');
triggerconfig(colorVid,'manual');
depthVid.FramesPerTrigger = 1;
depthVid.TriggerRepeat = inf;
set(getselectedsource(depthVid),'EnableBodyTracking','on');
colorVid.FramesPerTrigger = 1;
colorVid.TriggerRepeat = inf;
%% 运行
start(depthVid);
start(colorVid);
himg = figure;
while ishandle(himg)
    trigger(colorVid);
    trigger(depthVid);
    image = getdata(colorVid);
    [depthMap,~,depthMetadata] = getdata(depthVid);   
    
    if sum(depthMetadata.IsBodyTracked) > 0
        trackedSkeletons = find(depthMetadata.IsBodyTracked);
        skeletonJoints = depthMetadata.ColorJointIndices(:, :, trackedSkeletons);
        skeletonViewer2(skeletonJoints,image,1);
    else
        imshow(image);
    end
end
stop(colorVid);
stop(depthVid);
