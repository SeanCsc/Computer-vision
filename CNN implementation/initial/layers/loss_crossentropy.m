% ----------------------------------------------------------------------
% input: num_nodes x batch_size
% labels: batch_size x 1
% ----------------------------------------------------------------------

function [loss, dv_input] = loss_crossentropy(input, labels, hyper_params, backprop)

assert(max(labels) <= size(input,1));

% TODO: CALCULATE LOSS
loss = 0;
input_log = log(input);
[n,batch] = size(input);
label_onehot = ind2vec(labels');
[out,batch] = size(label_onehot);
loss_batch = zeros(batch,1);
for i = 1:batch
    tmp = label_onehot(:,i);
    loss_batch(i,:) = input_log(:,i)'*tmp;
end
loss = -1/batch * sum(loss_batch);


dv_input = zeros(size(input));
if backprop
	% TODO: BACKPROP CODE
    dv_input = -label_onehot./input;
end
