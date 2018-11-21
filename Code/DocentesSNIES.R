#Cruce

rm(list=ls())

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#                         1. MACROS-----
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#////////////////////////////////////////////////////////////////////
#                         1.1 Paths-----
#////////////////////////////////////////////////////////////////////

PathGD  <- paste0("H:/Mi unidad/02Work/6SED/")

# Directorios 
LCode <- paste0(PathGD,"Code/")
LData <- paste0(PathGD,"Data/")
LResu <- paste0(PathGD,"Resu/")

setwd(LCode)



#////////////////////////////////////////////////////////////////////
#                         1.2 Librerias-----
#////////////////////////////////////////////////////////////////////

library(data.table)
library(reshape2)

## Data 2014-2017

DT1417 <- as.data.table(read.csv(paste0(LData,"SNIES/","Docentes2014_2017.csv"), 
                                 header = TRUE, sep = ",", quote = "\"",dec = ".", fill = TRUE))


setnames(DT1417,"codigo_de_.la_institucion","codigo_institucion")
setnames(DT1417,"institucion_de_educacion_superior_.ies.","ies")

setnames(DT1417,"principal._o.seccional","principal")

setnames(DT1417,"codigo_del_.departamento..ies.","cod_depto_ies")

setnames(DT1417,"departamento_de_.domicilio_de_la_ies","depto_ies")

setnames(DT1417,"institucion_de_educacion_superior_.ies.","ies")


## Data 2002-2013

DT0713 <- as.data.table(read.csv(paste0(LData,"SNIES/","Docentes2007_2013.csv"), 
                                 header = TRUE, sep = ",", quote = "\"",dec = ".", fill = TRUE))

DT0713 <- melt(DT0713,id.vars=c(1:15),value.name = "docentes")

DT0713[,anio:=sub("_.*", "", variable)]

DT0713[,anio:=as.numeric(sub("X", "", anio))]

DT0713[,semestre:=sub(".*_", "", variable)]

DT0713$variable<-NULL

DT0713[,tiempo_dedicacion:=""]

DT0713[,tiempo_dedicacion:=ifelse(tiempo_de_dedicacion.del_docente=="CATEDRA","Catedra",tiempo_dedicacion)]

DT0713[,tiempo_dedicacion:=ifelse(tiempo_de_dedicacion.del_docente=="MEDIO TIEMPO","Medio Tiempo o Parcial",tiempo_dedicacion)]

DT0713[,tiempo_dedicacion:=ifelse(tiempo_de_dedicacion.del_docente=="NO INFORMA","Sin información",tiempo_dedicacion)]

DT0713[,tiempo_dedicacion:=ifelse(tiempo_de_dedicacion.del_docente=="PARCIAL","Medio Tiempo o Parcial",tiempo_dedicacion)]

DT0713[,tiempo_dedicacion:=ifelse(tiempo_de_dedicacion.del_docente=="TIEMPO COMPLETO","Tiempo Completo o Exclusiva",tiempo_dedicacion)]

## Exportar

write.csv(DT0713,file = paste0(LResu,"Docentes_0713.csv"), row.names = FALSE, na="")


## Consulta

