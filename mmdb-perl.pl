use strict;      #use this all times
use warnings;    #this too - helps a lot!
use JSON;
use MaxMind::DB::Writer::Tree;
use Getopt::Long;

my $help = 0;
my $infile;
my $outfile = 'my-ip-data.mmdb';

GetOptions( "file=s" => \$infile, "db=s" => \$outfile, 'help|?' => \$help, )
  or &help();
&help() if $help;
&help() if not defined $infile;

my $json_text = do {
    open( my $json_fh, "<:encoding(UTF-8)", $infile )
      or die("Can't open '$infile': $!\n");
    local $/;
    <$json_fh>;
};

my $json = JSON->new;
my $data = $json->decode($json_text);

## Declare types for database
my %types = (
    service_area => 'utf8_string',
    #array  => [ 'array', 'utf8_string' ],
    #int  => 'uint16',
);

# databse info
my $tree = MaxMind::DB::Writer::Tree->new(
    ip_version            => 6,
    record_size           => 24,
    database_type         => 'My-IP-Data',
    languages             => ['en'],
    description           => { en => 'My database of IP data' },
    map_key_type_callback => sub { $types{ $_[0] } },
);

for my $record ( @{ $data->{'records'} } ) {
    printf( "%s %s\n", $record->{'service_area'}, $record->{'address'} );
    $tree->insert_network(
        $record->{'address'},
        {
            service_area => $record->{'service_area'},
            #arraything  => [ 'one string', 'two string' ],
		    #numberthing  => 33,
        },
    );
}

open my $fh, '>:raw', $outfile;
$tree->write_tree($fh);

sub help {
    print "Usage: $0 -f file.json -d my-ip-data.mmdb\n";
    print 'Example json:
{
  "records": [
    {
      "address": "6.6.6.6/28",
      "service_area": "LAX"
    }
  ]
}' . "\n";
    exit;
};
