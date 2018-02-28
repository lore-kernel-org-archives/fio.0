Return-Path: <fio-owner@vger.kernel.org>
Received: from m50-132.163.com ([123.125.50.132]:54336 "EHLO m50-132.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752328AbeB1IpM (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 28 Feb 2018 03:45:12 -0500
From: "Vaughan" <cxt9401@163.com>
References: <000801d3afb8$1ffb6a10$5ff23e30$@163.com> <CALjAwxgYcdTe68JPjo6fJHOYc=nD_Tb8Tyd995D1ONbQx3Lvjg@mail.gmail.com>
In-Reply-To: <CALjAwxgYcdTe68JPjo6fJHOYc=nD_Tb8Tyd995D1ONbQx3Lvjg@mail.gmail.com>
Subject: =?UTF-8?Q?=E7=AD=94=E5=A4=8D:_How_to_ensure_split_verifica?=
        =?UTF-8?Q?tion_will_generate_the_same_conf?=
        =?UTF-8?Q?igs_as_write_phase=3F?=
Date: Wed, 28 Feb 2018 16:44:59 +0800
Message-ID: <000101d3b070$6b165dd0$41431970$@163.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Content-Language: zh-cn
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: 'Sitsofe Wheeler' <sitsofe@gmail.com>
Cc: 'fio' <fio@vger.kernel.org>

> ^^^ Here's a problem - you can't randomly write and then verify =
sequentially via a different run. In your case you need rw=3Drandread.
Yes. It's my fault to paste the original content of the buggy job file. =
I understand that rw=3D option should be paired with or without rand- =
prefix.

> The  randseed is the same across different invocations of fio unless =
you say otherwise (see randrepeat - =
http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-randrepeat=

> ). So even if you weren't using a verification state file you will =
re-generate the same pattern if the rest of the job is the same.
Thank you for the explanation. A deep question about the seed comes:) =
Though randseed is the same across different invocation of fio, is it =
different for different sections in one job file?

I made another job file as below:
myjob.fio:
	[global]=20
	bs=3D4k   =20
	direct=3D1=20
	ioengine=3Dsync
	verify=3Dcrc32c =20
	filename=3D/dev/sdf
	io_size=3D10k

	[write-phase] =20
	rw=3Drandwrite
	do_verify=3D0
	write_iolog=3Diolog

	[verify-phase]
	stonewall
	rw=3Drandread
	do_verify=3D1

I think these two sections have the same settings except the date =
direction. So I expect the later one can verify the write-phase. But it =
failed.=09
run it with --debug, and found the offset generated are not the same, so =
verify abort with error for the first time, as below:=20
	random   24382 off rand 259043585
	io       24382 fill_io_u: io_u 0x25ad740: =
off=3D71233536/len=3D4096/ddir=3D1//dev/sdf
	random   24382 off rand 3179521932
	io       24382 fill_io_u: io_u 0x25ad740: =
off=3D874364928/len=3D4096/ddir=3D1//dev/sdf
	random   24382 off rand 3621444214
	io       24382 fill_io_u: io_u 0x25ad740: =
off=3D995893248/len=3D4096/ddir=3D1//dev/sdf
	random   24388 off rand 1094293889
	io       24388 fill_io_u: io_u 0x25ad500: =
off=3D300929024/len=3D4096/ddir=3D0//dev/sdf
You can see [24382] is write-phase and [24388] is verify-phase, and the =
first round of them use different seed I suppose.

I search in the source code, and found the following snippet:
	static int setup_random_seeds(struct thread_data *td)
	{
	...
			for (i =3D 0; i < FIO_RAND_NR_OFFS; i++) {
					td->rand_seeds[i] =3D seed * td->thread_number + i;
					seed *=3D 0x9e370001UL;
			}              =20

Is td->thread_number different for different sections? I thought they =
both equal to 1 before.

Later, I realize split verify using two sections in one file is not a =
formal way? Is it better to just write only one write section, and use =
'fio --verify-only jobfile' to do the split verification as the updated =
one below?

myjob.fio updated:
	[global]=20
	bs=3D4k   =20
	direct=3D1=20
	ioengine=3Dsync
	verify=3Dcrc32c =20
	filename=3D/dev/sdf
	io_size=3D10k

	[write-phase] =20
	rw=3Drandwrite
	do_verify=3D0

Thank you very much again!

Regards,
Vaughan


