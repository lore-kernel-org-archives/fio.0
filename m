Return-Path: <dehrenberg@google.com>
MIME-Version: 1.0
In-Reply-To: <4F6310F4.8000000@kernel.dk>
References: <1331867567-25371-1-git-send-email-dehrenberg@google.com>
	<4F6310F4.8000000@kernel.dk>
Date: Fri, 16 Mar 2012 10:46:00 -0700
Message-ID: <CAAK6Zt0+fs8P1Xvw_PQHUKGRowF9RhvgxwqhRXTYSrQCfC==xw@mail.gmail.com>
Subject: Re: [PATCH] time_based: Avoid restarting main I/O loop
From: Daniel Ehrenberg <dehrenberg@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, nauman@google.com, egouriou@google.com, tirea@google.com
List-ID: <fio@vger.kernel.org>

On Fri, Mar 16, 2012 at 3:07 AM, Jens Axboe <axboe@kernel.dk> wrote:
> On 03/16/2012 04:12 AM, Dan Ehrenberg wrote:
>> Previously, when fio had written a volume of I/O equal to the size
>> argument, it restarted the main do_io loop.
>>
>> This patch allows time_based tests to be run for longer than one
>> cycle in the do_io main loop. This has a couple of advantages:
>> =A0* The random number generator is not reset on each iteration
>> =A0 =A0of the loop, so running longer will reach different locations.
>> =A0* There is not a throughput-reducing point where all operations
>> =A0 =A0must be reaped before new operations are submitted.
>>
>> The implementation consists of two minor changes:
>> =A0* In the do_io loop, a time_based test will not exit the loop for
>> =A0 =A0reading or writing too much data.
>> =A0* When reading or writing sequentially, the operations wrap around
>> =A0 =A0to the beginning after reading the end within the
>> =A0 =A0get_next_seq_block function.
>
> This looks good, but one question - does it really behave with random
> IO, when the random map is enabled? I set write_iolog and looked at the
> patterns. From the beginning:
>
> foo.1.0 add
> foo.1.0 open
> foo.1.0 read 8093696 4096
> foo.1.0 read 99356672 4096
> foo.1.0 read 113164288 4096
> [...]
> foo.1.0 close
> foo.1.0 open
> foo.1.0 read 8093696 4096
> foo.1.0 read 99356672 4096
> foo.1.0 read 113164288 4096
> [...]
>
> etc. So it's definitely repeating the same sequence there. We don't want
> to close/open the file for this case either, how does the below
> look/work for you? It's your patch, and an update in
> get_next_rand_block() to handle this case too.
>
> diff --git a/backend.c b/backend.c
> index 7343286..1d9b0a2 100644
> --- a/backend.c
> +++ b/backend.c
> @@ -555,7 +555,8 @@ static void do_io(struct thread_data *td)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0td_set_runstate(td, TD_RUNNING);
>
> =A0 =A0 =A0 =A0while ((td->o.read_iolog_file && !flist_empty(&td->io_log_=
list)) ||
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 (!flist_empty(&td->trim_list)) || !io_bytes=
_exceeded(td)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 (!flist_empty(&td->trim_list)) || !io_bytes=
_exceeded(td) ||
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 td->o.time_based) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct timeval comp_time;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned long bytes_done[2] =3D { 0, 0 };
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0int min_evts =3D 0;
> diff --git a/io_u.c b/io_u.c
> index 20794c3..3bda0e6 100644
> --- a/io_u.c
> +++ b/io_u.c
> @@ -238,13 +238,18 @@ ret:
> =A0static int get_next_rand_block(struct thread_data *td, struct fio_file=
 *f,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 enum fio_ddir=
 ddir, unsigned long long *b)
> =A0{
> - =A0 =A0 =A0 if (get_next_rand_offset(td, f, ddir, b)) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 dprint(FD_IO, "%s: rand offset failed, last=
=3D%llu, size=3D%llu\n",
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 f->file_nam=
e, f->last_pos, f->real_file_size);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 1;
> + =A0 =A0 =A0 if (!get_next_rand_offset(td, f, ddir, b))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> +
> + =A0 =A0 =A0 if (td->o.time_based) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 fio_file_reset(f);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!get_next_rand_offset(td, f, ddir, b))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 return 0;
> + =A0 =A0 =A0 dprint(FD_IO, "%s: rand offset failed, last=3D%llu, size=3D=
%llu\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 f->file_name, f->last_pos, =
f->real_file_size);
> + =A0 =A0 =A0 return 1;
> =A0}
>
> =A0static int get_next_seq_block(struct thread_data *td, struct fio_file =
*f,
> @@ -252,6 +257,9 @@ static int get_next_seq_block(struct thread_data *td,=
 struct fio_file *f,
> =A0{
> =A0 =A0 =A0 =A0assert(ddir_rw(ddir));
>
> + =A0 =A0 =A0 if (f->last_pos >=3D f->io_size && td->o.time_based)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 f->last_pos =3D f->last_pos - f->io_size;
> +
> =A0 =A0 =A0 =A0if (f->last_pos < f->real_file_size) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned long long pos;
>
>
>
> --
> Jens Axboe
>

Thanks for the correction, Jens. I only tested my code with
norandommap, forgetting about the default case. Your modified patch
seems to fix the issue in a nice simple way. I would be happy to see
this new patch committed.

Dan

