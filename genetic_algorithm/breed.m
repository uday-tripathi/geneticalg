% Uday Tripathi 7/2016

% Sample input: (genomes, 3, newMets)
% newMets={'EX Ca2 e0','EX Cbl e0','EX Cd2 e0','EX Cl- e0','EX Co2 e0'}
function modGenomes=breed(genomesArray, numStaySame, newMets, newModels, numCross)
genomeSize=length(genomesArray);
copyGen=genomesArray;

% First "numStaySame" genomes are populated by the x fittest genomes from
% prior generation
for i=1:numStaySame
    for j=1:length(copyGen)
        scores(j)=abs(copyGen(j).score);
    end
    [a,b]=sort(scores(:),'descend');
    maxIndicies=b(1:numStaySame);
end

for k=1:numStaySame
    index=b(k);
    copyGen(index).score=0;
    modGenomes(k)=copyGen(index);
end

for i=numStaySame+1:genomeSize
    % Cross-Breeding
    counter=1;
    for j=1:numCross-1 %
        max1=maxIndicies(j);
        if mod(counter,2)~=0 % Allows for both recombinations
            max2=maxIndicies(j+1);
        else
            max2=maxIndicies(j-1);
        end
        g1=genomesArray(max1);
        g2=genomesArray(max2);
        sq1=g1.sequence;
        models1=sq1(g1.endOfMets+1:length(sq1));
        models1=cell2mat(models1);
        sq2=g2.sequence;
        mets2=sq2(1:g2.endOfMets);
        tempG=Genome();
        tempG=tempG.addMetsAndModels(mets2,models1(1:length(models1)));
        modGenomes(numStaySame+counter)=tempG;
        counter=counter+1;
    end
    
    % Mutations
    mut=1;
    for k=genomeSize-numStaySame+(counter):genomeSize
        %genIndex=maxIndicies(mut);
        genIndex=randi([1,numStaySame]);
        gen=genomesArray(genIndex);
        
        genomesArray(i).endOfMets=3; %%
        
        coinflip=randi([1,20]);
        if coinflip<6 % Mets
            metPos=genomesArray(i).endOfMets;
            posOfMutation=randi([1,metPos]);
            randMet=randi([1,length(newMets)]);
            gen.sequence(posOfMutation)=newMets(randMet);
        elseif coinflip<18 % Models
            modelPos=genomesArray(i).endOfMets+1;
            posOfMutation=randi([modelPos,length(gen.sequence)]);
            randModel=randi([1,length(newModels)]);
            gen.sequence{posOfMutation}=randModel;
        else % Knockout
            pos=randi([1,genomesArray(i).endOfMets]);
            gen.sequence{pos}=[];
        end
        gen.score=0;
        modGenomes(k)=gen;
        mut=mut+1;
    end
end
end
