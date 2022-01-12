function result = simpleJudgment(state)
% 简易的形式判断算法

% Empty
[xEmpty,yEmpty]=find(state==0);
beenUsed=false(size(xEmpty));
section=NaN(size(xEmpty));
territory=NaN(size(xEmpty));
part=1;
while any(beenUsed==0)
  Dim = find(beenUsed==0,1,'first');
  p=[xEmpty(Dim),yEmpty(Dim)];
  B=findBlock(state,p);
  result0 = surroundedBy(state,B);
  for i = 1:size(B,1)
    xx=B(i,1);
    yy=B(i,2);
    POS=find(xEmpty==xx&yEmpty==yy);
    if ~isempty(POS)
      beenUsed(POS)=true;
      section(POS)=part;
      if result0.isSurrounded
        territory(POS)=result0.surroundedBy;
      end
    end
  end
  part=part+1;
end

result.xEmpty=xEmpty;
result.yEmpty=yEmpty;
result.sectionEmpty=section;
result.territory=territory;

% Black
[xBlack,yBlack]=find(state==1);
beenUsed=false(size(xBlack));
section=NaN(size(xBlack));
territory=NaN(size(xBlack));
part=1;
while any(beenUsed==0)
  Dim = find(beenUsed==0,1,'first');
  p=[xBlack(Dim),yBlack(Dim)];
  B=findBlock(state,p);
  result0 = surroundedBy(state,B);
  for i = 1:size(B,1)
    xx=B(i,1);
    yy=B(i,2);
    POS=find(xBlack==xx&yBlack==yy);
    if ~isempty(POS)
      beenUsed(POS)=true;
      section(POS)=part;
      if result0.isSurrounded
        territory(POS)=result0.surroundedBy;
      end
    end
  end
  part=part+1;
end

result.xBlack=xBlack;
result.yBlack=yBlack;
result.sectionBlack=section;
N=max(result.sectionBlack);
result.numLibertyBlack = NaN([N,1]);
result.posLibertyBlack = cell([N,1]);
P=[result.xBlack,result.yBlack];
for i =1:N
  [result.numLibertyBlack(i),result.posLibertyBlack{i}] = ...
    getLiberty(state,P(result.sectionBlack==i,:));
end

% White
[xWhite,yWhite]=find(state==1);
beenUsed=false(size(xWhite));
section=NaN(size(xWhite));
territory=NaN(size(xWhite));
part=1;
while any(beenUsed==0)
  Dim = find(beenUsed==0,1,'first');
  p=[xWhite(Dim),yWhite(Dim)];
  B=findBlock(state,p);
  result0 = surroundedBy(state,B);
  for i = 1:size(B,1)
    xx=B(i,1);
    yy=B(i,2);
    POS=find(xWhite==xx&yWhite==yy);
    if ~isempty(POS)
      beenUsed(POS)=true;
      section(POS)=part;
      if result0.isSurrounded
        territory(POS)=result0.surroundedBy;
      end
    end
  end
  part=part+1;
end

result.xWhite=xWhite;
result.yWhite=yWhite;
result.sectionWhite=section;
N=max(result.sectionWhite);
result.numLibertyWhite = NaN([N,1]);
result.posLibertyWhite = cell([N,1]);
P=[result.xWhite,result.yWhite];
for i =1:N
  [result.numLibertyWhite(i),result.posLibertyWhite{i}] = ...
    getLiberty(state,P(result.sectionWhite==i,:));
end






