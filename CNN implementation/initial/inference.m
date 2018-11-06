function [output,activations] = inference(model,input)
% Do forward propagation through the network to get the activation
% at each layer, and the final output

num_layers = numel(model.layers);
activations = cell(num_layers,1);

back = false;

% TODO: FORWARD PROPAGATION CODE
for i = 1:num_layers
    params = model.layers(i).params;
    hyper_params = model.layers(i).hyper_params;
    [res,~,~] = model.layers(i).fwd_fn(input,params,hyper_params,back,[]);
    activations{i} = res;
    input = res;
end

output = activations{end};

