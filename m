Return-Path: <Konstantin.Ruvinsky@emc.com>
From: "Ruvinsky, Konstantin" <Konstantin.Ruvinsky@emc.com>
Date: Wed, 2 Oct 2013 10:40:06 -0400
Subject: RE: [PULL REQUEST] Man page updates
Message-ID: <EEF9E3C12F20174DA289A981D6CCA6C8324A5C8552@MX44A.corp.emc.com>
References: <1380661774.14931.YahooMailNeo@web124903.mail.ne1.yahoo.com>
 <EEF9E3C12F20174DA289A981D6CCA6C8324A5C8515@MX44A.corp.emc.com>
 <20131002141838.GA13247@sucs.org>
In-Reply-To: <20131002141838.GA13247@sucs.org>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, "axboe@kernel.dk axboe@kernel.dk" <Jens Axboe>
List-ID: <fio@vger.kernel.org>

Hi Sitsof,

I did the following:  entered the link https://github.com/sitsofe/fio.git a=
nd opened HowTo file
Did the same for http://git.kernel.dk/?p=3Dfio.git;a=3Dtree;hb=3DHEAD
In the both opened HowTo files  you can find "write_bw_log" twice. The seco=
nd one is redundant

Regards
Konstantin

-----Original Message-----
From: Sitsofe Wheeler [mailto:sitsofe@yahoo.com]=20
Sent: Wednesday, October 02, 2013 5:19 PM
To: Ruvinsky, Konstantin
Cc: fio@vger.kernel.org; Jens Axboe (axboe@kernel.dk) (axboe@kernel.dk)
Subject: Re: [PULL REQUEST] Man page updates

Hi Konstantin,

On Wed, Oct 02, 2013 at 01:48:25AM -0400, Ruvinsky, Konstantin wrote:
>=20
> If you correct the man pages, please remove the second redundant definiti=
on of write_bw_log:
>=20
> write_bw_log=3Dstr If given, write an IOPS log of the jobs in this job
>       		file. See write_bw_log.

I can't see where that is in
http://git.kernel.dk/?p=3Dfio.git;a=3Dblob_plain;f=3Dfio.1;hb=3DHEAD - are =
you sure you're looking at HEAD?

--
Sitsofe | http://sucs.org/~sits/


