library(DiagrammeR)

## Tegner simpel kausalmodel
grViz("
  digraph {
    rankdir = LR
    graph []
    node [shape = plaintext]
      X [label = 'Vindmølle sættes op']
      Y [label = 'Borgmesterparti mindsker tilslutning']
    edge []
      X -> Y
  }
")

## Tegner fuld kausalmodel
grViz("
  digraph {
    graph []
    node [shape = plaintext]
      X [label = 'Vindmølle sættes op']
      Y [label = 'Borgmesterparti mindsker tilslutning']
      Y2 [label = 'Borgmesterparti ser ingen ændring i tilslutning']
      Z [label = 'Husejer?']
      Z2 [label = 'Indflydelse på projekt?']
    edge []
      X -> Z
      X -> Z2
      Z -> {Y Y2}
      Z2 -> {Y Y2}
  }
")