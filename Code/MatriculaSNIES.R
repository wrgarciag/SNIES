rm(list=ls())


#/////////////////////////////////////////////////
#                1. MACROS----
#/////////////////////////////////////////////////


#////////////////////////////////////////////////////////////////////
#                         1.1 Paths-----
#////////////////////////////////////////////////////////////////////

PathWD  <- paste0("F:/MatriculaSNIES/")

# Directorios 
LCode <- paste0(PathWD,"Code/")
LData <- paste0(PathWD,"Data/")
LResu <- paste0(PathWD,"Resu/")

#setwd(LCode)



#////////////////////////////////////////////////////////////////////
#                         1.2 Librerias-----
#////////////////////////////////////////////////////////////////////

library(data.table)
library(reshape2)
library(dplyr)
library(plyr)


#/////////////////////////////////////////////////
#                2. DATOS----
#/////////////////////////////////////////////////

## Matriculados SNIES 2014-2017

Matri_2017 <- as.data.table(read.csv(paste0(PathWD,"Matriculados_SNIES_2017.csv"), header = TRUE, sep = ",", quote = "\"",dec = ".", fill = TRUE))

Matri_2016 <- as.data.table(read.csv(paste0(PathWD,"Matriculados_SNIES_2016.csv"), header = TRUE, sep = ",", quote = "\"",dec = ".", fill = TRUE))

Matri_2015 <- as.data.table(read.csv(paste0(PathWD,"Matriculados_SNIES_2015.csv"), header = TRUE, sep = ",", quote = "\"",dec = ".", fill = TRUE))

Matri_2014 <- as.data.table(read.csv(paste0(PathWD,"Matriculados_SNIES_2014.csv"), header = TRUE, sep = ",", quote = "\"",dec = ".", fill = TRUE))

Matri_1416 <- rbind(Matri_2017,Matri_2016,Matri_2015,Matri_2014)

#Limpiar
rm(Matri_2017,Matri_2016,Matri_2015,Matri_2014)


## Matriculados SNIES 2000-2013

Matri_0013 <- as.data.table(read.csv(paste0(PathWD,"Matriculados_SNIES_2001_2013.csv"), 
                                     header = TRUE, sep = ",", quote = "\"",dec = ".", fill = TRUE))

## Crea un consecutivo
Matri_0013$consecutivo  <- 1:nrow(Matri_0013)

## Variables de id
Matri_0013_i  <- select(Matri_0013,c(1:19,ncol(Matri_0013)))

## Base reshapeada
Matri_0013_d  <- select(Matri_0013,c(20:ncol(Matri_0013)))
Matri_0013_d  <- melt(Matri_0013_d,id.vars = c("consecutivo"))

setDT(Matri_0013_d)[, paste0("variable", 1:3) := tstrsplit(variable, "_")]

setnames(Matri_0013_d,c("variable1","variable2","variable3"),c("sexo","anio","semestre"))

setnames(Matri_0013_d,c("value"),c("matriculados"))

Matri_0013_d[,c("variable","value"):=NULL]

Matri_0013_d <- Matri_0013_d[sexo!="Total",]

## Junta con datos de identificacion

Matri_0013  <- merge(Matri_0013_d,Matri_0013_i,by=c("consecutivo"), all.x= TRUE)

Matri_0013[,c("consecutivo"):=NULL]

rm(Matri_0013_d,Matri_0013_i)

## Union de las bases

Matriculados <- as.data.table(rbind.fill(Matri_0013,Matri_1416))

Matriculados[,anio:=as.numeric(anio)]

saveRDS(Matriculados,file=(paste0(PathWD,"Matriculados_SNIES_2000_2017",".rds")))
fwrite(Matriculados,paste0(PathWD,"Matriculados_SNIES_2000_2017",".csv"),row.names=FALSE, na="")


### Consultas

CMatri <- Matriculados[semestre==1 & id_muni_programa==11001,list(matriculados=sum(matriculados,na.rm = TRUE))
                       ,by=list(anio)]

fwrite(CMatri,paste0(PathWD,"CMatri_SNIES_Sector_2000_2017",".csv"),row.names=FALSE, na="")