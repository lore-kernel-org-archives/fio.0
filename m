Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CALjAwxjKrHJQWc16Ca=D=5nvfV6_ykRqm27jaa=oV8aa=afSwA@mail.gmail.com>
References: <CALjAwxhbN5aOz+MeVg8wSatS55eGYg7vqDVzguGP6Hsowjt9JA@mail.gmail.com>
 <4c2dc64e-5b4e-872d-1e09-d3191c87d5ca@kernel.dk> <CALjAwxhJWrAyraQsGYm0D+_Nw8kg6LLaoeW3KCHsNxz2=8_8=Q@mail.gmail.com>
 <19fdc2cb-2adf-05a6-7a4d-4c7f37080050@kernel.dk> <CALjAwxjKrHJQWc16Ca=D=5nvfV6_ykRqm27jaa=oV8aa=afSwA@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Wed, 26 Oct 2016 16:18:21 +0100
Message-ID: <CALjAwxhOFgfqFcfgnFseVfVsjgpF8UoneT7V1zLkP1Gp3yOj9Q@mail.gmail.com>
Subject: Re: Segfault in fio_libaio_getevents
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 21 October 2016 at 11:00, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
>
> Backtrace says this:
> Program terminated with signal SIGSEGV, Segmentation fault.
> #0  fio_libaio_getevents (td=0x7fb0711e0ad0, min=0, max=1,
> t=<optimized out>) at engines/libaio.c:160

I've found an easy way to reproduce this:

echo "0 137438953472 zero" | dmsetup create zero64t2

fio --runtime --allow_file_create=0 --direct=1 --iodepth=8
--ioengine=libaio --bsrange=512-32k --time_based=1 --runtime=12h
--norandommap --name=go --filename /dev/mapper/zero64t2 --name=go2
--filename /dev/mapper/zero64t2 & sleep 5; dmsetup suspend zero64t2;
sleep 5 && kill % && fg; dmsetup resume zero64t2

This happens even with fio-2.15. The cores don't appear until the
dmsetup resume is performed and it speeds things up if  #define
FIO_REAP_TIMEOUT in fio.h is set to be a low number...

-- 
Sitsofe | http://sucs.org/~sits/

