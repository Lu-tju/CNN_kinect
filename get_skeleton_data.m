%% 获取骨架图片，用于训练
%% 预设
imaqhwinfo
colorVid = videoinput('kinect',1);
depthVid = videoinput('kinect',2);
triggerconfig(depthVid,'manual');
triggerconfig(colorVid,'manual');
depthVid.FramesPerTrigger = 1;
depthVid.TriggerRepeat = inf;
set(getselectedsource(depthVid),'EnableBodyTracking','on');
j=0 %定义采集起始文件名
%% 采集(开始一次后每次只需要运行节）
%start(depthVid);%开始和停止手动操作
figure;
for i=1:4
    trigger(depthVid);
    [depthMap,~,depthMetadata] = getdata(depthVid);
    imshow(depthMap,[0 4096]);
end
%stop(depthVid);
%绘制
skeletonJoints = depthMetadata.DepthJointIndices(:,:,depthMetadata.IsBodyTracked);
image = imread('E:\pic\white.jpg');
image=imresize(image,[400, 500]);
%位置确保胸在中间
a = skeletonJoints(2,1);
b = skeletonJoints(1,2);
a = a-250;
b = b-220;
skeletonJoints = skeletonJoints - [a,b];
%画图
skeletonViewer2(skeletonJoints,image,1)
%存储
I = getframe(gcf);
img = I.cdata;%I.cdata是图片吗？修改大小227*227？
img = imresize(img,[227,227]);
imwrite(img,['E:\pic\data\',int2str(j),'.jpg']);
pause(1);%停顿预览
close;
j=j+1;