Return-Path: <efortin@cyberspicace.com>
From: Etienne-Hugues Fortin <efortin@cyberspicace.com>
Subject: RE: FIO 3.11
Date: Thu, 18 Oct 2018 00:42:23 +0000
Message-ID: <BN7PR08MB4098DE93CC05114F47D4757FD9F80@BN7PR08MB4098.namprd08.prod.outlook.com>
References: <BN7PR08MB409869032E10FEC58C9CBE08D9FF0@BN7PR08MB4098.namprd08.prod.outlook.com>
 <d9885cb6-af59-f4c3-d58b-37495e4c0654@kernel.dk>
 <AT5PR8401MB1169925565E8213E9968F891ABFF0@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
In-Reply-To: <AT5PR8401MB1169925565E8213E9968F891ABFF0@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
Content-Language: fr-FR
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>, 'Jens Axboe' <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

Hello,

Well, that explain it. I just tested it on my new test environment and it s=
eems to work fine. Read and write are a lot more aligned this way. This see=
ms to work well on block device (LUN) but performance are not as good on fi=
les that are on NAS. It keep the proper ratio between read and write but at=
 a slower pace compared to my previous setup that was segmented by jobs (re=
ad sequential, write sequential, read random, write random). By manually ad=
justing numjobs on each, I was able to get the proper read/write ratio need=
ed and as my jobs are on large files, I was able to see from the storage th=
at the disks where providing the data, not the cache.

I guess I'll have to play around to see if that's really what is happening =
but at first, it look like it.

Thank you for your answer. It corrected my assumptions which will help goin=
g forward.


Etienne

-----Message d'origine-----
De=A0: Elliott, Robert (Persistent Memory) <elliott@hpe.com>=20
Envoy=E9=A0: October 17, 2018 5:42 PM
=C0=A0: Etienne-Hugues Fortin <efortin@cyberspicace.com>; fio@vger.kernel.o=
rg; 'Jens Axboe' <axboe@kernel.dk>
Objet=A0: RE: FIO 3.11

> First, when we create a profile, my assumption is that if I have two=20
> jobs without using 'stonewall', each job will run at the same time and=20
> will have the same priority. So, if I want to do a job with a 50% read/wr=
ite but with 25% random and 75% sequential, I would need a job that look li=
ke this:
...
> If so, outside of trying to work the numjobs required to get about 50%=20
> R/W, is there a better way of doing this?

The OS controls how different threads progress, and there's nothing keeping=
 them in lockstep.

These will make each thread implement your desired mix:

       rwmixread=3Dint
              Percentage of a mixed workload that should be reads. Default:=
 50.

       rwmixwrite=3Dint
              Percentage of a mixed workload that should be writes. If both=
 rwmixread and
              rwmixwrite is given and the values do not add up to 100%, the=
 latter of the two
              will be used to override the first.

       percentage_random=3Dint[,int][,int]
              For  a  random  workload,  set how big a percentage should be=
 random. This defaults
              to 100%, in which case the workload is fully random. It can b=
e set from anywhere
              from 0 to 100. Setting it to 0 would make the workload fully =
sequential. Any setting
              in between will result in a random mix of sequential and  ran=
dom  I/O,  at  the
              given percentages. Comma-separated values may be specified fo=
r reads, writes, and
              trims as described in blocksize.

Threads running sequential accesses can easily benefit from cache hits from=
 each other, if there is any caching or prefetching done by the involved dr=
ivers or devices.  One thread takes the lead and suffers delays, while the =
others benefit from its work and stay close behind.  They can take turns, b=
ut tend to stay clustered together. This can distort results.
Random accesses avoid that problem, provided the capacity is much larger th=
an any caches.


