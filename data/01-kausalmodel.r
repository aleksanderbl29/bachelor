library(DiagrammeR)

## Tegner simpel kausalmodel
simpel_kausal_model <- grViz("
  digraph {
    rankdir = LR
    graph []
    node [shape = plaintext]
      x [label = 'Vindmølle sættes op']
      y [label = 'Ændring i støtte til borgmesteren']
    edge []
      x -> y
  }
")

## Tegner fuld kausalmodel
parti_kausal_model <- grViz("
  digraph {
    rankdir = TB
    graph []
    node [shape = plaintext]
      x [label = 'Vindmølle sættes op']
      yp [label = 'Flere stemmer til borgmesterparti']
      yn [label = 'Færre stemmer til borgmesterparti']
      fra [label = 'Borgmester er fra']
      b [label = 'Blå blok']
      r [label = 'Rød blok']
      v [label = 'Venstre']
      s [label = 'Socialdemokratiet']
    edge []
      x -> fra
      fra -> {b r v s}
      {b v} -> yn
      {r s} -> yp
  }
")
