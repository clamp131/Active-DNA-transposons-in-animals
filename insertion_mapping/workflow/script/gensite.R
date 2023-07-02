sink(snakemake@log[[1]])
library(tidyverse)

reads_data <- read_tsv(snakemake@input[[1]], col_names = c(
    "id", "dup", "chr",
    "s1", "e1", "str1", "cigar1", "nm1", "length1",
    "s2", "e2", "str2", "cigar2", "nm2", "length2"
), col_types = "cdcddccddddccdd")
cat("input file:", nrow(reads_data), "records.\n")

reads_data <- reads_data %>%
    mutate(insertion = if_else(str2 == "+", s2, e2)) %>%
    group_by(chr, insertion, str2) %>%
    arrange(dup, .by_group = TRUE) %>%
    summarise(
        frag_count = n(),
        max_duplicate = max(dup),
        dup_list = str_c(dup, collapse = ","),
        len1_list = str_c(length1, collapse = ","),
        len2_list = str_c(length2, collapse = ","),
        .groups = "drop"
    )
cat("total breakpoints:", nrow(reads_data), "records.\n")

reads_data <- reads_data %>%
    group_by(chr, str2) %>%
    arrange(insertion, .by_group = TRUE) %>%
    mutate(
        prev_ins = lag(insertion, default = -Inf),
        next_ins = lead(insertion, default = Inf)
    ) %>%
    rowwise() %>%
    mutate(dist = min(insertion - prev_ins, next_ins - insertion)) %>%
    ungroup() %>%
    mutate(valid = max_duplicate > 1 | dist > 100)
cat("close insertions:", sum(reads_data %>% pull(dist) <= 100), "records.\n")
cat("ignored insertions:", sum(!(reads_data %>% pull(valid))), "records.\n")
cat("valid insertions:", sum(reads_data %>% pull(valid)), "records.\n")

reads_data %>%
    filter(valid) %>%
    add_column(name = ".") %>%
    select(chr, start = insertion, end = insertion, name, frag_count, str2, dup_list, len1_list, len2_list) %>%
    write_tsv(snakemake@output$valid, col_names = FALSE)
reads_data %>%
    filter(!valid) %>%
    add_column(name = ".") %>%
    select(chr, start = insertion, end = insertion, name, frag_count, str2, dup_list, len1_list, len2_list) %>%
    write_tsv(snakemake@output$invalid, col_names = FALSE)