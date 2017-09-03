function newLayout=resizeLayout(layout, newX, newY)

if newX<1 || newY<1
    errordlg('Please input positive, nonzero values','Error');
else
    layout.xdim=newX;
    layout.ydim=newY;
    % the problem is that the default model has vectors without any actual
    % items, so even though the vector should be 3-dimensional, MatLab sees
    % it as [] by default because of createLayout(). Also createLayout()
    % does not allow access to static_media and init_pop because those
    % variables are in the CometsLayout class but not in the function
    
    % size of layout
    % helpResize(layout,2,newX);
    % helpResize(layout,3,newY);
    
    %media_refresh
    helpResize(layout.media_refresh,2,newX);
    helpResize(layout.media_refresh,3,newY);
    
    %static_media
    helpResize(layout.static_media,2,newX);
    helpResize(layout.static_media,3,newY);
    
    %init_pop
    helpResize(layout.initial_pop,2,newX);
    helpResize(layout.initial_pop,3,newY);
    
    newLayout=layout;
end
end

% function that given a matrix, the number of a dimension, and a number for
% new dimension length, return a matrix that reduces the named dimension
% according to the given number.
% matrix: the input matrix that is to be resized
% dim: dimension that is to be resized
% newDim: the new size of the dimension that is being resized
function newMatrix=helpResize(matrix, dim, newDim)

check=size(matrix);
if dim<1 || newDim<1
    errordlg('Please input positive, nonzero values','Error');
else
    len=size(matrix);
    x=length(dim);
    if newDim<x % reducing size of matrix
        if dim==1 % for changing first dimensi   on
            if x==1
                newMatrix=matrix(1:newDim);
            elseif x==2
                newMatrix=matrix(1:newDim,:);
            elseif x==3
                newMatrix=matrix(1:newDim,:,:);
            elseif x==4
                newMatrix=matrix(1:newDim,:,:,:);
            end
        elseif dim==2 % for changing second dimension
            if x==2
                newMatrix=matrix(:,1:newDim);
            elseif x==3
                newMatrix=matrix(:,1:newDim,:);
            elseif x==4
                newMatrix=matrix(:,1:newDim,:,:);
            end
        elseif dim==3 % for changing third dimension
            if x==3
                newMatrix=matrix(:,:,1:newDim);
            elseif x==4
                newMatrix=matrix(:,:,1:newDim,:);
            end
        elseif dim==4 % for changing fourth dimension
            if x==4
                newMatrix=matrix(:,:,:,1:newDim);
            end
            
        end
        
    elseif newDim>x % increasing size of matrix
        tempMatrix=matrix;
        if dim==1 % resizing from 0 dimensions
            tempMatrix(newDim)=0;
        elseif dim==2 %resizing from 1 dimension
            tempMatrix(len(1),newDim)=0;
        elseif dim==3 %resizing from 2 dimensions
            tempMatrix(len(1),len(2),newDim)=0;
        elseif dim==4 %resizing from 3 dimensions
            tempMatrix(len(1),len(2),len(3),newDim)=0;
        end
        newMatrix=tempMatrix;
    end
end
end