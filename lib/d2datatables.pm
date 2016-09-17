package d2datatables;
use Dancer2;
use Dancer2::Plugin::Database;
use Data::Dumper;
use 5.22.0;

use strict;
use warnings;

our $VERSION = '0.1';

get '/' => sub {
    template 'index';
};

get '/demo01' => sub {

  my $sth = database->prepare(
        'select * from invoices',
      );
  $sth->execute() or die $sth->errstr;

  my $fields = $sth->{NAME};
  my $invoices = $sth->fetchall_arrayref({});

  
  template 'demo01',
    { title => 'demo01',
      fields => $fields,
      invoices => $invoices,
    };
};

get '/demo02' => sub {

  my $sth = database->prepare(
        'select * from invoices',
      );
  $sth->execute() or die $sth->errstr;

  my $fields = $sth->{NAME};
  my $invoices = $sth->fetchall_arrayref({});

  
  template 'demo02',
    { title => 'demo02',
      fields => $fields,
      invoices => $invoices,
    };
};

get '/api/demo03' => sub {
# return query as JSON
  my $sth = database->prepare(
        'select * from invoices',
      );
  $sth->execute() or die $sth->errstr;

  my $fields = $sth->{NAME};
  my $invoices = $sth->fetchall_arrayref({});

  
  send_as JSON => { columns => [
    { data => 'InvoiceId'},
    { data => 'InvoiceDate'},
    { data => 'CustomerId' },
    { data => 'BillingAddress'}
      ],
    data => $invoices,
  };
};


get '/demo03' => sub {
  template 'demo03', {
    title => 'demo03',
    json_data_url => '/api/demo03',
  };
};



true;
