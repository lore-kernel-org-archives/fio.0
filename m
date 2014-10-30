Return-Path: <axboe@kernel.dk>
Message-ID: <54524DEA.8010109@kernel.dk>
Date: Thu, 30 Oct 2014 08:40:42 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: anonymous mmap issue on solaris
References: <5416a70b91da426280173bb27a43f0e7@DB4PR03MB572.eurprd03.prod.outlook.com>
In-Reply-To: <5416a70b91da426280173bb27a43f0e7@DB4PR03MB572.eurprd03.prod.outlook.com>
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
To: =?windows-1252?Q?S=E9bastien_Bouchex_Bellomi=E9?= <sbouchex@infovista.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 2014-10-30 08:06, S=EF=BF=BDbastien Bouchex Bellomi=EF=BF=BD wrote:
> Hi,
>
> An issue on solaris :
>
> Anonymous mmap must have a fd set to -1 in order to work (on linux, it is=
 ignored), in alloc_mem_mmap, the fd is set to 1
>
> [.]
> static int alloc_mem_mmap(struct thread_data *td, size_t total_mem)
> {
>                  int flags =3D 0;
>
>                  td->mmapfd =3D 1;
>
>                  if (td->o.mem_type =3D=3D MEM_MMAPHUGE) {
> [.]
>
> Changing it to -1 makes the code working fine.

That actually just looks like a typo, it makes no sense for this to be=20
'1'... I'll fix it, thanks for finding it!

--=20
Jens Axboe


