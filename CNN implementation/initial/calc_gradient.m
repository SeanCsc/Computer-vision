function [grad] = calc_gradient(model, input, activations, dv_output)
% Calculate the gradient at each layer, to do this you need dv_output
% determined by your loss function and the activations of each layer.
% The loop of this function will look very similar to the code from
% inference, just looping in reverse.

num_layers = numel(model.layers);
grad = cell(num_layers,1);
back = true;
% TODO: Determine the gradient at each layer with weights to be updated
for i = num_layers:-1:1
    layer = model.layers(i);
    params = layer.params;
    hyper_params = layer.hyper_params;
    if (i>=2)
    [~,dv_output,grad{i}] = layer.fwd_fn(activations{i-1},params,hyper_params,back,dv_output);
    else
    [~,dv_output,grad{i}] = layer.fwd_fn(input,params,hyper_params,back,dv_output);
    end
end
