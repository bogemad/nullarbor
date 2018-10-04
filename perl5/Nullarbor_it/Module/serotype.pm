package Nullarbor_it::Module::serotype;
use Moo;
extends 'Nullarbor_it::Module';

use List::Util qw(sum);

#...........................................................................................

sub name {
  return "Serotyping";
}

#...........................................................................................

sub html {
  my($self) = @_;
  my $indir = $self->indir;

  my $fn = "$indir/serotype.tab"; 
  return unless -r $fn;

  my $tab = Nullarbor_it::Tabular::load(-file=>$fn, -sep=>"\t", -header=>1);

  $tab->[0][0] = 'Isolate';
  map { $_->[0] =~ s{/contigs.fa}{} } @$tab;
  push @{$tab->[0]}, "Quality";
  
  for my $index (1 .. $#$tab) {
    my $row = $tab->[$index];
    my $missing = sum( map { $row->[$_] eq '-' ? 1 : 0 } (1 .. $#$row) );
    push @$row, $self->pass_fail( $missing==0 ? +1 : $missing==1 ? 0 : -1 );
  }
  
  return $self->matrix_to_html($tab); 
}

#...........................................................................................

1;

