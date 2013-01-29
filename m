Return-Path: <Antonio.Jose.Rodrigues.Neto@netapp.com>
From: "Neto, Antonio Jose Rodrigues" <Antonio.Jose.Rodrigues.Neto@netapp.com>
Subject: RE: Group reporting with latency and IOPS
Date: Tue, 29 Jan 2013 20:40:02 +0000
Message-ID: <843E15216120C047928F6879B0E2D9240F6D3A0D@SACEXCMBX02-PRD.hq.netapp.com>
References: <20130129130212.GB8800@kernel.dk>
 <843E15216120C047928F6879B0E2D9240F6D243A@SACEXCMBX02-PRD.hq.netapp.com>
 <20130129134652.GF8800@kernel.dk>
 <843E15216120C047928F6879B0E2D9240F6D26D5@SACEXCMBX02-PRD.hq.netapp.com>
 <20130129135401.GG8800@kernel.dk>
 <843E15216120C047928F6879B0E2D9240F6D27A5@SACEXCMBX02-PRD.hq.netapp.com>
 <20130129201005.GH8800@kernel.dk>
 <843E15216120C047928F6879B0E2D9240F6D396C@SACEXCMBX02-PRD.hq.netapp.com>
 <20130129203239.GJ8800@kernel.dk>
In-Reply-To: <20130129203239.GJ8800@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On Tue, Jan 29 2013, Neto, Antonio Jose Rodrigues wrote:
> Jens, sorry to bother you again, but I am trying to apply the I've got=20
> this=3D  error. Could you please help me how to fix it?

I forgot to push a previous change out. Pull again and try applying, should=
 apply without fuzz.

I am afraid that I am doing something wrong.... The latest change (pull) wa=
s in client.c. I pulled, copied the whole directory but same error.=20

[root@mickey fio]# patch <a.diff
patching file client.c
Hunk #1 succeeded at 595 with fuzz 1.
patching file eta.c
patch: **** malformed patch at line 38: @@ -235,19 +236,32 @@ static void c=
alc_rate(unsigned long mtime, unsigned long long *io_bytes,

