Return-Path: <carl.strickland@intel.com>
From: "Strickland, Carl" <carl.strickland@intel.com>
Subject: RE: FIO r/w to 2 disks
Date: Mon, 18 Jun 2012 15:48:39 +0000
Message-ID: <4E57E183169EA04186759995F13BDC6234F474DC@FMSMSX103.amr.corp.intel.com>
References: <4E57E183169EA04186759995F13BDC621A18A7C7@FMSMSX103.amr.corp.intel.com>
 <4FD998CE.3030705@kernel.dk>
 <4E57E183169EA04186759995F13BDC6234F46FA9@FMSMSX103.amr.corp.intel.com>
 <4FDADB0C.5040308@kernel.dk>
In-Reply-To: <4FDADB0C.5040308@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Thanks Jens, I will look into it!


Cheers,
Carl Strickland

-----Original Message-----
From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On Behal=
f Of Jens Axboe
Sent: Thursday, June 14, 2012 11:50 PM
To: Strickland, Carl
Cc: fio@vger.kernel.org
Subject: Re: FIO r/w to 2 disks

On 06/15/2012 01:41 AM, Strickland, Carl wrote:
> Hi Jens,
>=20
> The test I'm interested in performing would require (I believe) FIO to=20
> read from one device and write to another in a specified ratio. This=20
> is different from the rwmix feature in FIO, as I can specify only a=20
> single device where the reads and writes will take place.
>=20
> Assuming that I could achieve the same read/write ratio with two FIO=20
> instances (one reading from one device and the other writing to a=20
> different device) as I get using a single FIO instance and rwmix, is=20
> there a reason--in terms of how reads and writes would be=20
> performed--that would prevent a valid comparison between the two?

Maybe the flow options would help you? Set up two jobs in a single file, on=
e reader and one writer. Set up the flow parameters to get your desired spl=
it. See HOWTO, and/or examples/flow to get an idea for how to use that.

--
Jens Axboe

--
To unsubscribe from this list: send the line "unsubscribe fio" in the body =
of a message to majordomo@vger.kernel.org More majordomo info at  http://vg=
er.kernel.org/majordomo-info.html

