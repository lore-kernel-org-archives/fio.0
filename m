Return-Path: <fio-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:28508 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801Ab1JYVAs convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Tue, 25 Oct 2011 17:00:48 -0400
Received: from wpaz37.hot.corp.google.com (wpaz37.hot.corp.google.com [172.24.198.101])
	by smtp-out.google.com with ESMTP id p9PL0kC3001168
	for <fio@vger.kernel.org>; Tue, 25 Oct 2011 14:00:46 -0700
Received: from ywa8 (ywa8.prod.google.com [10.192.1.8])
	by wpaz37.hot.corp.google.com with ESMTP id p9PKxuos001547
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <fio@vger.kernel.org>; Tue, 25 Oct 2011 14:00:45 -0700
Received: by ywa8 with SMTP id 8so1339120ywa.1
        for <fio@vger.kernel.org>; Tue, 25 Oct 2011 14:00:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAUT-yMxJ5_m4VPKohuoLj7CHAqpdOT2_17NZ5F86GM-1+xW-A@mail.gmail.com>
References: <CAAUT-yMxJ5_m4VPKohuoLj7CHAqpdOT2_17NZ5F86GM-1+xW-A@mail.gmail.com>
From: Steven Lang <tirea@google.com>
Date: Tue, 25 Oct 2011 14:00:25 -0700
Message-ID: <CAAUT-yN2GavnfhWwYp7ZjfF1L6V9FOkudHyowLGBj2b0ZGi-Vw@mail.gmail.com>
Subject: Re: [PATCH] Fix segfault with verify_async
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Jens Axboe <jaxboe@fusionio.com>

FYI - this is the minimal config to cause the error this patch fixes,
and is what I used to test the fix.  (Not using thread still causes a
segfault, but it is reported more subtly since just a sub-process hits
it.)

[segv]
ioengine=3Dnull
size=3D4k
verify=3Dmeta
rw=3Dread
thread
verify_async=3D1

On Tue, Oct 25, 2011 at 1:23 PM, Steven Lang <tirea@google.com> wrote:
> At some point the filename was added to the report on verify failures,
> however this broke verify_async, as the file pointer on the io_u is
> set to NULL before the verify thread sees the io_u. =EF=BF=BDThe result i=
s a
> segfault when there is a verify mismatch.
>
> This patch changes the semantics of a deferred free (IO_U_F_FREE_DEF)
> to have already called put_file, but not set the file pointer to NULL.
> =EF=BF=BDThis is safe to do as the file list is only freed after all the
> verify threads have been terminated.
>
> diff --git a/io_u.c b/io_u.c
> index d1f66a9..fc3ee49 100644
> --- a/io_u.c
> +++ b/io_u.c
> @@ -597,13 +597,12 @@ void put_io_u(struct thread_data *td, struct io_u *=
io_u)
> =EF=BF=BD{
> =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BDtd_io_u_lock(td);
>
> - =EF=BF=BD =EF=BF=BD =EF=BF=BD io_u->flags |=3D IO_U_F_FREE;
> - =EF=BF=BD =EF=BF=BD =EF=BF=BD io_u->flags &=3D ~IO_U_F_FREE_DEF;
> -
> - =EF=BF=BD =EF=BF=BD =EF=BF=BD if (io_u->file)
> + =EF=BF=BD =EF=BF=BD =EF=BF=BD if (io_u->file && !(io_u->flags & IO_U_F_=
FREE_DEF))
> =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=
=BF=BDput_file_log(td, io_u->file);
> -
> =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BDio_u->file =3D NULL;
> + =EF=BF=BD =EF=BF=BD =EF=BF=BD io_u->flags &=3D ~IO_U_F_FREE_DEF;
> + =EF=BF=BD =EF=BF=BD =EF=BF=BD io_u->flags |=3D IO_U_F_FREE;
> +
> =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BDif (io_u->flags & IO_U_F_IN_CUR_DE=
PTH)
> =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=
=BF=BDtd->cur_depth--;
> =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BDflist_del_init(&io_u->list);
> diff --git a/verify.c b/verify.c
> index c450e88..68ee60f 100644
> --- a/verify.c
> +++ b/verify.c
> @@ -599,10 +599,8 @@ int verify_io_u_async(struct thread_data *td,
> struct io_u *io_u)
> =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BDif (io_u->file)
> =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=
=BF=BDput_file_log(td, io_u->file);
>
> - =EF=BF=BD =EF=BF=BD =EF=BF=BD io_u->file =3D NULL;
> -
> =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BDpthread_mutex_lock(&td->io_u_lock);
> -
> +
> =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BDif (io_u->flags & IO_U_F_IN_CUR_DE=
PTH) {
> =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=
=BF=BDtd->cur_depth--;
> =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=
=BF=BDio_u->flags &=3D ~IO_U_F_IN_CUR_DEPTH;
>
