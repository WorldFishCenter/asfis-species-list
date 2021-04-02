README
================

This repo contains matches the species from the [Illuminating hidden
harvest](https://fish.cgiar.org/research-areas/projects/illuminating-hidden-harvests)
project to their corresponding FAO ISSCAAP codes.

The species lists can be found in [data/raw/IHH\_species\_list.csv]().
The species lists with the corresponding codes (the primary output of
this repo) can be found in
[data/processed/species\_list\_isscaap.csv]().

## Data sources

  - The 2020 version of the ASFIS List of Species for Fishery Statistics
    Purposes which can be downloaded from:
    [http://www.fao.org/fishery/collection/asfis/en]()
  - The FAOSTAT division table which can be accessed at
    [https://github.com/openfigis/RefData/tree/gh-pages/species]()

## Approach

1.  Match species by their binomial name. If that fails…
2.  Match species by their genus. The ASFIS list of species indicates
    the ISSCAAP group code for some species at the genus level. E.g.
    *Ictiobus spp* is recorded in the list ASFIS list as the specific
    name under code 11 (Carps, barbels and other cyprinids / Freshwater
    fishes). This indicates that species in the *Ictiobus* genus not
    recorded in the list in the binomial form can be assigned to that
    ISSCAAP code. If that fails…
3.  If all the species from a genus in the ASFIS list belong to the
    ISSCAAP group code is possible to assume that other species in the
    genus can be classified under the same group code. This is not
    warranted and is indicated as a flag in the output dataset. If that
    fails…
4.  I repeat the last two steps but using the genus obtained from the
    binomial name rather than the one in the genus column. These do not
    match in all cases usually because the taxonomy has changed and the
    species has been assigned a new name. For instance *Pseudograpsus
    setosus* was previously known as *Cancer setosus* and the later is
    the name found in the IHH list. If this fails…
5.  I repeat step 3 but using family instad of genus as the taxa to be
    matched. If that fails…
6.  I cannot match the species in the IHH species list to an ISSCAAP
    code automatically.

## Resluts

The IHH list contains 2135 species names. From those, 1712 were matched
using the binomial name, 412 were matched using derived genus or family
info, and it was not possible to match 11 species.

Specifically *Aristaeopsis edwardsiana, Glaucostegus cemiculus,
Hemigrapsus crenulatus, Megastraea undosa, Metopograpsus messor, Mysis
diluviana, Parasesarma erythodactylum, Platyxanthus orbignyi, Taliepus
dentatus, Taliepus marginatus , Tubifex tubifex* were not found in the
ASFIS species list and the equivalent code might need to be manually
assigned.

## Reproduce the results

To reproduce the results run `targets::tar_make()` from the R console or
`make` from the bash terminal. The `Dockerfile` can be used to set up
the computing environment required to run the code.
