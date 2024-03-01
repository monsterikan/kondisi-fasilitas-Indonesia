library(dplyr)
library(tidyverse)
library(stringr)

df1 <- read.csv("~/Tugas Akhir/kondisi_kelas_all.csv")
df2 <- read.csv("~/Tugas Akhir/kondisi_lab_all.csv")
df3 <- read.csv("~/Tugas Akhir/kondisi_perpus_all.csv")
df4 <- read.csv("~/Tugas Akhir/kondisi_toliet_guru_l_all.csv")
df5 <- read.csv("~/Tugas Akhir/kondisi_toliet_guru_p_all.csv")
df6 <- read.csv("~/Tugas Akhir/kondisi_uks_all.csv")
df7 <- read.csv("~/Tugas Akhir/kondisi_toliet_murid_l_all.csv")
df8 <- read.csv("~/Tugas Akhir/kondisi_toliet_murid_p_all.csv")
provinsi_lj <- read.csv("~/Tugas Akhir/l-join-provi.csv")

df_all <- df1 %>%
  left_join(df2, c = "Kecamatan") %>%
  left_join(df3, c = "Kecamatan") %>% 
  left_join(df4, c = "Kecamatan") %>%
  left_join(df5, c = "Kecamatan") %>%
  left_join(df6, c = "Kecamatan") %>%
  left_join(df7, c = "Kecamatan") %>%
  left_join(df8, c = "Kecamatan")

## df_trim <- df_all[,c(1, 2, 3, 4, 7, 8, 9, 10, 13, 14, 15, 16, 19, 20, 21, 22, 25, 26, 27, 28, 30, 31, 33, 34, 37, 38, 39, 40, 43)]
df_trim <- df_all[,c(1,2,3,4,8,9,10,14,15,16,20,21,22,26,27,28,32,33,34,38,39,40,44,45,46)]

df_trim$Kab.Kota <- sub(".*Kab. ", "", df_trim$Kecamatan)
df_trim$Kab.Kota <- sub(".*Kota ", "", df_trim$Kab.Kota)
df_trim$Kecamatan <- sub("Kab.*", "", df_trim$Kecamatan)
df_trim$Kecamatan <- sub("Kota.*", "", df_trim$Kecamatan)

df_trim <- df_trim %>% 
  relocate(Kab.Kota, .before = Kelas.Baik)

df_trim$Kelas.Rusak <- df_trim$Kelas.Rusak.Ringan + df_trim$Kelas.Rusak.Sedang
df_trim$Lab.Rusak <- df_trim$Lab.Rusak.Ringan + df_trim$Lab.Rusak.Sedang
df_trim$Perpus.Rusak <- df_trim$Perpus.Rusak.Ringan + df_trim$Perpus.Rusak.Sedang
df_trim$Toilet.Guru.L.Rusak <- df_trim$Toilet.Guru.L.Rusak.Ringan + df_trim$Toilet.Guru.L.Rusak.Sedang
df_trim$Toilet.Guru.P.Rusak <- df_trim$Toilet.Guru.P.Rusak.Ringan + df_trim$Toilet.Guru.P.Rusak.Sedang
df_trim$UKS.Rusak <- df_trim$UKS.Rusak.Ringan + df_trim$UKS.Rusak.Sedang
df_trim$Toilet.Murid.L.Rusak <- df_trim$Toilet.Murid.L.Rusak.Ringan + df_trim$Toilet.Murid.L.Rusak.Sedang
df_trim$Toilet.Murid.P.Rusak <- df_trim$Toilet.Murid.P.Rusak.Ringan + df_trim$Toilet.Murid.P.Rusak.Sedang

df_trim$Toilet.Baik <- df_trim$Toilet.Guru.L.Baik + + df_trim$Toilet.Guru.P.Baik + df_trim$Toilet.Murid.L.Baik + df_trim$Toilet.Murid.P.Baik
df_trim$Toilet.Rusak <- df_trim$Toilet.Guru.L.Rusak + df_trim$Toilet.Guru.P.Rusak + df_trim$Toilet.Murid.L.Rusak + df_trim$Toilet.Murid.P.Rusak


df_clean <- df_trim[,c(1,2,3,27,6,28,9,29,18,32,35,36)]

df_clean <- left_join(df_clean, provinsi_lj, by="Kab.Kota")

df_clean <- df_clean %>% 
  relocate(Provinsi, .before = Kelas.Baik)

df_clean$Kelas.RusakPerc <- round(df_clean$Kelas.Rusak / (df_clean$Kelas.Rusak + df_trim$Kelas.Baik), digits = 2)
df_clean$Lab.RusakPerc <- round(df_clean$Lab.Rusak / (df_clean$Lab.Rusak + df_trim$Lab.Baik), digits = 2)
df_clean$UKS.RusakPerc <- round(df_clean$UKS.Rusak / (df_clean$UKS.Rusak + df_trim$Lab.Baik), digits = 2)
df_clean$Perpus.RusakPerc <- round(df_clean$Perpus.Rusak / (df_clean$Perpus.Rusak + df_trim$Perpus.Baik), digits = 2)
df_clean$Toilet.RusakPerc <- round(df_clean$Toilet.Rusak / (df_clean$Toilet.Rusak + df_trim$Toilet.Baik), digits = 2)

df_non_perc <- df_clean[,c(1,2,3,4,5,6,7,8,9,10,11,12,13)]
df_perc <- df_clean[,c(1,2,3,14,15,16,17,18)]

df_perc[is.na(df_perc)] <- 0

df_perc_2 <- df_perc %>%
  rowwise() %>% 
  filter(sum(c_across(Kelas.RusakPerc:Toilet.RusakPerc)) != 0.00)

df_perc_2 <- df_perc_2 %>%
  rowwise() %>% 
  filter(mean(c_across(Kelas.RusakPerc:Toilet.RusakPerc)) != 1.00)

df_perc_3 <- df_perc %>%
  rowwise() %>% 
  filter(sum(c_across(Kelas.RusakPerc:Toilet.RusakPerc)) == 0.00)

df_perc_4 <- df_perc %>%
  rowwise() %>% 
  filter(mean(c_across(Kelas.RusakPerc:Toilet.RusakPerc)) == 1.00)

df_calc1 <- subset(df_trim, select=-c(Kecamatan, Kab.Kota))

df_calc1 <- df_calc1 %>%
  summarise_all(sum)

df_calc1 <-as.data.frame(t(df_calc1))
df_calc1$Col.num <- seq.int(nrow(df_calc1))

write.csv(df_calc1,"table-b-edit.csv")

df_calc <- subset(df_trim, select=-c(Kecamatan, Kab.Kota))

df_calc <- df_calc %>%
  summarise_all(sum)

df_calc <-as.data.frame(t(df_calc))
df_calc$Col.num <- seq.int(nrow(df_calc))

write.csv(df_calc,"table-1-edit.csv")

df_calc <- subset(df_all, select=-c(Kecamatan)) 

df_calc <- df_calc %>%
summarise_all(sum)

df_calc <-as.data.frame(t(df_calc))
df_calc$Col.num <- seq.int(nrow(df_calc))

write.csv(df_calc, "table_ak.csv")
write.csv(df_non_perc, "kondisi_fasilitas_SMA-Indonesia.csv")
write.csv(df_perc, "kondisi_kerusakan_perc-Indonesia.csv")
write.csv(df_perc_2, "kondisi_kerusakan_perc_2-Indonesia.csv")
write.csv(df_perc_4, "kondisi_rusak_total-Indonesia.csv")
write.csv(df_perc_3, "kondisi_baik_total-Indonesia.csv")

### df1$Kab.Kota <- sub(".*Kab. ", "", df1$Kecamatan)
### df1$Kab.Kota <- sub(".*Kota ", "", df1$Kab.Kota)
### df1$Kecamatan <- sub("Kab.*", "", df1$Kecamatan)
### df1$Kecamatan <- sub("Kota.*", "", df1$Kecamatan)

