Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
References: <BN7PR08MB409869032E10FEC58C9CBE08D9FF0@BN7PR08MB4098.namprd08.prod.outlook.com>
 <d9885cb6-af59-f4c3-d58b-37495e4c0654@kernel.dk> <AT5PR8401MB1169925565E8213E9968F891ABFF0@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
In-Reply-To: <AT5PR8401MB1169925565E8213E9968F891ABFF0@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Thu, 18 Oct 2018 05:19:18 +0100
Message-ID: <CALjAwxg5bDB80+_g2aUvPuTEAsqS=xsP0Htxur=5Zyot8-4UEw@mail.gmail.com>
Subject: Re: FIO 3.11
Content-Type: text/plain; charset="UTF-8"
To: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Cc: efortin@cyberspicace.com, fio <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

On Wed, 17 Oct 2018 at 22:45, Elliott, Robert (Persistent Memory)
<elliott@hpe.com> wrote:
>
>
> These will make each thread implement your desired mix:
>
>        rwmixread=int
[...]
>        rwmixwrite=int
[...]
>        percentage_random=int[,int][,int]
[...]

Another (but more overlooked) option for forcing different jobs into
lockstep with each other is the flow parameter -
https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-flow
but it tends to be easiest to reason about when there are just two
jobs.

>
> Threads running sequential accesses can easily benefit from cache hits from each other, if
> there is any caching or prefetching done by the involved drivers or devices.  One thread
> takes the lead and suffers delays, while the others benefit from its work and stay close
> behind.  They can take turns, but tend to stay clustered together. This can distort results.
> Random accesses avoid that problem, provided the capacity is much larger than any caches.

-- 
Sitsofe | http://sucs.org/~sits/

