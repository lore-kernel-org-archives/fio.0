Return-Path: <fio-owner@vger.kernel.org>
Received: from col0-omc1-s6.col0.hotmail.com ([65.55.34.16]:27994 "EHLO
	col0-omc1-s6.col0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752578Ab3IIScd convert rfc822-to-8bit
	(ORCPT <rfc822;fio@vger.kernel.org>); Mon, 9 Sep 2013 14:32:33 -0400
Message-ID: <COL131-W737F4B7642E5118C84B254B53F0@phx.gbl>
From: Suresh P <suresh_p_@hotmail.com>
Subject: io_u requeue and resubmit
Date: Mon, 9 Sep 2013 18:32:33 +0000
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

I have a question on requeue_io_u. Code source lines reference here are fro=
m version fio-2.1.2.

Does a requeued io_u work get submitted again through __get_io_u() ? If so,=
 the io_u item is taken out of requeue list & then the io_u->file is set to=
 NULL. We don't make a distinction about item being already setup Vs a new =
io_u in __get_io_u().=EF=BF=BDIn get_io_u(), when an io_u may come out of r=
equeue list, we depend on io_u->file to be non NULL to detect the work as o=
ld pending one.

Am I missing something here or is this a bug?

1274 =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD io_u =3D __get_io_u(td);
1275 =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD if (!io_u) {
1276 =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =
=EF=BF=BD dprint(FD_IO, "__get_io_u failed\n");
1277 =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =
=EF=BF=BD return NULL;
1278 =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD }
1279=EF=BF=BD
1280 =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD if (check_get_verify(td, io_u))
1281 =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =
=EF=BF=BD goto out;
1282 =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD if (check_get_trim(td, io_u))
1283 =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =
=EF=BF=BD goto out;
1284=EF=BF=BD
1285 =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD /*
1286 =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD* from a requeue, io_=
u already setup
1287 =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD*/
1288 =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD if (io_u->file)
1289 =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =
=EF=BF=BD goto out;
1290=EF=BF=BD
"io_u.c" line 1286 of 1667 --77%-- col 3-10


1130 struct io_u *__get_io_u(struct thread_data *td)
1131 {
1132 =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD struct io_u *io_u;
1133=EF=BF=BD
1134 =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD td_io_u_lock(td);
1135=EF=BF=BD
1136 again:
1137 =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD if (!io_u_rempty(&td->io_u_req=
ueues))
1138 =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =
=EF=BF=BD io_u =3D io_u_rpop(&td->io_u_requeues);
1139 =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD else if (!io_u_qempty(&td->io_=
u_freelist))
1140 =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =
=EF=BF=BD io_u =3D io_u_qpop(&td->io_u_freelist);
1141=EF=BF=BD
1142 =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD if (io_u) {
1143 =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =
=EF=BF=BD io_u->buflen =3D 0;
1144 =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =
=EF=BF=BD io_u->resid =3D 0;
1145 =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =
=EF=BF=BD io_u->file =3D NULL;
1146 =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =
=EF=BF=BD io_u->end_io =3D NULL;
1147 =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD }
"io_u.c" line 1130 of 1667 --67%-- col 1

Thanks,
Suresh 		 	   		  