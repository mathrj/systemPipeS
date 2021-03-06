

# Take steps output from subsetRmd and change to a nested list structure
# t_lvl: positive integers, vector, levels of all title levels in Rmd
# t_text: character strings, vector, text of titles
# start_lvl: integer, default value is 0, but default level is 1 (0 + 1). level to start to create list
# return: a nested list
step2listTree <- function(t_lvl, t_text, start_lvl = 0){
    if (t_lvl %>% unique() %>% length == 1){
        tmp_lst <- list()
        for (i in t_text){
            tmp_lst[[as.character(i)]] <- ""
        }
        return(tmp_lst)
    }
    start_lvl <- start_lvl + 1
    t_index <- which(t_lvl == start_lvl)
    if (!length(t_index) == 0){
        tmp_lst <- list()
        for (i in seq_along(t_index)){
            t_index <- c(t_index, length(t_lvl) + 1)
            if_children <- t_index[i]  + 1 == t_index[i+1]
            if (is.na(if_children) | if_children) {
                tmp_lst[[t_text[t_index[i]]]] <- ""
            } else {
                children_lvl <- t_lvl[(t_index[i] + 1): (t_index[i + 1] -1)]
                children_name <- t_text[(t_index[i] + 1): (t_index[i + 1] -1)]
                tmp_lst[[t_text[t_index[i]]]] <- step2listTree(children_lvl, children_name, start_lvl)
            }
        }
        return(tmp_lst)
    } else {return("")}
}

# tree = step2listTree(t_lvl, t_text)
# str(tree)
# 
# tree_names = names(unlist(tree))
# 
# ui = shinyUI(
#     pageWithSidebar(
#         mainPanel(
#             shinyTree("tree", stripes = TRUE, multiple = FALSE, animation = FALSE)
#         )
#     ))
# server = shinyServer(function(input, output, session) {
#     output$tree <- renderTree({
#         tree
#     })
# })
# shinyApp(ui, server)


# find parent steps of from output of jsTree

findTreeParent <- function(step_names){
    lapply(step_names, function(each_name){
        if (str_detect(each_name, "\\.")) {
            step_p <- str_remove(step_names, "[^0-9]+.[^.]*$")
            tmp_holder <- c(step_p, findTreeParent(step_p))
            return(c(step_names, tmp_holder))
        } else {return(each_name)}
    }) %>%
    unlist() %>%
    unique() %>% str_sort(numeric = TRUE)
}
# step_name <- c("1.1.1", "2.2.2")
# findTreeParent(step_name)


# for networkD3
step2listD3 <- function(t_lvl, t_text, start_lvl = 0){
    findChildren <- function(t_lvl, t_text, start_lvl){
        start_lvl <- start_lvl + 1
        t_index <- which(t_lvl == start_lvl)
        if (!length(t_index) == 0){
            tmp_lst <- lapply(seq_along(t_index), function(i){
                t_index <- c(t_index, length(t_lvl) + 1)
                children_lvl <- t_lvl[(t_index[i] + 1) : (t_index[i+1] - 1)]
                children_name <- t_text[(t_index[i] + 1) : (t_index[i+1] - 1)]
                list(name =  t_text[t_index[i]], children = findChildren(children_lvl, children_name, start_lvl))
            })
            return(tmp_lst)
        } else { return(list(name = ""))}
    }
    if (t_lvl %>% unique() %>% length == 1){
        tmp_lst = list()
        for (i in t_text){
            tmp_lst <- append(tmp_lst, list(list(name = i, children = list(name = ""))))
        }
        return(list(name = "File", children = tmp_lst))
    }
    return(list(name = "File", children = findChildren(t_lvl, t_text, start_lvl)))
}

# t_lvl = c(1, 2, 1, 2, 2, 3)
# t_text = c('1', '1.1', '2', '2.1', '2.2', '2.2.1')
# test = step2listD3(a$t_lvl, paste(a$t_number, a$t_text))
# str(test)
# diagonalNetwork(test)




