Return-Path: <axboe@kernel.dk>
Subject: Re: question about fio write offset
References: <tencent_E24C0F8C628C11E92A4A21798A161CE7E207@qq.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <b5f70d74-236f-ae85-bc03-75c3b262d387@kernel.dk>
Date: Tue, 13 Mar 2018 10:51:52 -0700
MIME-Version: 1.0
In-Reply-To: <tencent_E24C0F8C628C11E92A4A21798A161CE7E207@qq.com>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
To: wk <304702903@qq.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 3/12/18 7:59 PM, wk wrote:
> Hi, axboe:
>=20
> =EF=BF=BD =EF=BF=BDSorry for write email to you directly.
>=20
> =EF=BF=BD =EF=BF=BD I have a question about fio. I want generate a =EF=BF=
=BDwrite sequence:
> =EF=BF=BD =EF=BF=BD first write: =EF=BF=BD =EF=BF=BD 0-8KB
> =EF=BF=BD =EF=BF=BD second write: 4-12KB
> =EF=BF=BD =EF=BF=BD third write : =EF=BF=BD =EF=BF=BD8-16KB
> =EF=BF=BD =EF=BF=BD forth wirte: =EF=BF=BD =EF=BF=BD 12-20KB
> =EF=BF=BD =EF=BF=BD fifth write: =EF=BF=BD =EF=BF=BD =EF=BF=BD 16KB-24KB
>=20
> =EF=BF=BD =EF=BF=BD Each io is 8KB, and next io offset is 4KB. How to wri=
te the fio command?
> =EF=BF=BD =EF=BF=BD I test "fio --ioengine=3Dlibaio --direct=3D1 --rw=3Dr=
andwrite --number_ios=3D4 =EF=BF=BD--norandommap --randrepeat=3D0 --iodepth=
=3D1 --size=3D100% --numjobs=3D1 --bs=3D8k =EF=BF=BD--filename=3D/dev/nvme0=
n1 --loops=3D1 =EF=BF=BD--blockalign=3D4096 --debug=3Dio --name=3DDI_Stress=
", but it seems each io offset is multiple of 4KB.But it is =EF=BF=BDnot ov=
erlap last 8KB =EF=BF=BDwrited block.
>=20
> =EF=BF=BD =EF=BF=BD =EF=BF=BDI also test "fio --ioengine=3Dlibaio --direc=
t=3D1 --rw=3Dwrite --number_ios=3D4 =EF=BF=BD--norandommap --randrepeat=3D0=
 --iodepth=3D1 --size=3D100% --numjobs=3D1 --bs=3D8k =EF=BF=BD--filename=3D=
/dev/nvme0n1 --loops=3D1 =EF=BF=BD--blockalign=3D4096 --debug=3Dio --name=
=3DDI_Stress", but it seems each io offset is multiple of 4KB.But it is =EF=
=BF=BDnot overlap IO. Some fio log is below:
> =EF=BF=BD =EF=BF=BD io complete: io_u 0x1f21600: off=3D0/len=3D8192/ddir=
=3D1io
> =EF=BF=BD =EF=BF=BD io complete: io_u 0x1f21600: off=3D8192/len=3D8192/dd=
ir=3D1io
> =EF=BF=BD =EF=BF=BD io complete: io_u 0x1f21600: off=3D16384/len=3D8192/d=
dir=3D1io
> =EF=BF=BD =EF=BF=BD io complete: io_u 0x1f21600: off=3D24576/len=3D8192/d=
dir=3D1io
> I want change the red offset address '0/8192/16384/24576' to '0/4096/8192=
/12288' by change my FIO command.

Don't email me directly, I've CC'ed the proper list.

You're supposed to be able to do that with:

bs=3D8k
rw=3Dwrite:-4k

which will write 0..8k, 4..12k, etc. But there's a bug there, so you need to
update to latest -git first, it needs this commit:

commit 69b98f11d62cb12482130fac79b8ebf00c0bb139
Author: Jens Axboe <axboe@kernel.dk>
Date:   Tue Mar 13 11:49:55 2018 -0600

    io_u: only rewind file position if it's non-zero

and it should work for you.

--=20
Jens Axboe


