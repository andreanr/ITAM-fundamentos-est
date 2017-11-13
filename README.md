# Fundamentos de Estadístcia (EST-46111)

Otoño 2017

-----------------------------------------------------------------------
-----------------------------------------------------------------------

Datos para el trabajo final de curso EST-46111 Fundamentos de Estadística

## Descripción

Los datos `diabetes-data.csv` contienen la información de medición de glucosa en la sangre
de 70 pacientes con diabetes observados en diferentes momentos del tiempo (horas, días, semanas, meses).

El contenido y formato de los datos es el siguiente:
a) Fecha (`date`) en formato `MM-DD-YYYY`
b) Hora (`time`) en formato `XX:YY`
c) Código (`code`)
d) Nivel de glucosa (`value`)
e) Indicadora de paciente (`individual`)

Los datos de concentración en la sangre se obtienen de dos fuentes:
1. Mediciones electrónicas automáticas
2. Registros escritos en papel.

Las mediciones eletrónicas automáticas se obtienen con etiquetas de tiempo específicas, mientras que las mediciones obtenidas de los registros escritos corresponden a horarios ficticios con la siguiente relación: Desayuno (08:00), comida (12:00), cena (18:00), y hora de dormir (22:00). 

El campo `code` corresponde al tipo de insulina administrada al paciente. 

33 = dosis de insulina regular

34 = dosis de insulina *NPH*

35 = dosis de insulina *UltraLente*

48 = medición de glucosa en sangre no especificada

57 = medición de glucosa en sangre no especificada

58 = medición de glucosa en sangre antes del desayuno

59 = medición de glucosa en sangre después del desayuno

60 = medición de glucosa en sangre antes del almuerzo

61 = medición de glucosa en sangre después del almuerzo

62 = medición de glucosa en sangre antes de la cena

63 = medición de glucosa en sangre después de la cena

64 = medición de glucosa en sangre antes del aperitivo

65 = síntomas de hipoglucemia

66 = ingestión típica de comida

67 = ingestión de comida mayor de lo habitual

68 = ingestión de comida menor de lo usual

69 = actividad típica de ejercicio

70 = actividad de ejercicio mayor de lo habitual

71 = actividad de ejercicio menor de lo habitual

72 = evento especial no especificado

**Nota:** La información de la adminitración de insulina, en este momento, es irrelevante.

-----------------------------------------------------------------------

* Fuente de información: UCI Datasets

https://archive.ics.uci.edu/ml/machine-learning-databases/diabetes/diabetes-data.tar.Z

Source: Michael Kahn, MD, PhD, Washington University, St. Louis, MO

https://archive.ics.uci.edu/ml/datasets/diabetes

