function updated_model = update_weights(model,grad,hyper_params)

num_layers = length(grad);
a = hyper_params.learning_rate;
lambda = hyper_params.weight_decay;
updated_model = model;



% TODO: Update the weights of each layer in your model based on the calculated gradients
for i = num_layers:-1:1
    layer = updated_model.layers(i);
    param = layer.params;
    updated_model.layers(i).params.W = layer.params.W - a*grad{i}.W - lambda*layer.params.W;
    updated_model.layers(i).params.b = layer.params.b - a*grad{i}.b - lambda*layer.params.b;    
end