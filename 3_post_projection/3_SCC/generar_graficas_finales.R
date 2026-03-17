# --- Script de Visualización de Réplica SCC ---
# Generado desde la terminal por Andrez Felipe Guerrero Torres

library(reticulate)
# Ajusta esta ruta si otro usuario corre el script
use_python("/Users/andrezconz/miniconda3/bin/python", required = TRUE)

# Carga de datos
df <- read.csv("ce_damage_timeseries.csv")

# 1. Gráfica de Validación vs Nature
pdf("Validacion_Nature.pdf")
plot(df$year, df$pct_gdp_ce * 100, type="l", col="blue", lwd=2,
     main="Validación de Réplica vs Nature", ylab="% PIB", xlab="Año")
polygon(c(2020, 2100, 2100, 2020), c(0, 0.7, 1.2, 0.1), col=rgb(0.5,0.5,0.5,0.3), border=NA)
dev.off()

# 2. Gráfica Daño vs PIB (Relación No Lineal)
pdf("Relacion_Dano_PIB.pdf")
plot(df$gdp, df$global_ce_dmg, col="darkgreen", pch=19,
     main="Relación Crecimiento vs Daño", xlab="PIB Global", ylab="Daño USD")
abline(lm(global_ce_dmg ~ gdp, data=df), col="red", lwd=2)
dev.off()

cat("\n[ÉXITO] Gráficas exportadas en PDF en la carpeta 3_SCC\n")
