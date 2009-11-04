Return-Path: <radha@google.com>
MIME-Version: 1.0
In-Reply-To: <20091104192230.GI8742@kernel.dk>
References: <66dfd3fe0911031633s5bef0621g99b4164c2dd174d9@mail.gmail.com>
	 <20091104073525.GQ8742@kernel.dk>
	 <66dfd3fe0911040912s377b8b0eqb81fa3cad3db2d2f@mail.gmail.com>
	 <20091104172932.GD8742@kernel.dk>
	 <66dfd3fe0911040939w7629a514l393e3a6360430b54@mail.gmail.com>
	 <20091104174123.GG8742@kernel.dk> <20091104192230.GI8742@kernel.dk>
Date: Wed, 4 Nov 2009 11:31:18 -0800
Message-ID: <66dfd3fe0911041131qcd032dem89f3cdfada112989@mail.gmail.com>
Subject: Re: Add extra_buff_count flag
From: Radha Ramachandran <radha@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
To: Jens Axboe <jens.axboe@oracle.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Thank you for the documentation update.

You also mentioned that you saw some kind of a race on io_u->flags
today, do you by any chance know if you were using iodepth_low or
iodepth_batch_complete or libaio engine options.
I think I see an issue when using them and understand why it happens,
but dont have a clean fix yet, will hopefully have one soon. I was
wondering if its the same issue you are seeing.
Basically the issue is we might think the queue is full (because we
cannot allocate any more io_u (they are probably doing async verify)),
but the code assumes that if the queue is full, then there is atleast
one I/O that we can do "io_getevents" on. And that will cause a hang
in the code.

thanks
-radha


On Wed, Nov 4, 2009 at 11:22 AM, Jens Axboe <jens.axboe@oracle.com> wrote:
> On Wed, Nov 04 2009, Jens Axboe wrote:
>> On Wed, Nov 04 2009, Radha Ramachandran wrote:
>> > I would rather document it than add it by default in case it starts
>> > hitting memory constraints because its allocating more memory buffers.
>>
>> Yes I agree, I usually don't like having one option implying changes for
>> another either.
>
> So the problem with documentation is that usually nobody reads it. This
> is what the HOWTO/man page currently has:
>
> verify_async=3Dint =A0 =A0 =A0 =A0Fio will normally verify IO inline from=
 the submitting
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0thread. This option takes an integer descr=
ibing how many
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0async offload threads to create for IO ver=
ification instead,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0causing fio to offload the duty of verifyi=
ng IO contents
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0to one or more separate threads. If using =
this offload
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0option, even sync IO engines can benefit f=
rom using an
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0iodepth setting higher than 1, as it allow=
s them to have
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0IO in flight while verifies are running.
>
> It's already documented...
>
> --
> Jens Axboe
>
>

