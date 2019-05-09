# perlsucks-mmdb-writer
JSON to Perl MMDB Writer for maxmind

This all started when maxmind decided we were some sort of fake company and wouldn't sell us their databases anymore. Well all of our tooling is writen to use their libraries. Found out other peoples data is much more acurate than theirs. So the great github search begins. Find a bunch of examples they are perl I wanna puke. 

One of them is using json to be converted into the db with perl this is much mor resonable for some reason and decide to play with that except it is litere with bugs and doesn't work. 

Thanks to everyone who I stole your code to make this possible I hope others steal from me. shouts to miked <3 for your for loop help.

```bash
sudo apt install cpanminus
sudo cpanm Devel::Refcount MaxMind::DB::Reader::XS MaxMind::DB::Writer::Tree Net::Works::Network GeoIP2 Data::Printer
sudo cpanm MaxMind::DB::Writer::Tree
```

## Validate
we validated it work with another language for this instance itt was node you can install the ncessary modules for that with npm

```bash
npm install mmdb-reader
node reader.js
```

## Usage
```bash
./mmdb-perl.pl -f examples.json -d my-ip-data.mmdb
```
