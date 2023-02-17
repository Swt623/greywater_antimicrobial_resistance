library(devtools)
install_github("jokergoo/ComplexHeatmap")
library(ComplexHeatmap)

setwd('ARGs/RGI/')

arg_sets <- read.csv(file='ARG_treat_sets_strict.csv', row.names = 1)
arg_sets <- data.matrix(arg_sets)
m = make_comb_mat(arg_sets
                      #, mode = "intersect"
                      )

#UpSet(m, set_order = set_name(m))

sn = set_name(m)
ss = set_size(m)
cs = comb_size(m)
ht = UpSet(m, 
           set_order = order(sn),
           comb_order = order(comb_degree(m), -cs),
           top_annotation = HeatmapAnnotation(
             "ARG Intersections" = anno_barplot(cs, 
                                                  ylim = c(0, max(cs)*1.1),
                                                  border = FALSE, 
                                                  gp = gpar(fill = "black"), 
                                                  height = unit(5, "cm")
             ), 
             annotation_name_side = "left", 
             annotation_name_rot = 90),
           right_annotation = rowAnnotation(
             "ARGs Per House" = anno_barplot(ss,
                                             baseline = 0,
                                             ylim = c(0, max(ss)*1.1),
                                             border = FALSE, 
                                             gp = gpar(fill = "black"), 
                                             width = unit(3, "cm"))
             )
          )
ht=draw(ht)
od = column_order(ht)
decorate_annotation("ARG Intersections", {
  grid.text(cs[od], x = seq_along(cs), y = unit(cs[od], "native") + unit(2, "pt"), 
            default.units = "native", just = c("left", "bottom"), 
            gp = gpar(fontsize = 6, col = "#404040"), rot = 45)
})