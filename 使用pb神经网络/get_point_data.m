%采集并存储骨骼数据列向量，直接用于训练net
colorVid = videoinput('kinect',1);
depthVid = videoinput('kinect',2);
triggerconfig(depthVid,'manual');
triggerconfig(colorVid,'manual');
depthVid.FramesPerTrigger = 1;
depthVid.TriggerRepeat = inf;
set(getselectedsource(depthVid),'EnableBodyTracking','on')%v2
start(depthVid);
% data=zeros(26,200);
%% 每类动作采集50个，放在data中
i=1;%每次改一下1-50，51-100...
while i<51
    trigger(depthVid);
    [~,~,depthMetadata] = getdata(depthVid);
    if sum(depthMetadata.IsBodyTracked) > 0
        skeletonJoints = depthMetadata.DepthJointIndices(:,:,depthMetadata.IsBodyTracked);
        sj=skeletonJoints([1 2 4 5 6 8 9 10 12 14 15 18 19],:);%剪取需要的数据
        sj=my_normalization(sj);%归一化
        data(1:13,i)=sj(:,1);
        data(14:26,i)=sj(:,2);
        i=i+1
    end
end
%% 采集完成后停机
stop(depthVid);
%% 打标签
lebal=zeros(4,200);
for j=0:3
    for i=1+50*j:50+50*j
        lebal(j+1,i)=1;
    end
end
