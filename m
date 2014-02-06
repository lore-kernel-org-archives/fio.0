Return-Path: <puthik@google.com>
MIME-Version: 1.0
In-Reply-To: <20140206033437.GA25141@kernel.dk>
References: <CANEJEGuqYiSQnyw2bVNFa3CKqmZK6+-3y5dDT4h3iccU-n0cAA@mail.gmail.com>
	<20140205193214.GI27534@kernel.dk>
	<CANEJEGs-KdsMC3fE3SvOUkkbJESXXvUHwRVq5OjWTfKyf-ooEA@mail.gmail.com>
	<20140205195317.GK27534@kernel.dk>
	<CANEJEGsqwKQssFqZPEycWR-ccqcVjWGQA=EtLtDsdxg5D1-c_g@mail.gmail.com>
	<20140205212812.GC20626@kernel.dk>
	<CANEJEGt5neHeCc-wnDDyFWY7S_AyxzKjaOj09DXR08oRjF+Dow@mail.gmail.com>
	<20140205223052.GF20626@kernel.dk>
	<20140206033437.GA25141@kernel.dk>
Date: Thu, 6 Feb 2014 10:58:56 -0800
Message-ID: <CANCcNXfkC3pTVTKp3irQDovASV1rwC7oeakboGre7ZmMV9MtxQ@mail.gmail.com>
Subject: Re: Rip out verify_backlog support?
From: Puthikorn Voravootivat <puthik@google.com>
Content-Type: multipart/mixed; boundary=047d7b3a830029bd1904f1c177d4
To: Jens Axboe <axboe@kernel.dk>
Cc: Grant Grundler <grundler@chromium.org>, FIO_list <fio@vger.kernel.org>, Puthikorn Voravootivat <puthik@chromium.org>
List-ID: <fio@vger.kernel.org>

--047d7b3a830029bd1904f1c177d4
Content-Type: text/plain; charset=UTF-8

That fix runs fine with my test script (attached), but I think you
might want to remove or reword this comment.

diff --git a/backend.c b/backend.c
index 9ececaa..99f9065 100644
--- a/backend.c
+++ b/backend.c
@@ -724,10 +724,6 @@ static uint64_t do_io(struct thread_data *td)
                else
                        td_set_runstate(td, TD_RUNNING);

-               /*
-                * Verify_backlog disabled: We need to log rand seed before the
-                * actual IO to be able to replay it correctly in the
verify phase.
-                */
                if (td_write(td) && io_u->ddir == DDIR_WRITE &&
                    td->o.do_verify &&
                    td->o.verify != VERIFY_NONE &&


On Wed, Feb 5, 2014 at 7:34 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On Wed, Feb 05 2014, Jens Axboe wrote:
>> On Wed, Feb 05 2014, Grant Grundler wrote:
>> > > It does - that's the log_io_piece() mechanism. The writer will generate
>> > > on, and verify will read those and verify. We just have to ensure that
>> > > it is correct in the way that it is logged. The alternative would be to
>> > > rely purely on the generator rollback, and for that you would then need
>> > > some specific notification on how far the reader could proceed, if async
>> > > verify_backlog is used.
>> >
>> > Yes - I was referring to the "rely purely on generator rollback".
>> >
>> > Once log_io_piece() is called, the verify code assumes the IO is
>> > complete...which isn't true if log_io_piece() is used to record "order
>> > issued".
>>
>> Right, we'd need to ensure the state is accurately known to the
>> verifier.
>
> Something like this should work, though I don't like the extra
> overhead... Totally untested.
>
> diff --git a/backend.c b/backend.c
> index 62fa17c3a209..9ececaa1d5af 100644
> --- a/backend.c
> +++ b/backend.c
> @@ -731,8 +731,7 @@ static uint64_t do_io(struct thread_data *td)
>                 if (td_write(td) && io_u->ddir == DDIR_WRITE &&
>                     td->o.do_verify &&
>                     td->o.verify != VERIFY_NONE &&
> -                   !td->o.experimental_verify &&
> -                   !(td->flags & TD_F_VER_BACKLOG))
> +                   !td->o.experimental_verify)
>                         log_io_piece(td, io_u);
>
>                 ret = td_io_queue(td, io_u);
> diff --git a/io_u.c b/io_u.c
> index 4264cd54115c..64ff73cd5555 100644
> --- a/io_u.c
> +++ b/io_u.c
> @@ -1285,6 +1285,7 @@ again:
>                 io_u->acct_ddir = -1;
>                 td->cur_depth++;
>                 io_u->flags |= IO_U_F_IN_CUR_DEPTH;
> +               io_u->ipo = NULL;
>         } else if (td->o.verify_async) {
>                 /*
>                  * We ran out, wait for async verify threads to finish and
> @@ -1568,6 +1569,15 @@ static void io_completed(struct thread_data *td, struct io_u *io_u,
>         td_io_u_lock(td);
>         assert(io_u->flags & IO_U_F_FLIGHT);
>         io_u->flags &= ~(IO_U_F_FLIGHT | IO_U_F_BUSY_OK);
> +
> +       /*
> +        * Mark IO ok to verify
> +        */
> +       if (io_u->ipo) {
> +               io_u->ipo->flags &= ~IP_F_IN_FLIGHT;
> +               write_barrier();
> +       }
> +
>         td_io_u_unlock(td);
>
>         if (ddir_sync(io_u->ddir)) {
> @@ -1623,17 +1633,6 @@ static void io_completed(struct thread_data *td, struct io_u *io_u,
>                                          utime_since_now(&td->start));
>                 }
>
> -               /*
> -                * Verify_backlog enable: We need to log the write job after
> -                * finishing it to prevent verifying before finish writing.
> -                */
> -               if (td_write(td) && idx == DDIR_WRITE &&
> -                   td->o.do_verify &&
> -                   td->o.verify != VERIFY_NONE &&
> -                   !td->o.experimental_verify &&
> -                   (td->flags & TD_F_VER_BACKLOG))
> -                       log_io_piece(td, io_u);
> -
>                 icd->bytes_done[idx] += bytes;
>
>                 if (io_u->end_io) {
> diff --git a/ioengine.h b/ioengine.h
> index 0756bc7e6c13..37627bb1dc76 100644
> --- a/ioengine.h
> +++ b/ioengine.h
> @@ -71,6 +71,8 @@ struct io_u {
>          */
>         unsigned long buf_filled_len;
>
> +       struct io_piece *ipo;
> +
>         union {
>  #ifdef CONFIG_LIBAIO
>                 struct iocb iocb;
> diff --git a/iolog.c b/iolog.c
> index 017b235c217a..5fd9416c036e 100644
> --- a/iolog.c
> +++ b/iolog.c
> @@ -189,6 +189,9 @@ void log_io_piece(struct thread_data *td, struct io_u *io_u)
>         ipo->offset = io_u->offset;
>         ipo->len = io_u->buflen;
>         ipo->numberio = io_u->numberio;
> +       ipo->flags = IP_F_IN_FLIGHT;
> +
> +       io_u->ipo = ipo;
>
>         if (io_u_should_trim(td, io_u)) {
>                 flist_add_tail(&ipo->trim_list, &td->trim_list);
> diff --git a/iolog.h b/iolog.h
> index 321576dbe611..3ec48f2100fe 100644
> --- a/iolog.h
> +++ b/iolog.h
> @@ -67,6 +67,7 @@ enum {
>         IP_F_ONRB       = 1,
>         IP_F_ONLIST     = 2,
>         IP_F_TRIMMED    = 4,
> +       IP_F_IN_FLIGHT  = 8,
>  };
>
>  /*
> diff --git a/verify.c b/verify.c
> index 90cd093add1f..93731228f1b6 100644
> --- a/verify.c
> +++ b/verify.c
> @@ -1022,11 +1022,27 @@ int get_next_verify(struct thread_data *td, struct io_u *io_u)
>                 struct rb_node *n = rb_first(&td->io_hist_tree);
>
>                 ipo = rb_entry(n, struct io_piece, rb_node);
> +
> +               /*
> +                * Ensure that the associated IO has completed
> +                */
> +               read_barrier();
> +               if (ipo->flags & IP_F_IN_FLIGHT)
> +                       goto nothing;
> +
>                 rb_erase(n, &td->io_hist_tree);
>                 assert(ipo->flags & IP_F_ONRB);
>                 ipo->flags &= ~IP_F_ONRB;
>         } else if (!flist_empty(&td->io_hist_list)) {
>                 ipo = flist_entry(td->io_hist_list.next, struct io_piece, list);
> +
> +               /*
> +                * Ensure that the associated IO has completed
> +                */
> +               read_barrier();
> +               if (ipo->flags & IP_F_IN_FLIGHT)
> +                       goto nothing;
> +
>                 flist_del(&ipo->list);
>                 assert(ipo->flags & IP_F_ONLIST);
>                 ipo->flags &= ~IP_F_ONLIST;
> @@ -1072,6 +1088,7 @@ int get_next_verify(struct thread_data *td, struct io_u *io_u)
>                 return 0;
>         }
>
> +nothing:
>         dprint(FD_VERIFY, "get_next_verify: empty\n");
>         return 1;
>  }
>
> --
> Jens Axboe
>

--047d7b3a830029bd1904f1c177d4
Content-Type: application/x-sh; name="test.sh"
Content-Disposition: attachment; filename="test.sh"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hrce15g80

IyEgL2Jpbi9iYXNoCgpkb19maW8oKSB7CiAgICBmb3IgdyBpbiByZWFkd3JpdGUgcmFuZHJ3IHJh
bmR3cml0ZSByYW5kcmVhZCB3cml0ZSByZWFkIDsgZG8KICAgICAgICBlY2hvIC1uICR3LSQyID4g
JDEvcmVzLyR3LSQyCiAgICBkb25lCiAgICAKICAgIGZvciByIGluIDEgMiAzIDQgNSA7IGRvCiAg
ICAgICAgZm9yIHcgaW4gcmVhZHdyaXRlIHJhbmRydyByYW5kd3JpdGUgcmFuZHJlYWQgd3JpdGUg
cmVhZCA7IGRvCiAgICAgICAgICAgLi9maW8gLS1taW5pbWFsICQxL2pvYi8kdy0kMiA+ICQxL3Jl
cy9maW8vJHctJDItJHIgMj4mMQogICAgICAgICAgIGVjaG8gLW4gIiAiICQ/ID4+ICQxL3Jlcy8k
dy0kMgogICAgICAgIGRvbmUKICAgIGRvbmUKICAgIAogICAgZm9yIHcgaW4gcmVhZHdyaXRlIHJh
bmRydyByYW5kd3JpdGUgcmFuZHJlYWQgd3JpdGUgcmVhZCA7IGRvCiAgICAgICAgZWNobyAiIiA+
PiAkMS9yZXMvJHctJDIKICAgIGRvbmUKfQoKaWYgWyAteiAiJDEiIF07IHRoZW4KICAgIGVjaG8g
InNwZWNpZnkgcGF0aC4gKFRvIHVzZSBzc2Qgb3IgaGRkKSIKICAgIGV4aXQgMQpmaQoKcGF0aD0k
MQpybSAtcmYgJDEvam9iCnJtIC1yZiAkMS9yZXMKcm0gLXJmICQxL2Zpbwpta2RpciAtcCAkMS9q
b2IKbWtkaXIgLXAgJDEvcmVzL2Zpbwpta2RpciAtcCAkMS9maW8KCgpmb3IgbCBpbiAxIDIgMyA7
IGRvCiAgICBmb3IgZCBpbiAwIDEgOyBkbwogICAgICAgIGZvciBxIGluIDEgNCAzMiA7IGRvCiAg
ICAgICAgICAgIGZvciBpIGluIHN5bmMgbGliYWlvIDsgZG8KICAgICAgICAgICAgICAgIGZvciBi
IGluIDAgMSA7IGRvCiAgICAgICAgICAgICAgICAgICAgZm9yIHMgaW4gMCAxIDsgZG8KICAgICAg
ICAgICAgICAgICAgICAgICAgZm9yIHYgaW4gbWQ1IGNyYzY0IHNoYTI1NiBzaGExIG1ldGEgOyBk
bwogICAgICAgICAgICAgICAgICAgICAgICAgICAgaj0iJHYtJGktJHEtJGQtJGItJHMtJGwiCiAg
ICAgICAgICAgICAgICAgICAgICAgICAgICBmb3IgdyBpbiByZWFkd3JpdGUgcmFuZHJ3IHJhbmR3
cml0ZSByYW5kcmVhZCB3cml0ZSByZWFkIDsgZG8KICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIGNhdCA+ICQxL2pvYi8kdy0kaiA8PCBFT0YKWyRqXQpmaWxlbmFtZT0kMS9maW8vJGoKbG9v
cHM9JGwKZGlyZWN0PSRkCmlvZGVwdGg9JHEKaW9lbmdpbmU9JGkKdmVyaWZ5PSR2CnNpemU9MW0K
YnM9NGsKcnc9JHcKdmVyaWZ5c29ydD0kcwp2ZXJpZnlfYmFja2xvZz0kYgpFT0YKICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIGRvbmUKICAgICAgICAgICAgICAgICAgICAgICAgICAgIHdoaWxl
IFsgJChwcyAtQSB8IGdyZXAgZmlvIC1jKSAtZ3QgMzIgXTsgZG8KICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICBzbGVlcCAxCiAgICAgICAgICAgICAgICAgICAgICAgICAgICBkb25lCiAg
ICAgICAgICAgICAgICAgICAgICAgICAgICBkb19maW8gJDEgJGogJgogICAgICAgICAgICAgICAg
ICAgICAgICBkb25lCiAgICAgICAgICAgICAgICAgICAgZG9uZQogICAgICAgICAgICAgICAgZG9u
ZQogICAgICAgICAgICBkb25lCiAgICAgICAgZG9uZQogICAgZG9uZQpkb25lCndhaXQKY2F0ICQx
L3Jlcy8qIHwgc29ydCB8IGF3ayAne3ByaW50ICQyICIgIiAkMyIgIiAkNCAiICIgJDUgIiAiICQ2
ICIgIiAkMX0nfCB0ZWUgJDEvcmVzL3Jlc3VsdAoK
--047d7b3a830029bd1904f1c177d4--

