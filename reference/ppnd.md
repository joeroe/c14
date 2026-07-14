# Radiocarbon dates from Neolithic Southwest Asia

A dataset of 1049 radiocarbon dates from Epipalaeolithic and Neolithic
sites in Southwest Asia, compiled by Marion Benz in the [Platform for
Neolithic Radiocarbon
Dates](https://www.exoriente.org/associated_projects/ppnd.php) (PPND).

## Usage

``` r
ppnd
```

## Format

A data frame with 1049 rows and 10 variables:

- lab_id:

  Character. Laboratory code and ID of the dated sample.

- site:

  Character. Name of the site from which the sample was retrieved.

- latitude, longitude:

  Double. Coordinates of the site.

- context:

  Character. Description of the context from which the sample was
  retrieved.

- cra:

  Integer. Conventional radiocarbon age (CRA) of the sample Before
  Present.

- error:

  Integer. Error associated with the radiocarbon measurement.

- d13c:

  Character. d13C measurement and error (separated by a plus/minus
  symbol) associated with the sample.

- material:

  Character. Description of the sample material.

- references:

  Character. Bibliographic reference associated with the sample. See
  bibliography at
  <https://www.exoriente.org/associated_projects/ppnd_references.php>.

## Source

<https://www.exoriente.org/associated_projects/ppnd.php> (Retrieved
2018-04-02)
