Return-Path: <axboe@kernel.dk>
Message-ID: <532AFB4A.7000707@kernel.dk>
Date: Thu, 20 Mar 2014 08:29:30 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: unlink=1 issue on Windows
References: <c1160a632c8b42e28487bf5902346d7e@DB4PR03MB572.eurprd03.prod.outlook.com>
In-Reply-To: <c1160a632c8b42e28487bf5902346d7e@DB4PR03MB572.eurprd03.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
Content-Transfer-Encoding: quoted-printable
To: =?ISO-8859-1?Q?S=E9bastien_Bouchex_Bellomi=E9?= <sbouchex@infovista.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 03/19/2014 10:02 AM, S=EF=BF=BDbastien Bouchex Bellomi=EF=BF=BD wrote:
> Hi,
>
> I'm having an issue on windows : unlink=3D1 is not working (temp file are=
 still there) and it's working fine on unix
>
> Looking at the code in close_and_free_files function :
>
> [...]
> if (td->o.unlink && f->filetype =3D=3D FIO_TYPE_FILE) {
> 			dprint(FD_FILE, "free unlink %s\n", f->file_name);
> 			unlink(f->file_name);
> 		}
> [...]
>
> Unlink() fails because the file is still open : On Solaris, truss shows t=
he following :
>
> [...]
> write(3, "\0\0\0\0\0 ;80\0\0\0\0\0".., 32768)   =3D 32768
> unlink("/data/fio/random_rw.0.0")               =3D 0
> close(3)                                        =3D 0
> [...]
>
> So unlink is called first.
>
> I would put this unlinking phase AFTER the remove_file_hash call.

Sure, we can move the unlink down a bit, should not matter really. Linux=20
doesn't care when you call unlink, last close will just really unlink=20
it. But if other operating systems do care, then I'll just move it.

http://git.kernel.dk/?p=3Dfio.git;a=3Dcommit;h=3Db5f4d8baefc6eb3e13235b7d90=
42b7ffecdb23dd

--=20
Jens Axboe


