Return-Path: <dehrenberg@google.com>
MIME-Version: 1.0
In-Reply-To: <4E5D870B.8050108@kernel.dk>
References: <1314751823-17972-1-git-send-email-dehrenberg@google.com>
	<4E5D870B.8050108@kernel.dk>
Date: Tue, 30 Aug 2011 18:09:13 -0700
Message-ID: <CAAK6Zt1kz_QXMo7=6+madqa5FSSUxm9U3_wsJV25JY-W70136Q@mail.gmail.com>
Subject: Re: [PATCH v2] Adding userspace_libaio_reap option
From: Daniel Ehrenberg <dehrenberg@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On Tue, Aug 30, 2011 at 5:57 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On 2011-08-30 18:50, Dan Ehrenberg wrote:
>> @@ -66,7 +107,16 @@ static int fio_libaio_getevents(struct thread_data *=
td, unsigned int min,
>> =A0 =A0 =A0 int r, events =3D 0;
>>
>> =A0 =A0 =A0 do {
>> - =A0 =A0 =A0 =A0 =A0 =A0 r =3D io_getevents(ld->aio_ctx, actual_min, ma=
x, ld->aio_events + events, t);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (td->o.userspace_libaio_reap =3D=3D 1
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 && actual_min =3D=3D 0
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 && ((struct aio_ring *)(ld->aio_ctx))-=
>magic
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =3D=3D AIO_RIN=
G_MAGIC) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 r =3D user_io_getevents(ld->ai=
o_ctx, max,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ld->aio_events=
 + events);
>> + =A0 =A0 =A0 =A0 =A0 =A0 } else {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 r =3D io_getevents(ld->aio_ctx=
, actual_min,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 max, ld->aio_e=
vents + events, t);
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>
> One question here - why depend on actual_min =3D=3D 0? The check is
> practically free, would not hurt to do the user_io_getevents() first and
> punt to io_getevents() afterwards if need be.

I guess I don't need to depend on that, since you'll never be calling
both user_io_getevents() and sys_io_getevents() at the same time
still. It was just paranoia, really--if I'm not grabbing the ring_lock
spinlock that exists in the kernel, then I'll be really safe if I
never run code that wants to grab it. But I guess the condition is not
really necessary since the whole thing is single-threaded.
>
> --
> Jens Axboe
>
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

