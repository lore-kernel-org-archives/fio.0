Return-Path: <radha@google.com>
MIME-Version: 1.0
In-Reply-To: <20091104200158.GK8742@kernel.dk>
References: <66dfd3fe0911031633s5bef0621g99b4164c2dd174d9@mail.gmail.com>
	 <20091104073525.GQ8742@kernel.dk>
	 <66dfd3fe0911040912s377b8b0eqb81fa3cad3db2d2f@mail.gmail.com>
	 <20091104172932.GD8742@kernel.dk>
	 <66dfd3fe0911040939w7629a514l393e3a6360430b54@mail.gmail.com>
	 <20091104174123.GG8742@kernel.dk> <20091104192230.GI8742@kernel.dk>
	 <66dfd3fe0911041131qcd032dem89f3cdfada112989@mail.gmail.com>
	 <20091104193622.GJ8742@kernel.dk> <20091104200158.GK8742@kernel.dk>
Date: Wed, 4 Nov 2009 14:50:35 -0800
Message-ID: <66dfd3fe0911041450k7935aaa5ia4cf253f6d4d066@mail.gmail.com>
Subject: Re: Add extra_buff_count flag
From: Radha Ramachandran <radha@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
To: Jens Axboe <jens.axboe@oracle.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Hi,
This is the patch to fix the race condition when
iodepth_batch_complete and verify_async are used. The fix prevents the
code from waiting for more I/Os than were actually submitted.

diff --git a/fio.c b/fio.c
index debcac5..22eba49 100644
--- a/fio.c
+++ b/fio.c
@@ -536,7 +536,8 @@ sync_done:
                 */
                full =3D queue_full(td) || ret =3D=3D FIO_Q_BUSY;
                if (full || !td->o.iodepth_batch_complete) {
-                       min_events =3D td->o.iodepth_batch_complete;
+                       min_events =3D min(td->o.iodepth_batch_complete,
+                                        td->cur_depth);
                        if (full && !min_events)
                                min_events =3D 1;

@@ -688,7 +689,8 @@ sync_done:
                 */
                full =3D queue_full(td) || ret =3D=3D FIO_Q_BUSY;
                if (full || !td->o.iodepth_batch_complete) {
-                       min_evts =3D td->o.iodepth_batch_complete;
+                       min_evts =3D min(td->o.iodepth_batch_complete,
+                                        td->cur_depth);
                        if (full && !min_evts)
                                min_evts =3D 1;

thanks
-radha



On Wed, Nov 4, 2009 at 12:01 PM, Jens Axboe <jens.axboe@oracle.com> wrote:
> On Wed, Nov 04 2009, Jens Axboe wrote:
>> > You also mentioned that you saw some kind of a race on io_u->flags
>> > today, do you by any chance know if you were using iodepth_low or
>> > iodepth_batch_complete or libaio engine options.
>> > I think I see an issue when using them and understand why it happens,
>> > but dont have a clean fix yet, will hopefully have one soon. I was
>> > wondering if its the same issue you are seeing.
>> > Basically the issue is we might think the queue is full (because we
>> > cannot allocate any more io_u (they are probably doing async verify)),
>> > but the code assumes that if the queue is full, then there is atleast
>> > one I/O that we can do "io_getevents" on. And that will cause a hang
>> > in the code.
>>
>> I didn't use libaio, I can reproduce it with the sync engine directly
>> and much easier if using fast "null" verifies. It triggers this assert
>> in put_io_u():
>>
>> =A0 =A0 =A0 =A0 assert((io_u->flags & IO_U_F_FREE) =3D=3D 0);
>>
>> and this in __get_io_u():
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 assert(io_u->flags & IO_U_F_FREE);
>>
>> The former I think is just a bug, it's likely a reput or something, but
>> not sure yet. The latter looks like a race on the flags, since it isn't
>> always locked down when manipulated.
>
> I think this is fixed now, committed a patch for it.
>
> --
> Jens Axboe
>
>

