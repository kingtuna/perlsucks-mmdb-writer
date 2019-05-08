use strict;    #use this all times
use warnings;  #this too - helps a lot!
use JSON;
use Data::Dumper;
use MaxMind::DB::Writer::Tree;

## JSON FILE
my $infile = 'examples.json';

my $json_text = do {
   open(my $json_fh, "<:encoding(UTF-8)", $infile)
      or die("Can't open \$infile\": $!\n");
   local $/;
   <$json_fh>
};

my $json = JSON->new;
my $data = $json->decode($json_text);

## Declare types for database
my %types = (
    service_area => 'utf8_string',
    #dogs  => [ 'array', 'utf8_string' ],
    #size  => 'uint16',
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

for my $record ( @{$data->{'records'}} ) {
  printf("%s %s\n", $record->{'service_area'}, $record->{'address'});
  $tree->insert_network(
    	$record->{'address'},
    	    {
		    service_area => $record->{'service_area'},
		    #dogs  => [ 'Fido', 'Ms. Pretty Paws' ],
		    #size  => 42,
	    },
         );
}

open my $fh, '>:raw', 'my-ip-data.mmdb';
$tree->write_tree($fh);

