## UI
rightUI <- function(id){
    ns <- NS(id)
    uiOutput(ns("right_bar"))
}

## server
rightServer <- function(input, output, session, shared){
    ns <- session$ns
    observeEvent(TRUE, {
        output$right_bar <- renderUI({
            boxPlus(title = "Workflow Status", width = 12, closable = FALSE, solidHeader = TRUE,
                    timelineBlock( reversed = FALSE,
                                   timelineEnd(icon = "hourglass-start", color = "olive"), 
                                   timelineItem(
                                       title = "Select Targets",
                                       icon = check_right_icon(shared$wf_flags$targets_ready),
                                       color =  check_right_color(shared$wf_flags$targets_ready), 
                                       border = FALSE
                                   ),
                                   timelineItem(
                                       title = "Select Workflow",
                                       icon = check_right_icon(shared$wf_flags$wf_ready),
                                       color = check_right_color(shared$wf_flags$wf_ready), 
                                       border = FALSE
                                   ),
                                   
                                   timelineItem(
                                       title = "Workflow Configure",
                                       icon = check_right_icon(shared$wf_flags$wf_conf_ready),
                                       color = check_right_color(shared$wf_flags$wf_conf_ready), 
                                       border = FALSE
                                   ),
                                   timelineLabel("Ready to run", color = if (shared$wf_flags %>% as.logical() %>% all()) "olive" else "orange"),
                                   timelineStart(color = "gray", icon = "check")
                    )
            )
        })
    })
}

check_right_icon <- function(bool = FALSE){
    if (bool) return("check") else return("times")
}

check_right_color <- function(bool = FALSE){
    if (bool) return("olive") else return("red")
}

