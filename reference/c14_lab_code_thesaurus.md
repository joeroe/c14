# Radiocarbon laboratory code thesaurus

A thesaurus of canonical (matching those given in
[c14_labs](https://c14.joeroe.io/reference/c14_labs.md)) radiocarbon
laboratory codes and variants of these codes observed in various
published datasets.

## Usage

``` r
c14_lab_code_thesaurus
```

## Format

A data frame with 688 rows and 2 variables:

- canon:

  Character. The preferred code for the laboratory.

- variant:

  Character. Variant codes.

## Details

The thesaurus aims to be precise and conservative. That is, canonical
forms are only given for variants when they can be unambiguously
interpreted as that of a known laboratory listed in
[c14_labs](https://c14.joeroe.io/reference/c14_labs.md). It is case
sensitive, because there are laboratory codes that can only be
distinguished by case (see
[c14_labs](https://c14.joeroe.io/reference/c14_labs.md) for examples).

Variants that cannot (or have not yet) been unambiguously matched to a
known, standard lab code have a `canon` value of `NA`.
