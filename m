Return-Path: <prvs=1177ddc46d=mario.carino@aig.com>
From: "Carino, Mario" <Mario.Carino@AIG.com>
Date: Thu, 10 Apr 2014 12:59:19 -0400
Subject: RE: fio on AIX - fallocate error
Message-ID: <E2B4022DB0264A4B90C5F1B01B8E677D733229CA@LIVP3MMBX13.mail.aig.net>
References: <E2B4022DB0264A4B90C5F1B01B8E677D733225E0@LIVP3MMBX13.mail.aig.net>
 <5346A3FE.10106@kernel.dk>
 <E2B4022DB0264A4B90C5F1B01B8E677D73322971@LIVP3MMBX13.mail.aig.net>
 <5346C84D.1010704@kernel.dk>
 <E2B4022DB0264A4B90C5F1B01B8E677D733229A5@LIVP3MMBX13.mail.aig.net>
 <5346CD5C.8090008@kernel.dk>
In-Reply-To: <5346CD5C.8090008@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

I don't know. I didn't download the source code. Where can I get the versio=
n with the patch?

Mario Carino


-----Original Message-----
From: Jens Axboe [mailto:axboe@kernel.dk]=20
Sent: Thursday, April 10, 2014 12:57 PM
To: Carino, Mario; fio@vger.kernel.org
Subject: Re: fio on AIX - fallocate error

On 04/10/2014 10:44 AM, Carino, Mario wrote:
> Debug output attached

Are you running with the previous patch for the fadvise error? It looks lik=
e you are not, which is why it exits.

--
Jens Axboe


