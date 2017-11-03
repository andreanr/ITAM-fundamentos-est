# est46111_datos

Datos para el trabajo final de curso EST-46111 Fundamentos de Estadística

-----------------------------------------------------------------------

# Datos

https://archive.ics.uci.edu/ml/machine-learning-databases/diabetes/diabetes-data.tar.Z

-----------------------------------------------------------------------

# Description

This directory contain a data set prepared for the use of participants
for the 1994 AAAI Spring Symposium on Artificial Intelligence in Medicine.

* `diabetes-data.tar.Z` contains the distribution for 70 sets of data recorded
on diabetes patients (several weeks' to months' worth of glucose, insulin,
and lifestyle data per patient + a description of the problem domain).
Archived using tar and compressed.

Extract the data files from the archive.  On a Unix system, type
`tar xvf icu-data.tar`. This will create a new directory named  ICU-Data
and extract all data files into that directory.  Very occasionally
this may not work; in that case try `tar xvof` instead of `tar xvf`.

-----------------------------------------------------------------------

# Descripción

Este directorio contiene un conjunto de datos preparados para el uso de los participantes
para el Simposio de primavera AAAI de 1994 sobre Inteligencia Artificial en Medicina.

* `diabetes-data.tar.Z` contiene la distribución de 70 grupos de datos observados
en pacientes con diabetes (glucosa en varias semanas o meses, insulina,
y datos de estilo de vida por paciente + una descripción del dominio del problema).
Archivado usando `*.tar` y comprimido.

Extraiga los archivos de datos del archivo. En un sistema Unix, escriba
`tar xvf icu-data.tar`. Esto creará un nuevo directorio llamado ICU-Data
y extrae todos los archivos de datos en ese directorio. En ocasiones,
esto puede no funcionar; en ese caso, pruebe `tar xvof`  en lugar de `tar xvf`.

-----------------------------------------------------------------------

# Source

https://archive.ics.uci.edu/ml/datasets/diabetes

Michael Kahn, MD, PhD, Washington University, St. Louis, MO

-----------------------------------------------------------------------

# Data Set Information:

Diabetes patient records were obtained from two sources: an automatic electronic recording device and paper records. The automatic device had an internal clock to timestamp events, whereas the paper records only provided "logical time" slots (breakfast, lunch, dinner, bedtime). For paper records, fixed times were assigned to breakfast (08:00), lunch (12:00), dinner (18:00), and bedtime (22:00). Thus paper records have fictitious uniform recording times whereas electronic records have more realistic time stamps.

Diabetes files consist of four fields per record. Each field is separated by a tab and each record is separated by a newline.

## File Names and format:

(1) Date in MM-DD-YYYY format

(2) Time in XX:YY format

(3) Code

(4) Value

The Code field is deciphered as follows:

33 = Regular insulin dose

34 = NPH insulin dose

35 = UltraLente insulin dose

48 = Unspecified blood glucose measurement

57 = Unspecified blood glucose measurement

58 = Pre-breakfast blood glucose measurement

59 = Post-breakfast blood glucose measurement

60 = Pre-lunch blood glucose measurement

61 = Post-lunch blood glucose measurement

62 = Pre-supper blood glucose measurement

63 = Post-supper blood glucose measurement

64 = Pre-snack blood glucose measurement

65 = Hypoglycemic symptoms

66 = Typical meal ingestion

67 = More-than-usual meal ingestion

68 = Less-than-usual meal ingestion

69 = Typical exercise activity

70 = More-than-usual exercise activity

71 = Less-than-usual exercise activity

72 = Unspecified special event


## Attribute Information:

Diabetes files consist of four fields per record. Each field is separated by a tab and each record is separated by a newline.

File Names and format:

(1) Date in MM-DD-YYYY format

(2) Time in XX:YY format

(3) Code

(4) Value

