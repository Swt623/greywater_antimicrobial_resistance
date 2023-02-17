library(ComplexHeatmap)

setwd('MGEs/MGEs_mefinder_output/MGElists')
file = 'MGE_treat_qcd.csv'

data = read.csv(file, header=TRUE)
vdata = as.vector(data)

lt = list(house_1_raw = vdata$house_1_raw[!vdata$house_1_raw ==""], 
          house_2_raw = vdata$house_2_raw[!vdata$house_2_raw ==""],
          house_3_raw = vdata$house_3_raw[!vdata$house_3_raw ==""],
          house_4_raw = vdata$house_4_raw[!vdata$house_4_raw ==""],
          house_5_raw = vdata$house_5_raw[!vdata$house_5_raw ==""])

lt = list(house_1_treat = vdata$house_1_treat[!vdata$house_1_treat ==""], 
          house_2_treat = vdata$house_2_treat[!vdata$house_2_treat ==""],
          house_3_treat = vdata$house_3_treat[!vdata$house_3_treat ==""],
          house_4_treat = vdata$house_4_treat[!vdata$house_4_treat ==""],
          house_5_treat = vdata$house_5_treat[!vdata$house_5_treat ==""])

m = make_comb_mat(list_to_matrix(lt))

sn = set_name(m)
ss = set_size(m)
cs = comb_size(m)
ht = UpSet(m, 
           set_order = order(sn),
           comb_order = order(comb_degree(m), -cs),
           top_annotation = HeatmapAnnotation(
             "MGE Intersections" = anno_barplot(cs, 
                                                ylim = c(0, max(cs)*1.1),
                                                border = FALSE, 
                                                gp = gpar(fill = "black"), 
                                                height = unit(5, "cm")
             ), 
             annotation_name_side = "left", 
             annotation_name_rot = 90),
           right_annotation = rowAnnotation(
             "MGEs Per House" = anno_barplot(ss,
                                             baseline = 0,
                                             ylim = c(0, max(ss)*1.1),
                                             border = FALSE, 
                                             gp = gpar(fill = "black"), 
                                             width = unit(3, "cm"))
           )
)
ht=draw(ht)
od = column_order(ht)
decorate_annotation("MGE Intersections", {
  grid.text(cs[od], x = seq_along(cs), y = unit(cs[od], "native") + unit(2, "pt"), 
            default.units = "native", just = c("left", "bottom"), 
            gp = gpar(fontsize = 6, col = "#404040"), rot = 45)
})