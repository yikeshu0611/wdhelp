#' install
#'
#' @param token token
#'
#' @return install
#' @export
#'
install_wdR <- function(token){
    e <- tryCatch(detach("package:wdR", unload = TRUE),error=function(e) 'e')
    # check
    (td <- tempdir(check = TRUE))
    td2 <- '1'
    while(td2 %in% list.files(path = td)){
        td2 <- as.character(as.numeric(td2)+1)
    }
    (dest <- paste0(td,'/',td2))
    do::formal_dir(dest)
    dir.create(path = dest,recursive = TRUE,showWarnings = FALSE)
    (tf <- paste0(dest,'/wdR.zip'))

    if (do::is.windows()){
        download.file(url = 'https://codeload.github.com/yikeshu0611/wdR_win/zip/refs/heads/main',
                      destfile = tf,
                      mode='wb',
                      headers = c(NULL,Authorization = sprintf("token %s",token)))
        unzip(zipfile = tf,exdir = dest,overwrite = TRUE)
    }else{
        download.file(url = 'https://codeload.github.com/yikeshu0611/wdR_mac/zip/refs/heads/main',
                      destfile = tf,
                      mode='wb',
                      headers = c(NULL,Authorization = sprintf("token %s",token)))
        unzip(zipfile = tf,exdir = dest,overwrite = TRUE)
    }



    if (do::is.windows()){
        main <- paste0(dest,'/wdR_win-main')
        (wdR <- list.files(main,'wdR_',full.names = TRUE))
        (wdR <- wdR[do::right(wdR,3)=='zip'])
        (k <- do::Replace0(wdR,'.*wdR_','\\.zip','\\.tgz','\\.') |> as.numeric() |> which.max())
        unzip(wdR[k],files = 'wdR/DESCRIPTION',exdir = main)
    }else{
        main <- paste0(dest,'/wdR_mac-main')
        wdR <- list.files(main,'wdR_',full.names = TRUE)
        wdR <- wdR[do::right(wdR,3)=='tgz']
        k <- do::Replace0(wdR,'.*wdR_','\\.zip','\\.tgz','\\.') |> as.numeric() |> which.max()
        untar(wdR[k],files = 'wdR/DESCRIPTION',exdir = main)
    }

    (desc <- paste0(main,'/wdR'))
    check_package(desc)

    install.packages(pkgs = wdR[k],repos = NULL,quiet = FALSE)
    message('Done(wdR)')
    x <- suppressWarnings(file.remove(list.files(dest,recursive = TRUE,full.names = TRUE)))
    invisible()
}


