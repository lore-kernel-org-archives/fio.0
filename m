Return-Path: <elliott@hpe.com>
From: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Subject: RE: FIO 3.11
Date: Wed, 17 Oct 2018 21:41:40 +0000
Message-ID: <AT5PR8401MB1169925565E8213E9968F891ABFF0@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
References: <BN7PR08MB409869032E10FEC58C9CBE08D9FF0@BN7PR08MB4098.namprd08.prod.outlook.com>
 <d9885cb6-af59-f4c3-d58b-37495e4c0654@kernel.dk>
In-Reply-To: <d9885cb6-af59-f4c3-d58b-37495e4c0654@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Etienne-Hugues Fortin <efortin@cyberspicace.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>, 'Jens Axboe' <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

> First, when we create a profile, my assumption is that if I have two jobs=
 without using 'stonewall',
> each job will run at the same time and will have the same priority. So, i=
f I want to do a job with a
> 50% read/write but with 25% random and 75% sequential, I would need a job=
 that look like this:
...
> If so, outside of trying to work the numjobs required to get about 50% R/=
W, is there a
> better way of doing this?

The OS controls how different threads progress, and there's nothing keeping=
 them in
lockstep.

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
 each other, if
there is any caching or prefetching done by the involved drivers or devices=
.  One thread
takes the lead and suffers delays, while the others benefit from its work a=
nd stay close
behind.  They can take turns, but tend to stay clustered together. This can=
 distort results.
Random accesses avoid that problem, provided the capacity is much larger th=
an any caches.


