Return-Path: <konstantin.ruvinsky@gmail.com>
MIME-Version: 1.0
In-Reply-To: <e54427a7-8037-5aa2-06cc-0168b892eb89@kernel.dk>
References: <CALKvLUnbsqZ8VDW5yKc8vbLU-3Sa4eMu2vb7u2vqm0NFQo+FZQ@mail.gmail.com>
 <e54427a7-8037-5aa2-06cc-0168b892eb89@kernel.dk>
From: Konstantin Ruvinsky <konstantin.ruvinsky@gmail.com>
Date: Fri, 25 May 2018 13:11:19 +0300
Message-ID: <CALKvLUkC50RrXv+3BGYJMCgLDffqb1zrJp=nhFaTnqc1JgXwfA@mail.gmail.com>
Subject: Re: bssplit option HOWTO
Content-Type: text/plain; charset="UTF-8"
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On Thu, 24 May 2018, 22:10 Jens Axboe, <axboe@kernel.dk> wrote:
>
> On 5/21/18 11:04 AM, Konstantin Ruvinsky wrote:
> > Hi
> >
> >
> >
> > In the last HOWTO is written:
> >
> >
> >
> > http://git.kernel.dk/?p=fio.git;a=blob;f=HOWTO;h=7680f9c7634a7e55044dba0a8ebdc6928fb3bfc0;hb=HEAD#l1429
> >
> >
> >
> >
> >
> > 1429       If you want a workload that has 50% 2k reads and 50% 4k reads, while
> >
> > 1430         having 90% 4k writes and 10% 8k writes, you would specify::
> >
> > 1431
> >
> > 1432                 bssplit=2k/50:4k/50,4k/90,8k/10
> >
> >
> >
> > Question:
> >
> > Has it be
> >
> >
> >
> > bssplit=2k/50:4k/50,4k/90:8k/10
>
> Yes, good patch. Care to send a patch?
>
> --
> Jens Axboe


Jens,

Can you please do it instead of me this time?

Thanks

