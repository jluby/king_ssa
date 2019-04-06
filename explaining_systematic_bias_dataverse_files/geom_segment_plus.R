library(proto)
geom_segment_plus <- function (mapping = NULL, data = NULL, stat = "identity",
  position = "identity", arrow = NULL, lineend = "butt", na.rm = FALSE, ...) {
 
  GeomSegmentPlus$new(mapping = mapping, data = data, stat = stat,
    position = position, arrow = arrow, lineend = lineend, na.rm = na.rm, ...)
}
 
GeomSegmentPlus <- proto(ggplot2:::Geom, {
  objname <- "segmentplus"
 
  draw <- function(., data, scales, coordinates, arrow = NULL,
    lineend = "butt", na.rm = FALSE, ...) {
 
    data <- remove_missing(data, na.rm = na.rm,
      c("x", "y", "xend", "yend", "linetype", "size", "shape","shorten.start","shorten.end","offset"),
      name = "geom_segment_plus")
    if (empty(data)) return(zeroGrob())
 
    if (is.linear(coordinates)) {
        data = coord_transform(coordinates, data, scales)
          for(i in 1:dim(data)[1] )
          {
                match = data$xend == data$x[i] & data$x == data$xend[i] & data$yend == data$y[i] & data$y == data$yend[i]
                #print("Match:")
                #print(sum(match))
                if( sum( match ) == 0 ) data$offset[i] <- 0
          }
 
          data$dx = data$xend - data$x
          data$dy = data$yend - data$y
          data$dist = sqrt( data$dx^2 + data$dy^2 )
          data$px = data$dx/data$dist
          data$py = data$dy/data$dist
 
          data$x = data$x + data$px * data$shorten.start
          data$y = data$y + data$py * data$shorten.start
          data$xend = data$xend - data$px * data$shorten.end
          data$yend = data$yend - data$py * data$shorten.end
          data$x = data$x - data$py * data$offset
          data$xend = data$xend - data$py * data$offset
          data$y = data$y + data$px * data$offset
          data$yend = data$yend + data$px * data$offset
         
      return(with(data,
        segmentsGrob(x, y, xend, yend, default.units="native",
        gp = gpar(col=alpha(colour, alpha), fill = alpha(colour, alpha),
          lwd=size * .pt, lty=linetype, lineend = lineend),
        arrow = arrow)
      ))
    }
                print("carrying on")
 
    data$group <- 1:nrow(data)
    starts <- subset(data, select = c(-xend, -yend))
    ends <- rename(subset(data, select = c(-x, -y)), c("xend" = "x", "yend" = "y"),
      warn_missing = FALSE)
   
    pieces <- rbind(starts, ends)
    pieces <- pieces[order(pieces$group),]
   
    GeomPath$draw_groups(pieces, scales, coordinates, arrow = arrow, ...)
  }
 
 
  default_stat <- function(.) StatIdentity
  required_aes <- c("x", "y", "xend", "yend")
  default_aes <- function(.) aes(colour="black", size=0.5, linetype=1, alpha = NA,shorten.start=0,shorten.end=0,offset=0)
  guide_geom <- function(.) "path"
})