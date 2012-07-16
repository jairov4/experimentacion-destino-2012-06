sites = 9;
site = cell(1,sites);
for item=1:sites,
    fprintf('Sitio %d\n', item);
    % carga datos de entrenamiento y test
    train_filename = strcat(int2str(item), '/train.csv');
    test_filename = strcat(int2str(item), '/test.csv');
    train_data = importdata(train_filename);
    test_data = importdata(test_filename);
    train_data_cell = cell(2,1);
    data_size = size(train_data);
    % Separa los conjuntos por clase y obtiene el tamaño mas pequeño
    max_count = data_size(1);    
    for class_number=0:1,
        selector = train_data(:,1) == class_number;
        data_selected = train_data(selector,:);
        train_data_cell{class_number+1} = data_selected;
        max_count = min(max_count, length(data_selected));
    end;
    total_classes = length(train_data_cell);    
    % balancea los conjuntos
    for class_number=1:total_classes,
        thedata = train_data_cell{class_number};
        order = randperm(length(thedata));
        thedata2 = thedata(order,:);
        clip_value = max_count;
        train_data_cell{class_number} = thedata2(1:clip_value,:);        
    end;
    % concatena de nuevo los conjuntos pero ya balanceados
    % TODO: no hardcode a 2 conjuntos
    train_all = [ train_data_cell{1}; train_data_cell{2} ];
    
    % obtiene entradas y salidas para mostrar a la red
    train_inputs = train_all(:,2:end);
    train_targets = train_all(:,1);
    test_inputs = test_data(:,2:end);
    test_targets = test_data(:,1);
        
    % entrena varios modelos
    hiddenLayerSize = 15;    
    model_count = 15;
    models = cell(model_count, 1);
    results = zeros(length(test_data), model_count+1);
    for model_index=1:model_count,        
        % nueva red para reconocimiento de patrones
        net = patternnet(hiddenLayerSize);
        net.divideParam.trainRatio = 90/100;
        net.divideParam.valRatio = 10/100;
        net.divideParam.testRatio = 0/100;
        % entrena un modelo
        [net, tr] = train(net, train_inputs', train_targets');        
        test_outputs = sim(net, test_inputs') > 0.5; % comprueba las decisiones por cada muestra
        % guarda el modelo y los resultados
        models{model_index}.net = net;
        models{model_index}.training = tr;
        models{model_index}.outputs = test_outputs';
        results(:,model_index) = test_outputs';
    end;
    results(:,model_count+1) = test_targets;
    tp = 0;
    tn = 0;
    totalp = 0;
    totaln = 0;
    for I=1:length(test_data),
        row = results(I,:);
        cl = row(end);
        vt = row(1:end-1);
        vtv = sum(vt); % votacion
        clp = vtv > floor(model_count / 2);
        if cl,
            totalp = totalp + 1;
        else
            totaln = totaln + 1;
        end
        if clp == cl,
           if cl == 0
               tn = tn + 1;
           end
           if cl == 1
               tp = tp + 1;
           end
        end;
    end;
    total = totalp+totaln;
    acc = (tp+tn)/total;
    spec = tn/totaln;
    sens = tp/totalp;
    % de los efectivamente negativos (totaln), 
    % resto los que acertadamente clasifico negativos (tn).
    % me quedan los que efectivamente eran negativos 
    % pero que equivocadametne clasifique como positivos (fp)
    fp = totaln-tn; 
    fn = totalp-tp;
    mcc = (tp*tn-fp*fn)/sqrt((tp+fp)*(tp+fn)*(tn+fp)*(tn+fn));
    site{item} = struct('tp', tp, 'tn', tn, 'totalp', totalp, 'totaln', totaln, 'acc', acc, 'sens', sens, 'spec', spec, 'mcc', mcc);
    fprintf('Acc: %0.3f Spec: %0.3f Sens: %0.3f MCC: %0.3f\n', acc, spec, sens, mcc);
end;
