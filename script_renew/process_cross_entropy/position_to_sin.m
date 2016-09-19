function [si, siu, t2lb] = position_to_sin(x1)

  gt=zeros(length(x1),1);
  si=zeros(length(x1),1);
  siu=zeros(length(x1),1);
  for igh=1:length(x1)
    if x1(igh)<414
      gt(igh)=-0.5+(-0.2+0.5)*(x1(igh)+536)/950;
    elseif x1(igh)<1114
      gt(igh)=-0.2+(2.4+0.2)*(x1(igh)-414)/700;
    else
      gt(igh)=-0.5+(-0.5-2.4)*(x1(igh)-1114)/906;
    end
    si(igh)=sin(gt(igh)/100);
    siu(igh)=sin(-0.2/100);
  end
  for ihg=1:length(x1)-1
    if  x1(ihg)<414 && x1(ihg+1)>414
      t2lb=ihg;
    end
  end

end
