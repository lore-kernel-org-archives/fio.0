Return-Path: <ctuffli@gmail.com>
MIME-Version: 1.0
From: Chuck Tuffli <ctuffli@gmail.com>
Date: Fri, 27 Aug 2010 09:40:59 -0600
Subject: Re: using ioengine=sg
Message-ID: <AANLkTikN0M5eVXOAi9APqeS2Q7tiuYPacMsWiO0FnAWC@mail.gmail.com>
References: <AANLkTimTvSmj-1L80KAyVf7uv9d+vDENsMj-_bFDqRBR@mail.gmail.com>
	<4C776359.70403@fusionio.com>
In-Reply-To: <4C776359.70403@fusionio.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Jens Axboe <JAxboe@fusionio.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On Fri, Aug 27, 2010 at 12:03 AM, Jens Axboe <jaxboe@fusionio.com> wrote:
...
> You are not doing anything wrong, it's a bug. This patch will fix
> it.

Thanks for the patch. Now I see the following

> sudo ./fio sgtest.fio
/dev/sg2: (g=3D0): rw=3Dread, bs=3D512-512/512-512, ioengine=3Dsg, iodepth=
=3D1
Starting 1 process
Jobs: 1 (f=3D0): [R] [12900.0% done] [0K/0K /s] [0/0 iops] [eta
1158050441d:06h:58m:08s]

---chuck

