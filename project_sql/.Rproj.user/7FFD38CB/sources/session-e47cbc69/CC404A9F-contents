library(here)
library(tidyverse)
library(scales)
library(showtext)
library(vroom)
# Nice font
#font_add_google("Inter", "inter"); showtext_auto()
png(filename=here("figures/01_compensation_by_job.png"),width = 2000,height = 1000)
ggplot(vroom(here("csv/01_table.csv")) %>% 
         slice_max(mean_salary, n = 20, with_ties = FALSE) %>% 
         mutate(level = factor(level, levels = c("Other", "Junior","Associate","Senior","Manager","Principal","Head","Director"))) %>% 
         mutate(job_title = forcats::fct_reorder(job_title, mean_salary, .desc = FALSE)),
       aes(x = mean_salary,
           y = job_title, 
           fill = level)) +
  geom_segment(aes(x = 0, xend = mean_salary, yend = job_title),
               linewidth = 1, color = "black") +
  geom_point(size = 8, shape = 21, color = "black") +
  scale_x_continuous(
    labels = label_dollar(),
    breaks = breaks_pretty(n = 3),
    expand = expansion(mult = c(0,.1))
  ) +
  colorspace::scale_fill_discrete_qualitative(
    palette = "Dark2",
    name = "Experience level"   # legend title (optional)
  ) +
  labs(
    title = "Compensation by Job",
    #subtitle = "Color-coded by job experience",
    x = "Yearly salary",
    y = NULL,
    caption = "Source: job_postings_fact"
  ) +
  guides(
    fill = guide_legend(
      direction = "horizontal", # lay out keys in a row
      nrow = 1,
      byrow = TRUE,
      title.position = "top",
      title.hjust = 0,
      override.aes = list(      # make legend keys look like your points
        shape = 21, size = 16 ,
        colour = "grey20", stroke = 1
      )
    )
  ) +
  theme_minimal(base_family = "inter") +
  theme(
    plot.title      = element_text(face = "bold", size = 32, color = "grey15"),
    plot.subtitle   = element_text(size = 24, color = "grey35"),
    axis.text       = element_text(size = 22, color = "grey20"),
    axis.title.x    = element_text(size = 22, color = "grey20"),
    panel.grid.minor= element_blank(),
    panel.grid.major.y = element_blank(),
    panel.grid.major.x = element_line(linetype = "dashed", linewidth = 0.8, color = "grey70"),
    plot.margin     = margin(12, 18, 12, 12),
    legend.position = "top",         # put legend above the panel
    legend.justification = "left",   # left-align under the title
    legend.box.just = "left",
    legend.box = "horizontal",
    legend.title = element_text(face = "bold", size = 20, colour = "grey25"),
    legend.text  = element_text(size =  20, colour = "grey25"),
    legend.key.width  = unit(20, "pt"),
    legend.key.height = unit(20, "pt"),
    legend.box.margin = margin(0, 0, 0, 0)   # spacing around the legend
  )
dev.off()
 
