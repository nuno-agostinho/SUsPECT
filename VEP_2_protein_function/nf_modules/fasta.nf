process linearise_fasta {
  /*
  Linearise FASTA file
  */

  tag "${fasta.baseName}"

  input:
    path fasta

  output:
    path 'linear.fa'

  script:
  """
  sed -e 's/\\(^>.*\$\\)/#\\1#/' $fasta | \
    tr -d "\\r" | \
    tr -d "\\n" | \
    sed -e 's/\$/#/' | \
    tr "#" "\\n" | sed -e '/^\$/d' > linear.fa
  """
}

process get_fasta {
  /*
  Get FASTA sequence for sequences in substitution file
  */

  tag "${subs.baseName}"

  input:
    path fasta
    path subs

  output:
    tuple path('*.fa'), path(subs)

  """
  query=\$(awk '{print \$1}' $subs | uniq)
  grep -A1 \$query $fasta > \$query.fa
  rm $fasta
  """
}
