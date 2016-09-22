package d2datatables;
use Dancer2;
use Dancer2::Plugin::Database;
use Data::Dumper;
use 5.22.0;

use JSON;
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
    title => 'demo03 JSON API',
    json_data_url => '/api/demo03',
  };
};

get '/api/demo04' => sub {
# return query as JSON with buttons
  my $sth = database->prepare(
        'select * from invoices',
      );
  $sth->execute() or die $sth->errstr;

  my $fields = $sth->{NAME};
  my $invoices = $sth->fetchall_arrayref({});

  
  send_as JSON => { columns => [
    { className => 'dt-right', data => 'InvoiceId',      },
    { className => 'dt-left',  data => 'InvoiceDate',    },
    { className => 'dt-right', data => 'CustomerId',     },
    { className => 'dt-left',  data => 'BillingAddress', title => 'Billing Address'}
      ],
    data => $invoices,
  };
};


get '/demo04' => sub {
  template 'demo03', {
    title => 'demo04 JSON API and CSS classes',
    json_data_url => '/api/demo04',
  };
};

###### demo 05
get '/api/demo05' => sub {
# return query as JSON
  my $sth = database->prepare(
        'select * from invoices',
      );
  $sth->execute() or die $sth->errstr;

  my $fields = $sth->{NAME};
  my $invoices = $sth->fetchall_arrayref({});
  
  send_as JSON => {
    columnDefs => [
      { "render" => q/function ( data, type, row ) { return data.substring(0,10); }/,
	"targets" => 1,
      },
    ],
    columns => [
      { className => 'dt-right', data => 'InvoiceId',      },
      { className => 'dt-left',  data => 'InvoiceDate',    },
      { className => 'dt-right', data => 'CustomerId',     },
      { className => 'dt-left',  data => 'BillingAddress', title => 'Billing Address'}
    ],
    data => $invoices,
  };
};


get '/demo05' => sub {
  template 'demo04', { # now we can re-use the previous template
    title => 'demo05 JSON API with CSS classes and buttons',
    json_data_url => '/api/demo05',
  };
};

####################################################################
## demo 06
## send formatting data from the main route rather than the api route
get '/demo06' => sub {
  my $j = JSON->new->encode([
    { className => 'dt-right', data => 'InvoiceId',      },
    { className => 'dt-left',  data => 'InvoiceDate',    },
    { className => 'dt-right', data => 'CustomerId',     },
    { className => 'dt-left',  data => 'BillingAddress', title => 'Billing Address'},
    { data => 'BillingCity'},
    { data => 'BillingState'}, 
    { data => 'BillingCountry'}, 
    { data => 'BillingPostalCode'}, 
    { data => 'Total'},
  ],);


  template 'demo06', { # now we can re-use the previous template
    title => 'demo06 JSON API with CSS classes and buttons',
    json_data_url => '/api/demo06',
    columns => $j,
    columnDefs => [
      { "render" => q/function ( data, type, row ) { return data.substring(0,10); }/,
	"targets" => 1,
      },
    ],
    
  };
};


get '/api/demo06' => sub {
# return query as JSON
  my $sth = database->prepare(
        'select * from invoices',
      );
  $sth->execute() or die $sth->errstr;

  my $fields = $sth->{NAME};
  my $invoices = $sth->fetchall_arrayref({});
  
  send_as JSON => {
    data => $invoices,
  };
};


true;
