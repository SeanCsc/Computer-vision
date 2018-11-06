%% in order to show the change of test loss, I changed the parameter of train function by adding
%% two parameters(test means the part of test_data, test_label means the corresponding label)

function [model, loss,loss_test] = train(model,input,label,params,numIters,test,test_label)

% Initialize training parameters
% This code sets default values in case the parameters are not passed in.

% Learning rate
if isfield(params,'learning_rate') lr = params.learning_rate;
else lr = .1; end
% Weight decay
if isfield(params,'weight_decay') wd = params.weight_decay;
else wd = 0.0005; end
% Batch size
if isfield(params,'batch_size') batch_size = params.batch_size;
else batch_size = 128; end

% There is a good chance you will want to save your network model during/after
% training. It is up to you where you save and how often you choose to back up
% your model. By default the code saves the model in 'model.mat'
% To save the model use: save(save_file,'model');
if isfield(params,'save_file') save_file = params.save_file;
else save_file = 'model.mat'; end

% update_params will be passed to your update_weights function.
% This allows flexibility in case you want to implement extra features like momentum.
update_params = struct('learning_rate',lr,'weight_decay',wd);
loss = [];
loss_test = [];
[h,w,c,s] = size(input);
loss_total = zeros(numIters,1);
acc = zeros(numIters,1);
figure
h = animatedline;
axis([0 numIters 0 1])
for i = 1:numIters
	% TODO: Training code
    index = randperm(s,batch_size);
    train_batch = input(:,:,:,index);
    train_label_batch = label(index,:);
    [output,act] = inference(model,train_batch);    
    [tmp,dv_output] = loss_crossentropy(output,train_label_batch,[],1);
    loss(i) = tmp;
    grad = calc_gradient(model,train_batch,act,dv_output);
    model = update_weights(model,grad,update_params); 
    %calculate the accuracy
    [max_out,loc] = max(output);
    if(mod(i-1,100) == 0)
        m = floor(i/100)+1;
        %test set
    [output_test,act_test] = inference(model,test);    
    [loss_test(m),~] = loss_crossentropy(output_test,test_label,[],1);
    loss_test
    %%%%%%%%  
    end
    addpoints(h,i,tmp)
    drawnow 
    
end
drawnow
plot(loss)
% label('loss')
% hold on 


