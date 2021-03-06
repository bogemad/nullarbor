package Nullarbor_it::Module::identification;
use Moo;
extends 'Nullarbor_it::Module';

#...........................................................................................

my $PASS_THRESH = 80;
my $OK_THRESH = 65;

#...........................................................................................

sub name {
  return "Species identification";
}

#...........................................................................................

sub html {
  my($self) = @_;
  
  sub trim { 
    my($s) = @_; 
    $s =~ s/^\s+//; 
    $s =~ s/\s+$//; 
    return $s; 
  }

  sub font_prop {
    my($text, $p) = @_;
    return $text if !defined($p) or $p !~ m/^\d/;
    my $extra = $p > 0.5 ? " font-weight: bold;" : "";
#    my $i = int( 60 * (1-$p) );
#    my $color = "rgb($i%,$i%,$i%)";
    my $color = $p < 0.01 ? "lightgray" : $p < 0.10 ? "gray" : "black";
    return "<SPAN STYLE='color: $color;$extra'>$text</SPAN>";
  }

  my $NM = 4;  # show the top NM species matches in the kraken output
  my @spec;
  push @spec, [ 'Isolate', (map { ("#$_ Match", "%") } (1.. $NM)), "Quality" ];
  for my $id (@{$self->isolates}) {
    my $t = Nullarbor_it::Tabular::load(-file=>$self->indir."/$id/kraken.tab", -sep=>"\t");
    # sort by proportion
    map { $_->[0] =~ s/%$// } @$t; # remove % sign kraken1 = 'xx.xx', kraken2 = 'xx.xx%'
    my @s = sort { $b->[0] <=> $a->[0] } (grep { $_->[3] =~ m/^[US]$/ } @$t);
    push @spec, [ 
      $id, 
      (map { 
        font_prop( "<span class='binomial'>".trim($s[$_][5] || 'None')."</span>", ($s[$_][0] || 0)/100.0 ),
        font_prop( trim($s[$_][0] || '-'), ($s[$_][0] || 0)/100.0 )
       } (0 .. $NM-1)),
      $self->pass_fail( $s[0][3] eq 'U' || $s[0][0] < $OK_THRESH ? -1 : $s[0][0] < $PASS_THRESH ? 0 : +1 ),
    ];  # _italics_ taxa names
  }
#  print Dumper(\@spec);

  return $self->table_legend("&ge;${PASS_THRESH}%", "&ge;${OK_THRESH}%", "<${OK_THRESH}%")
        .$self->matrix_to_html(\@spec);
}

#...........................................................................................

1;
