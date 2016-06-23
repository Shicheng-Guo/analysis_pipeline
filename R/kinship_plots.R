library(argparser)
library(TopmedPipeline)
library(SNPRelate)
library(GENESIS)
library(gdsfmt)
library(Biobase)
library(ggplot2)
library(dplyr)
sessionInfo()

argp <- arg_parser("Kinship plots")
argp <- add_argument(argp, "config", help="path to config file")
argv <- parse_args(argp)
config <- readConfig(argv$config)

required <- c("kinship_file")
optional <- c("kinship_method"="king",
              "kinship_threshold"=0.04419417, # 2^(-9/2), 3rd degree
              "out_file_all"="kinship_all.pdf",
              "out_file_cross"="kinship_cross_study.pdf",
              "out_file_study"="kinship_within_study.pdf",
              "phenotype_file"=NA,
              "study"=NA)
config <- setConfigDefaults(config, required, optional)
print(config)

## select type of kinship estimates to use (king or pcrelate)
kin.type <- tolower(config["kinship_method"])
kin.thresh <- as.numeric(config["kinship_threshold"])
if (kin.type == "king") {
    king <- getobj(config["kinship_file"])
    kinship <- snpgdsIBDSelection(king, kinship.cutoff=kin.thresh)
    xvar <- "IBS0"
} else if (kin.type == "pcrelate") {
    pcr <- openfn.gds(config["kinship_file"])
    kinship <- pcrelateReadKinship(pcr, kin.thresh=kin.thresh)
    closefn.gds(pcr)
    kinship <- kinship %>%
        rename(kinship=kin) %>%
        select(ID1, ID2, k0, kinship)
    xvar <- "k0"
} else {
    stop("kinship method should be 'king' or 'pcrelate'")
}
message("Plotting ", kin.type, " kinship estimates")

p <- ggplot(kinship, aes_string(xvar, "kinship")) + 
    geom_hline(yintercept=2^(-seq(3,9,2)/2), linetype="dashed", color="grey") +
    geom_point(alpha=0.5) +
    ylab("kinship estimate") +
    theme_bw()
ggsave(config["out_file_all"], plot=p, width=6, height=6)


## plot separately by study
if (is.na(config["phenotype_file"]) | is.na(config["study"])) q("no")
study <- config["study"]
message("Plotting by study variable ", study)

annot <- getobj(config["phenotype_file"])
stopifnot(study %in% varLabels(annot))
annot <- pData(annot) %>%
    select_("sample.id", study)
    
kinship <- kinship %>%
    left_join(annot, by=c(ID1="sample.id")) %>%
    rename_(study1=study) %>%
    left_join(annot, by=c(ID2="sample.id")) %>%
    rename_(study2=study)

kinship.study <- kinship %>%
    filter(study1 == study2) %>%
    rename(study=study1) %>%
    select(-study2)

p <- ggplot(kinship.study, aes_string(xvar, "kinship")) +
    geom_hline(yintercept=2^(-seq(3,9,2)/2), linetype='dashed', color="grey") +
    geom_point(alpha=0.5) +
    facet_wrap(~study) +
    ylab("kinship estimate") +
    theme_bw()
p <- ggsave(config["out_file_study"], plot=p, width=7, height=7)

kinship.cross <- kinship %>%
    filter(study1 != study2)

p <- ggplot(kinship.cross, aes_string(xvar, "kinship", color="study2")) +
    geom_hline(yintercept=2^(-seq(3,9,2)/2), linetype='dashed', color="grey") +
    geom_point() +
    facet_wrap(~study1, drop=FALSE) +
    ylab("kinship estimate") +
    theme_bw()
ggsave(config["out_file_cross"], plot=p, width=8, height=7)
