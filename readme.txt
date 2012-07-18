Cada carpeta corresponde a informacion para un sitio de clivaje

dentro de cada carpeta hay archivos asi:

15 archivos de la forma: automata-N.auto 
Cada uno es un modelo (automata), Donde N es el numero del modelo

15 archivos de la forma: automata-N.auto.dot
Cada uno es un modelo (automata) pero en formato GraphViz

30 archivos de la forma {pn}hmm-N.hmm
Cada uno es un modelo (HMM) en texto plano. Donde N es el numero del modelo.
Existe un modelo p y un modelo n que juntos forman un clasificador para cada numero N.
La primera letra indica si es un modelo para muestras positivas cuando es 'p'.
La primera letra indica si es un modelo para muestras negativas cuando es 'n'.

1 archivo: models_oil.txt
Manifiesto de clasificador con 15 modelos

1 archivo: train.destino
Archivo de muestras de entrenamiento usado total y unicamente para entrenar los modelos.