#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use Survey;

my $s = eval { Survey->new };
ok((defined $@ and length $@), 'Cannot run without filename');
is($s, undef);

$s = eval { Survey->new('"') };
ok((defined $@ and length $@), 'File not found');
is($s, undef);

$s = eval { Survey->new('t/003-d.txt') };
like($@, qr/Duplicate/, 'Duplicate id');
is($s, undef);

$s = eval { Survey->new('t/003-q.txt') };
like($@, qr/Cannot start question/, 'Question in question');
is($s, undef);

$s = eval { Survey->new('t/003-aa.txt') };
like($@, qr/Cannot start answer/, 'Answer in answer');
is($s, undef);

$s = eval { Survey->new('t/003-aaf.txt') };
like($@, qr/Cannot start answer/, 'Answer in fold');
is($s, undef);

$s = eval { Survey->new('t/003-a.txt') };
like($@, qr/Cannot start answer/, 'Answer without question');
is($s, undef);

$s = eval { Survey->new('t/003-an.txt') };
like($@, qr/Cannot put answers/, 'Answer in none');
is($s, undef);

$s = eval { Survey->new('t/003-aq.txt') };
like($@, qr/Cannot put answers/, 'Answer in question');
is($s, undef);

$s = eval { Survey->new('t/003-i.txt') };
like($@, qr/Invalid line/, 'Invalid line');
is($s, undef);

$s = eval { Survey->new('t/003-c.txt') };
like($@, qr/Impossible incompatibility/, 'Self incompatibility');
is($s, undef);

$s = eval { Survey->new('t/003-cm.txt') };
is(ref $s, 'Survey', 'Example loaded');
is(@{ $s->shake(1) }, 1, 'No incompatibility');
my $x = eval { $s->shake(2) };
like($@, qr/Not enough/, 'Not enough compatible questions');
is($x, undef, 'No questions generated');

$s = Survey->new('t/003-c0.txt');
ok(exists $s->{2}{incompatible}{1}, 'Incompatibilities fixed');

# Test real data loading

$s = eval { Survey->new('anketa.txt') };
is(ref $s, 'Survey', 'Real data loaded');

done_testing();
