% ----------------------------------------------------------------------
% input: in_height x in_width x num_channels x batch_size
% output: out_height x out_width x num_filters x batch_size
% hyper parameters: (stride, padding for further work)
% params.W: filter_height x filter_width x filter_depth x num_filters
% params.b: num_filters x 1
% dv_output: same as output
% dv_input: same as input
% grad.W: same as params.W
% grad.b: same as params.b
% ----------------------------------------------------------------------

function [output, dv_input, grad] = fn_conv(input, params, hyper_params, backprop, dv_output)

[~,~,num_channels,batch_size] = size(input);
[wh,ww,filter_depth,num_filters] = size(params.W);
assert(filter_depth == num_channels, 'Filter depth does not match number of input channels');

out_height = size(input,1) - size(params.W,1) + 1;
out_width = size(input,2) - size(params.W,2) + 1;
output = zeros(out_height,out_width,num_filters,batch_size);
% TODO: FORWARD CODE
tmp = zeros(out_height,out_width,num_channels);
for i = 1:batch_size
    for j = 1:num_filters
        for k = 1:num_channels
            tmp(:,:,k) = conv2(input(:,:,k,i),rot90(rot90(params.W(:,:,k,j))),'valid') ;
        end
        output(:,:,j,i) = sum(tmp,3)+ params.b(j);
    end
end

        


dv_input = [];
tmpw = [];
tmpb = [];
grad = struct('W',[],'b',[]);

if backprop
	dv_input = zeros(size(input));
	grad.W = zeros(size(params.W));
	grad.b = zeros(size(params.b));
    
	% TODO: BACKPROP CODE
for i = 1:num_filters
    for j = 1:num_channels
        for k = 1:batch_size
            tmpw(:,:,k) = conv2(input(:,:,j,k),rot90(rot90(dv_output(:,:,i,k))),'valid');
        end
        grad.W(:,:,j,i) = sum(tmpw,3)./batch_size;
    end
end
tmp = [];
for i = 1:num_filters
    for j = 1:batch_size
        tmp(i,j) = sum(sum(dv_output(:,:,i,j)));
    end
    grad.b(i,:) = sum(tmp(i,:))./batch_size;
end
tmp = [];
for i = 1:batch_size
    for j = 1:num_channels
        for k = 1:num_filters
            tmp(:,:,k) = conv2(dv_output(:,:,k,i),params.W(:,:,j,k));
        end
        dv_input(:,:,j,i) = sum(tmp,3);
    end
end         
end
