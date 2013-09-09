Return-Path: <suresh_p_@hotmail.com>
Message-ID: <COL131-W87B2CD660B8B46BBDC883CB53F0@phx.gbl>
From: Suresh P <suresh_p_@hotmail.com>
Subject: RE: io_u requeue and resubmit
Date: Mon, 9 Sep 2013 21:51:59 +0000
In-Reply-To: <522E3B2D.5060400@kernel.dk>
References: 
 <COL131-W737F4B7642E5118C84B254B53F0@phx.gbl>,<522E3B2D.5060400@kernel.dk>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Thanks Jens..that was quick!=0A=
=0A=
----------------------------------------=0A=
> Date: Mon=2C 9 Sep 2013 15:18:37 -0600=0A=
> From: axboe@kernel.dk=0A=
> To: suresh_p_@hotmail.com=0A=
> CC: fio@vger.kernel.org=0A=
> Subject: Re: io_u requeue and resubmit=0A=
>=0A=
> On 09/09/2013 12:32 PM=2C Suresh P wrote:=0A=
>> I have a question on requeue_io_u. Code source lines reference here are =
from version fio-2.1.2.=0A=
>>=0A=
>> Does a requeued io_u work get submitted again through __get_io_u() ? If =
so=2C the io_u item is taken out of requeue list & then the io_u->file is s=
et to NULL. We don't make a distinction about item being already setup Vs a=
 new io_u in __get_io_u(). In get_io_u()=2C when an io_u may come out of re=
queue list=2C we depend on io_u->file to be non NULL to detect the work as =
old pending one.=0A=
>>=0A=
>> Am I missing something here or is this a bug?=0A=
>>=0A=
>> 1274 io_u =3D __get_io_u(td)=3B=0A=
>> 1275 if (!io_u) {=0A=
>> 1276 dprint(FD_IO=2C "__get_io_u failed\n")=3B=0A=
>> 1277 return NULL=3B=0A=
>> 1278 }=0A=
>> 1279=0A=
>> 1280 if (check_get_verify(td=2C io_u))=0A=
>> 1281 goto out=3B=0A=
>> 1282 if (check_get_trim(td=2C io_u))=0A=
>> 1283 goto out=3B=0A=
>> 1284=0A=
>> 1285 /*=0A=
>> 1286 * from a requeue=2C io_u already setup=0A=
>> 1287 */=0A=
>> 1288 if (io_u->file)=0A=
>> 1289 goto out=3B=0A=
>> 1290=0A=
>> "io_u.c" line 1286 of 1667 --77%-- col 3-10=0A=
>>=0A=
>>=0A=
>> 1130 struct io_u *__get_io_u(struct thread_data *td)=0A=
>> 1131 {=0A=
>> 1132 struct io_u *io_u=3B=0A=
>> 1133=0A=
>> 1134 td_io_u_lock(td)=3B=0A=
>> 1135=0A=
>> 1136 again:=0A=
>> 1137 if (!io_u_rempty(&td->io_u_requeues))=0A=
>> 1138 io_u =3D io_u_rpop(&td->io_u_requeues)=3B=0A=
>> 1139 else if (!io_u_qempty(&td->io_u_freelist))=0A=
>> 1140 io_u =3D io_u_qpop(&td->io_u_freelist)=3B=0A=
>> 1141=0A=
>> 1142 if (io_u) {=0A=
>> 1143 io_u->buflen =3D 0=3B=0A=
>> 1144 io_u->resid =3D 0=3B=0A=
>> 1145 io_u->file =3D NULL=3B=0A=
>> 1146 io_u->end_io =3D NULL=3B=0A=
>> 1147 }=0A=
>> "io_u.c" line 1130 of 1667 --67%-- col 1=0A=
>=0A=
> Good catch! It was actually broken a few revisions back with the ring=0A=
> lists. Fixed:=0A=
>=0A=
> http://git.kernel.dk/?p=3Dfio.git=3Ba=3Dcommit=3Bh=3Df713350f74dbeb333ff1=
ad2790cb60381ceaf463=0A=
>=0A=
> --=0A=
> Jens Axboe=0A=
>=0A=
> --=0A=
> To unsubscribe from this list: send the line "unsubscribe fio" in=0A=
> the body of a message to majordomo@vger.kernel.org=0A=
> More majordomo info at http://vger.kernel.org/majordomo-info.html 		 	   =
		  =

