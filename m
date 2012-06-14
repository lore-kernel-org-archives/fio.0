Return-Path: <carl.strickland@intel.com>
From: "Strickland, Carl" <carl.strickland@intel.com>
Subject: RE: FIO r/w to 2 disks
Date: Thu, 14 Jun 2012 23:41:19 +0000
Message-ID: <4E57E183169EA04186759995F13BDC6234F46FA9@FMSMSX103.amr.corp.intel.com>
References: <4E57E183169EA04186759995F13BDC621A18A7C7@FMSMSX103.amr.corp.intel.com>
 <4FD998CE.3030705@kernel.dk>
In-Reply-To: <4FD998CE.3030705@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Hi Jens,

The test I'm interested in performing would require (I believe) FIO to read
from one device and write to another in a specified ratio. This is differen=
t
from the rwmix feature in FIO, as I can specify only a single device where =
the
reads and writes will take place.

Assuming that I could achieve the same read/write ratio with two FIO instan=
ces
(one reading from one device and the other writing to a different device) a=
s I
get using a single FIO instance and rwmix, is there a reason--in terms of h=
ow
reads and writes would be performed--that would prevent a valid comparison
between the two?


Thanks,
Carl

