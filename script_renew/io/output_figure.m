function Allobj = output_figure(out_dir_part, partition, prerpms, data_set, ...
		       sample, part_delta, part_tau, sample_here, Vehicle, Allobj)
  global CONFIG
  NumPrms = CONFIG.make_init_sample.numPrms;

  v1 = data_set(4, :);
  v0 = data_set(6, :);
  detv = v0 - v1;
  a1 = data_set(14, :);
  x1 = data_set(13, :);
  space = data_set(7, :);
  x0 = x1 + space;
  ss0 = part_delta;
  ss1 = part_tau;
  si = data_set(15, :);
  siu = data_set(16, :);
  t2lb = 1;
  TTime = length(v1);
  s = data_set(7,:)';

  %% Prob
  figure;
  subplot(NumPrms,1,1);
  xa = (1/partition(1))*(1:partition(1));
  bar(xa,sample{1});
  axis([0,1,0,max(sample{1})]);
  title('alpha1[1/s]');
  grid on

  subplot(NumPrms,1,2);
  xa = (0.5/partition(2))*(1:partition(2));
  bar(xa,sample{2});
  axis([0,0.5,0,max(sample{2})]);
  title('alpha2[1/s2]');
  grid on
  
  subplot(NumPrms,1,3);
  xa = (1/partition(3))*(1:partition(3));
  bar(xa,sample{3});
  axis([0,1,0,max(sample{3})]);
  title('alpha3');
  grid on
  
  subplot(NumPrms,1,4);
  xa = (1:partition(4));
  bar(xa,sample{4});
  axis([0,partition(4),0,max(sample{4})]);
  title('Reaction Time[(1/10)s]');
  grid on

  name = 'Prob';
  print('-dpng','-r300',strcat(out_dir_part,name));

  %% Obj
  prms = sample_here(1,2:NumPrms+1);
  s_sim = zeros(TTime,1);
  detv_sim = zeros(TTime,1);
  a1_sim = zeros(TTime,1);
  v1_sim = zeros(TTime,1);
  x1_sim = zeros(TTime,1);

  start = prms(4)+1;

  s_sim(1:start)=x0(1:start)-x1(1:start);
  detv_sim(1:start)=detv(1:start);
  a1_sim(1:start) = a1(1:start);
  v1_sim(1:start) = v1(1:start);
  x1_sim(1:start) = x1(1:start);

  for rr = start+1:TTime
    
    if rr >= 1
      a1_sim(rr) = prms(1)*detv_sim(rr-prms(4)) + ...
		   prms(2)*s_sim(rr-prms(4)) - ...
		   prms(2)*(ss1*v1_sim(rr-prms(4))+ss0)- ...
		   prms(3)*9.8*(si(rr)-siu(rr));
    else
      a1_sim(rr) = prms(1)*detv_sim(rr-prms(4)) + ...
		   prms(2)*s_sim(rr-prms(4)) - ...
		   prms(2)*(ss1*v1_sim(rr-prms(4))+ss0);
    end


				% 相対速度・車頭距離を計算
    v1_sim(rr) = v1_sim(rr-1) + a1_sim(rr-1)*(1/10);
    x1_sim(rr) = x1_sim(rr-1) + ((v1_sim(rr)+v1_sim(rr-1))/2)*(1/10);

    detv_sim(rr-1) = v0(rr-1) - v1_sim(rr-1);
    s_sim(rr) = x0(rr) - x1_sim(rr);
  end

  Allobj(Vehicle, 1) = sqrt(1/(TTime-start)*sum((s(start+1:TTime)-s_sim(start+1:TTime)).^(2)));
  Allobj(Vehicle, 2) = sqrt(1/(TTime-start)*sum((v1(start+1:TTime)'-v1_sim(start+1:TTime)).^(2)));
  Allobj(Vehicle, 3) = sqrt(1/(TTime-start)*sum((a1(start+1:TTime)'-a1_sim(start+1:TTime)).^(2)));
  Allobj(Vehicle, 4) = sqrt(1/(TTime-start)*sum((detv(start+1:TTime)'-detv_sim(start+1:TTime)).^(2)));

  figure
  bar(Allobj(Vehicle,:),'y')
  name = 'Obj';
  print('-dpng','-r300',strcat(out_dir_part, name));

  %% Trajectry
  figure;
  %% 先行車
  plot(x0(start:TTime),'b');
  hold on
  %% 当該車（実データ）
  plot(x1(start:TTime),'b');
  hold on
  plot(x1_sim(start:TTime),'r');
  grid on

  name = 'Trajectry';
  print('-dpng','-r300',strcat(out_dir_part, name));

  figure;
  %% subplot(2,2,1); bar(a1_sim_data,'stacked'); colormap(cool) 
  %% hold on
  subplot(2,2,1);
  plot((start+1:TTime)',a1(start+1:TTime),'b',(start+1:TTime)',a1_sim(start+1:TTime),'r');
  title('Acceleration [m/s2]');
  grid on
  
  subplot(2,2,2);
  plot((start+1:TTime)',v1(start+1:TTime),'b',(start+1:TTime)',v1_sim(start+1:TTime),'r');
  title('Velocity [m/s]');
  grid on

  subplot(2,2,3);
  plot((start+1:TTime)',detv(start+1:TTime),'b',(start+1:TTime)',detv_sim(start+1:TTime),'r');
  title('Relative Velocity [m/s]');
  grid on

  subplot(2,2,4);
  plot((start+1:TTime)',s(start+1:TTime),'b',(start+1:TTime)',s_sim(start+1:TTime),'r');
  title('Spacing [m]');
  grid on

  name = 'avrs';
  no = num2str(Vehicle);
  print('-dpng','-r300',strcat(out_dir_part,name));

  figure;
  scatter(s(start:TTime),detv(start:TTime))
  hold on
  scatter(s_sim(start:TTime),detv_sim(start:TTime))
  name = 'Hysteresis';
  print('-dpng','-r300',strcat(out_dir_part,name));

  %% time series composition of estimation
  %errblk=zeros((TTime-start),1);
  %errpos=errblk;
  %errneg=errblk;
  errorx=a1(start+1:TTime)'-a1_sim(start+1:TTime);
  detvsimblk=zeros((TTime-start),1);
  detvsimp=detvsimblk;
  detvsimn=detvsimblk;
  detvsimx=detv_sim(start+1-sample_here(1,5):TTime-sample_here(1,5));
  parttwoblk=zeros((TTime-start),1);
  parttwop=parttwoblk;
  parttwon=parttwoblk;
  parttwox=(s_sim(start+1-sample_here(1,5):TTime-sample_here(1,5))-ss1*v1_sim(start+1-sample_here(1,5):TTime-sample_here(1,5))-ss0);
  for ijjj=1:length(detvsimx)    
				%    if errorx(ijjj)>0
				%        errpos(ijjj)=errorx(ijjj);
				%    else
				%        errneg(ijjj)=errorx(ijjj);
				%    end
    if detvsimx(ijjj)>0
      detvsimp(ijjj)=detvsimx(ijjj);
    else
      detvsimn(ijjj)=detvsimx(ijjj);
    end
    if parttwox(ijjj)>0
      parttwop(ijjj)=parttwox(ijjj);
    else
      parttwon(ijjj)=parttwox(ijjj);
    end
  end
  estmedp=[detvsimp.*sample_here(1,2) parttwop.*sample_here(1,3)];
  sagfec=-sample_here(1,4).*9.8.*(si(start+1-sample_here(1,5):TTime-sample_here(1,5))-siu(start+1-sample_here(1,5):TTime-sample_here(1,5)));
  %% size(detvsimn.*sample_here(1,2))
  %% size(parttwon.*sample_here(1,3))
  %% size(sagfec)
  estmedn=[detvsimn.*sample_here(1,2) parttwon.*sample_here(1,3) sagfec'];
  figure;
  bar(estmedp, 0.5,'stacked','EdgeColor','none');
  xlabel('Time (s)');
  ylabel('Acceleration (m/s2)');
  hold all;
  bar(estmedn, 0.5,'stacked','EdgeColor','none');
  plot(errorx, '--k');
  plot(a1(start+1:TTime),'c','LineWidth',2);
  plot(a1_sim(start+1:TTime),'r','LineWidth',2);
  legend('Speed difference(+)', 'Spacing(+)','Speed difference(-)', 'Spacing(-)', 'Sag effect','Error','Acceleration (Real)','Acceleration (estimated)');
  name = 'Comp';
  print('-dpng','-r300',strcat(out_dir_part,name));

  %% S-V diagram

  figure;
  plot([0;v1(start+1:TTime)'],[0;s(start+1:TTime)],[0;v1_sim(start+1:TTime)],[0;s_sim(start+1:TTime)]);
  xlabel('Speed (m/s)');
  ylabel('Spacing (m)');
  xlim([0 40]);
  ylim([0 120]);
  legend('Real situation','Estimated');
  name = 'svdia';
  print('-dpng','-r300',strcat(out_dir_part,name));

  
  %% Local stability

  inispd=28;
  syst=zeros(1000,1);
  dis0=zeros(1000,1);
  accle0=zeros(1000,1);
  accle0(151:250)=-1;
  accle0(251:350)=1;
  spdv0=zeros(1000,1);
  accle1=zeros(1000,1);
  spdv1=zeros(1000,1);
  dis1=zeros(1000,1);
  accle2=zeros(1000,1);
  spdv2=zeros(1000,1);
  dis2=zeros(1000,1);
  accle3=zeros(1000,1);
  spdv3=zeros(1000,1);
  dis3=zeros(1000,1);
  tstep=0.1;
  spdv0(1)=inispd;
  hdwpos1=ss0./inispd+ss1;
  entisys=ceil(hdwpos1./tstep)+1;
  delttime=ceil(sample_here(1,5)/30./tstep);
  for isys=2:1000
    syst(isys)=(isys-1)*tstep;
    spdv0(isys)=spdv0(isys-1)+accle0(isys-1)*tstep;
    dis0(isys)=dis0(isys-1)+(spdv0(isys-1)+spdv0(isys))*tstep/2;
    spdv1(isys)=spdv1(isys-1)+accle1(isys-1)*tstep;
    dis1(isys)=dis1(isys-1)+(spdv1(isys-1)+spdv1(isys))*tstep/2;
    spdv2(isys)=spdv2(isys-1)+accle2(isys-1)*tstep;
    dis2(isys)=dis2(isys-1)+(spdv2(isys-1)+spdv2(isys))*tstep/2;
    spdv3(isys)=spdv3(isys-1)+accle3(isys-1)*tstep;
    dis3(isys)=dis3(isys-1)+(spdv3(isys-1)+spdv3(isys))*tstep/2;
    if isys==entisys
      spdv1(isys)=inispd;
      dis1(isys)=inispd*(tstep*(isys-1)-hdwpos1);
    elseif isys==2*entisys
      spdv2(isys)=inispd;
      dis2(isys)=inispd*(tstep*(isys-1)-2*hdwpos1);
    elseif isys==3*entisys
      spdv3(isys)=inispd;
      dis3(isys)=inispd*(tstep*(isys-1)-3*hdwpos1);       
    end
    if isys>delttime+1+entisys
      accle1(isys)=sample_here(1,2)*(spdv0(isys-delttime)-spdv1(isys-delttime)) + sample_here(1,3)*(dis0(isys-delttime)-dis1(isys-delttime)-ss1*spdv1(isys-delttime)-ss0);
    end
    if isys>delttime+1+2*entisys
      accle2(isys)=sample_here(1,2)*(spdv1(isys-delttime)-spdv2(isys-delttime)) + sample_here(1,3)*(dis1(isys-delttime)-dis2(isys-delttime)-ss1*spdv2(isys-delttime)-ss0);
    end
    if isys>delttime+1+3*entisys
      accle3(isys)=sample_here(1,2)*(spdv2(isys-delttime)-spdv3(isys-delttime)) + sample_here(1,3)*(dis2(isys-delttime)-dis3(isys-delttime)-ss1*spdv3(isys-delttime)-ss0);
    end
  end
  figure;
  plot(syst(:)',spdv0(:),'b',syst(:)',spdv1(:),'r');
  xlabel('Time (s)');
  ylabel('Speed (m/s)');
  xlim([0 100]);
  ylim([0 40]);
  legend('Lead','Follow');
  name = 'LocS';
  print('-dpng','-r300',strcat(out_dir_part,name));


  figure;
  plot(syst(:)',dis0(:),'b',syst(:)',dis1(:),'r');
  xlabel('Time (m)');
  ylabel('Distance (m/s)');
  xlim([0 200]);
  ylim([0 2500]);
  legend('Lead','Follow');
  name = 'LocD';
  print('-dpng','-r300',strcat(out_dir_part,name));

  %% String stability

  figure;
  plot(syst(:)',spdv0(:),'b',syst(:)',spdv1(:),'r',syst(:)',spdv2(:),'m',syst(:)',spdv3(:),'g');
  xlabel('Time (s)');
  ylabel('Speed (m/s)');
  xlim([0 100]);
  ylim([0 40]);
  legend('Lead','Follow 1','Follow 2','Follow 3');
  name = 'StrS';
  print('-dpng','-r300',strcat(out_dir_part,name));

  figure;
  plot(syst(:)',dis0(:),'b',syst(:)',dis1(:),'r',syst(:)',dis2(:),'m',syst(:)',dis3(:),'g');
  xlabel('Time (m)');
  ylabel('Distance (m/s)');
  xlim([0 200]);
  ylim([0 2500]);
  legend('Lead','Follow 1','Follow 2','Follow 3');
  name = 'StrD';
  print('-dpng','-r300',strcat(out_dir_part,name));

  [min1x,iddxi1x]=min(spdv1(350:1000,:));
  [min1,iddxi1]=min(spdv1(3*entisys:1000,:));
  [min2,iddxi2]=min(spdv2(3*entisys:1000,:));
  [min3,iddxi3]=min(spdv3(3*entisys:1000,:));
  if iddxi1x<600
    Allobj(Vehicle,5)=1;
  end
  if min3>min1
    Allobj(Vehicle,6)=1;
  end

  %% 目的関数の形状の表示

				% シミュレーション・データ
  ObjMap = zeros(100,100);

  for i = 1:100
    for j = 1:100
      
      prms(1) = 1/100*i*1;
      prms(2) = 1/100*j*0.5;
      
      s_sim = zeros(TTime,1);
      detv_sim = zeros(TTime,1);
      a1_sim = zeros(TTime,1);
      v1_sim = zeros(TTime,1);
      x1_sim = zeros(TTime,1);

      start = prms(4)+1;

      s_sim(1:start)=x0(1:start)-x1(1:start);
      detv_sim(1:start)=detv(1:start);
      a1_sim(1:start) = a1(1:start);
      v1_sim(1:start) = v1(1:start);
      x1_sim(1:start) = x1(1:start);

      for rr = start+1:TTime

	if rr >= t2lb
          a1_sim(rr) = prms(1)*detv_sim(rr-prms(4)) + prms(2)*s_sim(rr-prms(4)) - prms(2)*(ss1*v1_sim(rr-prms(4))+ss0) - prms(3)*9.8*(si(rr)-siu(rr));
	else
          a1_sim(rr) = prms(1)*detv_sim(rr-prms(4)) + prms(2)*s_sim(rr-prms(4)) - prms(2)*(ss1*v1_sim(rr-prms(4))+ss0);
	end


	%% 相対速度・車頭距離を計算
	v1_sim(rr) = v1_sim(rr-1) + a1_sim(rr-1)*(1/10);
	x1_sim(rr) = x1_sim(rr-1) + ((v1_sim(rr)+v1_sim(rr-1))/2)*(1/10);

	detv_sim(rr-1) = v0(rr-1) - v1_sim(rr-1);
	s_sim(rr) = x0(rr) - x1_sim(rr);
      end

      %% 目的関数の計算（RMSE）
      %% RMSE
      %% objFunc = sqrt(1/(TTime-start)*sum((s(start+1:TTime)-s_sim(start+1:TTime)).^(2)));

      %% Kesting
      obj1 = (s(start+1:TTime)-s_sim(start+1:TTime)).^(2)./abs(s(start+1:TTime))*(1/10);
      obj1 = sum(obj1)/(TTime-start);
      obj2 = sum(abs(s(start+1:TTime)))/(TTime-start);
      obj2 = 1/obj2;
      objFunc = sqrt(obj2*obj1);
      
      ObjMap(i,j) = objFunc;
    end
  end

  minobj = min(min(ObjMap));
  ind = find(ObjMap>minobj*10);
  ObjMap(ind) = minobj*10;

  x = 1/100*0.5*(1:100);
  y = 1/100*1*(1:100);
  [X,Y] = meshgrid(x,y);

  figure
  %% mesh(X,Y,ObjMap)
  %% view(60-37.5,15)
  contour(X,Y,ObjMap,300);
  colormap(jet)

  name = 'map';
  print('-dpng','-r300',strcat(out_dir_part,name));

  AllV(Vehicle,1:5) = sample_here(1,1:NumPrms+1);
  AllV(Vehicle,6)=ss1;
  AllV(Vehicle,7)=ss0;
  save AllV AllV
  save Allobj Allobj
  
  close all
  pause(0.1)
end
