clear all;
close all;

dir = '\';
 cd(dir)

data1 = xlsread("Block1_AccFirst.xlsx");
data1t = readtable("Block1_AccFirst.xlsx");
data2 = xlsread("ShareSecond.xlsx");
data2t = readtable("ShareSecond.xlsx");
data3 = xlsread("AccFirst.xlsx");
data3t = readtable("AccFirst.xlsx");

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    CLEAN DATA   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
data_t1=[];
  for a=2:height(data1t)
     if data1t{a,28}~=data1t{a-1,28}
      data_t1=[ data_t1;data1t(a-1,:)];   
     end 
  end
  
data_t2=[];
  for ax=2:height(data2t)
      if data2t{ax,28}~=data2t{ax-1,28}
     data_t2=[data_t2;data2t(ax-1,:)];   
     end 
  end
  
  newdata_t1=[];
  for b=1:height(data_t1)
    if data_t1{b,28}~=0
          newdata_t1=[newdata_t1;data_t1(b,:)];  
    end
 end
    newdata_t2=[];
  for bx=1:height(data_t2)
    if data_t2{bx,28}~=0
          newdata_t2=[newdata_t2;data_t2(bx,:)];  
    end
 end
  
   %eliminate check trials 
 cleaned_data_t1=[];
 check1=[];
 for c=1:height(newdata_t1)
     if newdata_t1{c,28}~=5 & newdata_t1{c,28}~=12 & newdata_t1{c,28}~=19 & newdata_t1{c,28}~=28
       cleaned_data_t1=[cleaned_data_t1;newdata_t1(c,:)];
     else 
         check1=[check1;newdata_t1(c,:)];
    end
 end
  
 
 %eliminate check trials 
 cleaned_data_t2=[];
 check2=[];
 for cx=1:height(newdata_t2)
     if newdata_t2{cx,28}~=6 & newdata_t2{cx,28}~=16 & newdata_t2{cx,28}~=24 & newdata_t2{cx,28}~=33& newdata_t2{cx,28}~=47& newdata_t2{cx,28}~=59
       cleaned_data_t2=[cleaned_data_t2;newdata_t2(cx,:)];
     else 
         check2=[check2; newdata_t2(cx,:)];
    end
 end
 
  n_subj1=(height(cleaned_data_t1))/30;
  n_subj2=(height(cleaned_data_t2))/60;
  
 
 
ID1 = array2table(NaN(n_subj1,1)); 
for h=1:n_subj1  
       f2=(h*30)-29;
       g2=h*30;
       ID1.id1(h)=cleaned_data_t1.ParticipantPublicID(f2);
end
ID1(:,1) = [];


 
ID2 = array2table(NaN(n_subj2,1)); 
for r=1:n_subj2  
       ry=(r*60)-59;
       rz=r*60;
       ID2.id2(r)=cleaned_data_t2.ParticipantPublicID(ry);
end
ID2(:,1) = [];

% CLEAN DATA
data_t3=[];
  for o=2:height(data3t)
     if data3t{o,28}~=data3t{o-1,28}
      data_t3=[ data_t3;data3t(o-1,:)];   
     end 
  end
  
   newdata_t3=[];
  for p=1:height(data_t3)
    if data_t3{p,28}~=0
          newdata_t3=[newdata_t3;data_t3(p,:)];  
    end
  end
 
    %eliminate check trials 
 cleaned_data_t3=[];
 check3=[];
 for c=1:height(newdata_t3)
     if newdata_t3{c,28}~=7 & newdata_t3{c,28}~=17 & newdata_t3{c,28}~=24 & newdata_t3{c,28}~=35& newdata_t3{c,28}~=49 & newdata_t3{c,28}~=56
       cleaned_data_t3=[cleaned_data_t3;newdata_t3(c,:)];
     else 
         check3=[check3;newdata_t3(c,:)];
    end
 end
 
   n_subj3=(height(cleaned_data_t3))/60;
   
   
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% OLD/NEW %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 %determine whether a sentence is old or new by comparing the sentence number and prolific ID
      for i=1:height(cleaned_data_t2)
          for h=1:height(cleaned_data_t1)
            if (isequal(cleaned_data_t2.ParticipantPublicID(i),cleaned_data_t1.ParticipantPublicID(h)) &  isequal(cleaned_data_t2.sentence_time2_number(i),cleaned_data_t1.sentence_time1_number(h)))
          
                   cleaned_data_t2.old1(i)=1;
            end
          end
      end
         
  for m=1:height(cleaned_data_t2)
 if isequal(cleaned_data_t2.old1(m),1) %OLD
      cleaned_data_t2.Share_old(m)= cleaned_data_t2.sharing_time2(m);
      cleaned_data_t2.Share_new(m)=NaN;
 elseif isequal(cleaned_data_t2.old1(m),0) %new
      cleaned_data_t2.Share_new(m)= cleaned_data_t2.sharing_time2(m);
      cleaned_data_t2.Share_old(m)=NaN;
 end
 end
 
results2 = array2table(NaN(n_subj2,1));
results1 = array2table(NaN(n_subj1,1));

results1.ID1=ID1.id1;
results2.ID2=ID2.id2;
 
  for n=1:n_subj2
    % analyze every 40 trials
 ny=(n*60)-59;
 nz=n*60;
   for k=ny:nz
        results2.ShareFirst_New(n)=nanmean(cleaned_data_t2.Share_new(ny:nz)); 
        results2.ShareFirst_Repeated(n)=nanmean(cleaned_data_t2.Share_old(ny:nz)); 
   end  
  end      
 
  
         


   
    %determine whether a sentence is old or new 
      for i=1:height(cleaned_data_t3)
          for h=1:height(cleaned_data_t1)
            if (isequal(cleaned_data_t3.ParticipantPublicID(i),cleaned_data_t1.ParticipantPublicID(h)) &  isequal(cleaned_data_t3.sentence_time3_number(i),cleaned_data_t1.sentence_time1_number(h)))
          
                   cleaned_data_t3.old1(i)=1;
            end
          end
      end
      
      
      for q=1:height(cleaned_data_t3)
 if isequal(cleaned_data_t3.old1(q),1) %OLD
      cleaned_data_t3.Accuracy_old(q)= cleaned_data_t3.accuracy_time3(q);
      cleaned_data_t3.Accuracy_new(q)=NaN;
 elseif isequal(cleaned_data_t3.old1(q),0) %new
      cleaned_data_t3.Accuracy_new(q)= cleaned_data_t3.accuracy_time3(q);
      cleaned_data_t3.Accuracy_old(q)=NaN;
 end
      end
 results3 = array2table(NaN(n_subj2,1));
 ID3 = array2table(NaN(n_subj3,1));
 
for s=1:n_subj3  
       sy=(s*60)-59;
       sz=s*60;
       ID3.id3(s)=cleaned_data_t3.ParticipantPublicID(sy);
end
ID3(:,1) = [];
results3.ID3=ID3.id3;
        
for n=1:n_subj3
    % analyze every 40 trials
 nyx=(n*60)-59;
 nzx=n*60;
   for k=nyx:nzx
        results3.AccuracySecond_New(n)=nanmean(cleaned_data_t3.Accuracy_new(nyx:nzx)); 
        results3.AccuracySecond_Repeated(n)=nanmean(cleaned_data_t3.Accuracy_old(nyx:nzx)); 
   end  
  end      
     
      
      for x=1:n_subj3
    % analyze every 40 trials
 y=(x*6)-5;
 z=x*6;
   for k=y:z
       results3.check3(x)=nansum(check3.catchTrialResponse_questions_time3_corr(y:z));
           results2.check2(x)=nansum(check2.catchTrialResponse_sharing_time2_corr(y:z));
   end  
      end    
 
                  for x=1:n_subj1
    % analyze every 40 trials
 y=(x*4)-3;
 z=x*4;
   for k=y:z
        results1.check1(x)=nansum(check1.catchTrialResponse_sharing_time1_corr(y:z));
       
   end  
 end  
         
 for x=1:n_subj3
    
      results1.check1_perc(x)=(100*results1.check1(x))/4;
     results3.check3_perc(x)=(100*results3.check3(x))/6;
     results2.check2_perc(x)=(100*results2.check2(x))/6;
 end
 
 

  results1(:,1) = [];
  results2(:,1) = [];
  results3(:,1) = [];
  results1=sortrows(results1,1);
  results2=sortrows(results2,1);
  results3=sortrows(results3,1);
  
 results = array2table(NaN(n_subj2,1)); 
 
 results=[results,results1];
   results=[results,results2];
    results=[results,results3]; 
     results(:,1) = [];
  
     
 
%  COMPUTE CORRELATION BETWEEN ACCURACY AND SHARING     
       
  cleaned_data_t2_n=sortrows(cleaned_data_t2,30);
 cleaned_data_t3_n=sortrows(cleaned_data_t3,30);
 cleaned_data_t2_id=sortrows(cleaned_data_t2_n,12);
 cleaned_data_t3_id=sortrows(cleaned_data_t3_n,12);
data_3=cleaned_data_t3_id;
data_2=cleaned_data_t2_id;


   Res= array2table(NaN(n_subj2,1));
    
 for x=1:n_subj2
 y=(x*60)-59;
 z=x*60;
   for k=y:z
        Res.ID(x)=data_3.ParticipantPublicID(y);
      corr=corrcoef(data_3.accuracy_time3(y:z),data_2.sharing_time2(y:z),'rows','pairwise');
       Res.Corr_share_acc(x)=corr(1,2); 
        corr1=corrcoef(data_3.Accuracy_new(y:z),data_2.Share_new(y:z),'rows','pairwise');
        Res.Corr_New(x)=corr1(1,2);
        corr2=corrcoef(data_3.Accuracy_old(y:z),data_2.Share_old(y:z),'rows','pairwise');
        Res.Corr_Old(x)=corr2(1,2);     
   end  
 end  
      
  Res(:,1) = [];
Res=sortrows(Res,1);


%COMPUTE truth false scores
stat = readtable("statementsTruth.xlsx");
Adata=[data_2(:,12) data_2(:,30) data_2(:,37) data_2(:,31) data_2(:,38:39) data_3(:,31) data_3(:,38:39)];



 %determine whether a sentence is true by comparing the sentence number
      for i=1:height(Adata)
          for h=1:height(stat)
            if isequal(Adata.sentence_time2_number(i),stat.Number(h))
          
                   Adata.True1(i)=stat.Truth1(h);
            end
          end
      end
 
  Ares = array2table(NaN(n_subj2,1)); 
  
   for m=1:height(Adata)
 if isequal(Adata.True1(m),1) %true
      Adata.Share_True(m)= Adata.sharing_time2(m);
      Adata.Share_False(m)=NaN;
      Adata.Acc_True(m)= Adata.accuracy_time3(m);
      Adata.Acc_False(m)=NaN;
 elseif isequal(Adata.True1(m),0) %false
      Adata.Share_False(m)= Adata.sharing_time2(m);
      Adata.Share_True(m)=NaN;
      Adata.Acc_False(m)= Adata.accuracy_time3(m);
      Adata.Acc_True(m)=NaN;
 end
   end

  
     for m=1:height(Adata)
 if isequal(Adata.old1(m),1) %repeated
      Adata.Sh_RepTrue(m)= Adata.Share_True(m);
      Adata.Sh_RepFalse(m)=Adata.Share_False(m);
      Adata.Sh_NewTrue(m)= NaN;
      Adata.Sh_NewFalse(m)=NaN;
      Adata.Ac_RepTrue(m)= Adata.Acc_True(m);
      Adata.Ac_RepFalse(m)=Adata.Acc_False(m);
      Adata.Ac_NewTrue(m)= NaN;
      Adata.Ac_NewFalse(m)=NaN;
 elseif isequal(Adata.old1(m),0) %new
      Adata.Sh_RepTrue(m)= NaN;
      Adata.Sh_RepFalse(m)= NaN;
      Adata.Sh_NewTrue(m)= Adata.Share_True(m);
      Adata.Sh_NewFalse(m)=Adata.Share_False(m);
      Adata.Ac_RepTrue(m)= NaN;
      Adata.Ac_RepFalse(m)=NaN;
      Adata.Ac_NewTrue(m)=Adata.Acc_True(m);
      Adata.Ac_NewFalse(m)=Adata.Acc_False(m);
 end
 end


Allresults=[Res(:,2:4) results];


for n=1:n_subj2
    % analyze every 40 trials
 ny=(n*60)-59;
 nz=n*60;
   for k=ny:nz
       Allresults.ID(n)=Adata.ParticipantPublicID(ny);
       Allresults.ShareFirst1(n)=0;
       Adata.ShareFirst1(k)=0;
        Allresults.Share_True(n)=nanmean(Adata.Share_True(ny:nz)); 
        Allresults.Share_False(n)=nanmean(Adata.Share_False(ny:nz)); 
        Allresults.Acc_True(n)=nanmean(Adata.Acc_True(ny:nz)); 
        Allresults.Acc_False(n)=nanmean(Adata.Acc_False(ny:nz)); 
        
       Allresults.Sh_RepTrue(n)= nanmean(Adata.Sh_RepTrue(ny:nz)); 
      Allresults.Sh_RepFalse(n)= nanmean(Adata.Sh_RepFalse(ny:nz)); 
     Allresults.Sh_NewTrue(n)= nanmean(Adata.Sh_NewTrue(ny:nz)); 
      Allresults.Sh_NewFalse(n)=nanmean(Adata.Sh_NewFalse(ny:nz)); 
     Allresults.Ac_RepTrue(n)= nanmean(Adata.Ac_RepTrue(ny:nz)); 
     Allresults.Ac_RepFalse(n)=nanmean(Adata.Ac_RepFalse(ny:nz)); 
      Allresults.Ac_NewTrue(n)=nanmean(Adata.Ac_NewTrue(ny:nz)); 
   Allresults.Ac_NewFalse(n)=nanmean(Adata.Ac_NewFalse(ny:nz)); 
   end  
end     
  

writetable(Allresults,'Results_Rep_AccFirst_New.xlsx')
writetable(Adata,'DataTrials_Rep_AccFirst_New.xlsx');
