% 深度图像获取，描骨骼点
%% 预设
colorVid = videoinput('kinect',1);
depthVid = videoinput('kinect',2);
triggerconfig(depthVid,'manual');
triggerconfig(colorVid,'manual');
depthVid.FramesPerTrigger = 1;
depthVid.TriggerRepeat = inf;
set(getselectedsource(depthVid),'EnableBodyTracking','on')%kinect v2和v1不同！
%% 触发得到10帧并取最后一帧
start(depthVid);figure;
for i=1:10
    trigger(depthVid);
    [depthMap,~,depthMetadata] = getdata(depthVid);%~意为忽略输出参数
    imshow(depthMap,[0 4096]);
end
stop(depthVid);
%% 绘制骨架图片
skeletonJoints = depthMetadata.DepthJointIndices(:,:,depthMetadata.IsBodyTracked);
imshow(depthMap,[0 4096]);
hold on;plot(skeletonJoints(:,1),skeletonJoints(:,2),'*');