% Load the MNIST data into the MATLAB workspace, and set a flag so that the
% data does not have to be reloaded everytime you want to test something.
addpath ../data;
epochs = 100;
if ~exist('MNIST_loaded')
	% Load training data
	train_data = load_MNIST_images('../data/train-images.idx3-ubyte');
	train_data = reshape(train_data,28,28,1,[]);
	train_label = load_MNIST_labels('../data/train-labels.idx1-ubyte');
	train_label(train_label == 0) = 10; % Remap 0 to 10

	% Load testing data
	test_data = load_MNIST_images('../data/t10k-images.idx3-ubyte');
	test_data = reshape(test_data,28,28,1,[]);
	test_label = load_MNIST_labels('../data/t10k-labels.idx1-ubyte');
	test_label(test_label == 0) = 10; % Remap 0 to 10

	MNIST_loaded = true;
end
test_data1 = test_data(:,:,:,1:200);
test_label1 = test_label(1:200);
%create model 
l = [init_layer('conv',struct('filter_size',5,'filter_depth',1,'num_filters',32)) %24*24
    init_layer('relu',[])
    init_layer('pool',struct('filter_size',2,'stride',2)) %12*12
    init_layer('conv',struct('filter_size',5,'filter_depth',32,'num_filters',32)) %8*8
    init_layer('relu',[])
	init_layer('pool',struct('filter_size',2,'stride',2)) %4*4
    init_layer('conv',struct('filter_size',3,'filter_depth',32,'num_filters',64)) %2*2
    init_layer('relu',[])


	%
	init_layer('flatten',struct('num_dims',4)) %multi-dimension -> one-dimension
	init_layer('linear',struct('num_in',256,'num_out',10))
	init_layer('softmax',[])];
[trainh,trainw,~,~] = size(train_data);
model = init_model(l,[trainh ,trainw,1],10,true);
%train
[model, loss,loss_test] = train(model,train_data,train_label,[],400,test_data,test_label);
%[model1, loss] = train(model,train_data,train_label,[],100);
%predict
[test_output,~] = inference(model,test_data);    
[~,loc_test] = max(test_output);
acctest = mean(loc_test' == test_label);

