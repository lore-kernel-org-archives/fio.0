Return-Path: <d.gollub@telekom.de>
From: "Gollub, Daniel" <d.gollub@telekom.de>
Date: Thu, 13 Feb 2014 17:27:33 +0100
Subject: fio ioengines for CEPH (was: RE: [PATCH] Fix g++ warning about
 void* used in arithmetic)
Message-ID: <8C0F43FF977B33478B9D801E3A9A8F9F0255DADC5B@QEO40075.de.t-online.corp>
References: <1392229542-14083-1-git-send-email-d.gollub@telekom.de>
 <52FC45E9.3090101@kernel.dk>
 <20140213071357.36e92383@marvin>,<842615085.1431531.1392287522937.JavaMail.zimbra@enovance.com>
In-Reply-To: <842615085.1431531.1392287522937.JavaMail.zimbra@enovance.com>
Content-Language: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Erwan Velu <erwan.velu@enovance.com>, Daniel Gollub <daniel.gollub@t-online.de>
Cc: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>, "danny.al-gaaf@bisect.de" <danny.al-gaaf@bisect.de>
List-ID: <fio@vger.kernel.org>

Hi Erwan,

my colleagues of DTAG P&I Platform Engineering of the Business Marketplace =
and me did the last month
performance profiling of our CEPH cluster for RBDs. We decided to implement=
 fio engine based on librbd
and an external fio engine using CEPHs FileStore class. So we can run the s=
ame IO pattern with the same
IO test tool on all the different layers. And fio was just the perfect fit =
for us:

 * inside the KVM/QEMU VM with fio ioengine=3Dlibaio
 * on the KVM-host using fio ioengine=3Drbd
 * on the CEPH OSD node with a external fio engine based on CEPH FileStore =
(writing the PG groups on the filesystem + OSD journal)
 * finally: fio tests on the OSD filesystem and the plain blockdevice



I plan to clean the RBD branch up and send out patches hopefully tomorrow.
RBD ioengine branch: https://github.com/TelekomCloud/fio/commits/rbd-engine=
_v2


The external FileStore ioengine I plan to cleanup next week - right now its=
 a "quick hack" shape:
https://github.com/gollub/ceph/blob/fio_filestore/src/fio_ceph_filestore.c

Once I am done with the cleanup and pushed everything Danny and me will pro=
vide a write-up on the
TelekomCloud blog about our CEPH-RBD performance sprint with fio.


Kind Regards
Daniel Gollub
________________________________________
From: Erwan Velu [erwan.velu@enovance.com]
Sent: Thursday, February 13, 2014 11:32 AM
To: Daniel Gollub
Cc: Jens Axboe; fio@vger.kernel.org; Gollub, Daniel
Subject: Re: [PATCH] Fix g++ warning about void* used in arithmetic

I'm interested in CEPH too. Can you tell us what is your plan with fio & CE=
PH ?

----- Mail original -----
De: "Daniel Gollub" <daniel.gollub@t-online.de>
=C0: "Jens Axboe" <axboe@kernel.dk>
Cc: fio@vger.kernel.org, "Daniel Gollub" <d.gollub@telekom.de>
Envoy=E9: Jeudi 13 F=E9vrier 2014 07:13:57
Objet: Re: [PATCH] Fix g++ warning about void* used in arithmetic

Hi Jens,

On Wed, 12 Feb 2014 21:11:21 -0700, Jens Axboe wrote:
> On 2014-02-12 11:25, Daniel Gollub wrote:
> > ../parse.h: In function =91void* td_var(thread_options*, fio_option*,
> > unsigned int)=92: ../parse.h:110:10: warning: pointer of type =91void
> > *=92 used in arithmetic [-Wpointer-arith] ../parse.h:112:9: warning:
> > pointer of type =91void *=92 used in arithmetic [-Wpointer-arith]
>
> I bet there are a lot of these, or other similar code that would
> prevent compiling with g++. I'm dubious of the value add here. Fio is
> written in C, after all.
>

I should have mentioned this in the commit message: this is required to
compile an external ionengine written in C++. I do not try to compile
entire fio with g++. If I include fio.h in the external ioengine,
parse.h gets included by fio.h or so and causes this g++ warning.

This was the last warning (which just got introduced 2 days
ago) when fio.h gets included by an external engine build with g++.

So the value here is to build external ioengines against libraries/APIs
which are only available in C++. In my case against an internal library
of CEPH.


--
Daniel Gollub
--
To unsubscribe from this list: send the line "unsubscribe fio" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html=

