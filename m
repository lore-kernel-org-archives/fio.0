Return-Path: <fio-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:8299 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323Ab1JYUXh convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Tue, 25 Oct 2011 16:23:37 -0400
Received: from hpaq5.eem.corp.google.com (hpaq5.eem.corp.google.com [172.25.149.5])
	by smtp-out.google.com with ESMTP id p9PKNaMT010105
	for <fio@vger.kernel.org>; Tue, 25 Oct 2011 13:23:36 -0700
Received: from ywa8 (ywa8.prod.google.com [10.192.1.8])
	by hpaq5.eem.corp.google.com with ESMTP id p9PKK3Z2029339
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <fio@vger.kernel.org>; Tue, 25 Oct 2011 13:23:35 -0700
Received: by ywa8 with SMTP id 8so1215176ywa.5
        for <fio@vger.kernel.org>; Tue, 25 Oct 2011 13:23:35 -0700 (PDT)
MIME-Version: 1.0
From: Steven Lang <tirea@google.com>
Date: Tue, 25 Oct 2011 13:23:14 -0700
Message-ID: <CAAUT-yMxJ5_m4VPKohuoLj7CHAqpdOT2_17NZ5F86GM-1+xW-A@mail.gmail.com>
Subject: [PATCH] Fix segfault with verify_async
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>

At some point the filename was added to the report on verify failures,
however this broke verify_async, as the file pointer on the io_u is
set to NULL before the verify thread sees the io_u. =EF=BF=BDThe result is a
segfault when there is a verify mismatch.

This patch changes the semantics of a deferred free (IO_U_F_FREE_DEF)
to have already called put_file, but not set the file pointer to NULL.
=EF=BF=BDThis is safe to do as the file list is only freed after all the
verify threads have been terminated.

diff --git a/io_u.c b/io_u.c
index d1f66a9..fc3ee49 100644
--- a/io_u.c
+++ b/io_u.c
@@ -597,13 +597,12 @@ void put_io_u(struct thread_data *td, struct io_u *io=
_u)
 {
 	td_io_u_lock(td);

-	io_u->flags |=3D IO_U_F_FREE;
-	io_u->flags &=3D ~IO_U_F_FREE_DEF;
-
-	if (io_u->file)
+	if (io_u->file && !(io_u->flags & IO_U_F_FREE_DEF))
 		put_file_log(td, io_u->file);
-
 	io_u->file =3D NULL;
+	io_u->flags &=3D ~IO_U_F_FREE_DEF;
+	io_u->flags |=3D IO_U_F_FREE;
+
 	if (io_u->flags & IO_U_F_IN_CUR_DEPTH)
 		td->cur_depth--;
 	flist_del_init(&io_u->list);
diff --git a/verify.c b/verify.c
index c450e88..68ee60f 100644
--- a/verify.c
+++ b/verify.c
@@ -599,10 +599,8 @@ int verify_io_u_async(struct thread_data *td,
struct io_u *io_u)
 	if (io_u->file)
 		put_file_log(td, io_u->file);

-	io_u->file =3D NULL;
-
 	pthread_mutex_lock(&td->io_u_lock);
-=09
+
 	if (io_u->flags & IO_U_F_IN_CUR_DEPTH) {
 		td->cur_depth--;
 		io_u->flags &=3D ~IO_U_F_IN_CUR_DEPTH;
