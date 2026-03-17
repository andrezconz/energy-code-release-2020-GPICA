# Script corregido con ruta de archivo específica
library(reticulate)
use_python("/Users/andrezconz/miniconda3/bin/python", required = TRUE)

# Definir la ruta al archivo CSV (buscando dentro de la carpeta correcta)
ruta_csv <- "3_post_projection/3_SCC/ce_damage_timeseries.csv"

if (!file.exists(ruta_csv)) {
  stop(paste("No se encontró el archivo en:", ruta_csv))
}

df <- read.csv(ruta_csv)

# --- 1. Gráfica de Validación ---
pdf("3_post_projection/3_SCC/plot_validacion_nature.pdf", width = 8, height = 6)
plot(df$year, df$pct_gdp_ce * 100, type="l", col="blue", lwd=2,
     main="Validación: Réplica vs Nature", ylab="Impacto (% del PIB)", xlab="Año")
polygon(c(2020, 2100, 2100, 2020), c(0, 0.7, 1.2, 0.1), col=rgb(0.5,0.5,0.5,0.3), border=NA)
dev.off()

# --- 2. Gráfica de Caja ---
pdf("3_post_projection/3_SCC/plot_distribucion_rcp.pdf", width = 8, height = 6)
boxplot(df$global_ce_dmg ~ df$rcp, col = c("lightblue", "orange"),
        main = "Daños por Escenario Climático", ylab = "Daño Global (USD)")
dev.off()

# --- 3. Histograma ---
pdf("3_post_projection/3_SCC/plot_histograma_frecuencia.pdf", width = 8, height = 6)
hist(df$pct_gdp_ce * 100, col = "purple", border = "white",
     main = "Frecuencia de Impactos en el PIB", xlab = "Daño (% del PIB)")
dev.off()

# --- 4. Relación Daño vs PIB ---
pdf("3_post_projection/3_SCC/plot_relacion_dano_pib.pdf", width = 8, height = 6)
plot(df$gdp, df$global_ce_dmg, col = "darkgreen", pch = 19,
     main = "Relación Crecimiento vs Daño", xlab = "PIB Global (USD)", ylab = "Daño USD")
abline(lm(df$global_ce_dmg ~ df$gdp), col = "red", lwd = 2)
dev.off()

cat("\n[OK] ¡Éxito! Las 4 gráficas se guardaron en 3_post_projection/3_SCC/\n")
