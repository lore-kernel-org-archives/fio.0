Return-Path: <gschoenberger@thomas-krenn.com>
Message-ID: <4FA127C7.9040401@thomas-krenn.com>
Date: Wed, 02 May 2012 14:25:43 +0200
From: =?ISO-8859-15?Q?Georg_Sch=F6nberger?=
 <gschoenberger@thomas-krenn.com>
MIME-Version: 1.0
Subject: Re: Tell fio to only lay out files
References: <4FA0FB19.6010506@thomas-krenn.com> <4FA10E08.70009@fusionio.com> <4FA11FC5.4030202@thomas-krenn.com> <4FA120C2.6080205@kernel.dk> <4FA12358.7010204@thomas-krenn.com> <4FA123A3.5030801@kernel.dk> <4FA1249D.6000104@thomas-krenn.com> <4FA1255F.9020301@kernel.dk>
In-Reply-To: <4FA1255F.9020301@kernel.dk>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Am 2012-05-02 14:15, schrieb Jens Axboe:
> On 05/02/2012 02:12 PM, Georg Sch=EF=BF=BDnberger wrote:
>> Same error after a clean compilation.
>> $ fio --version
>> fio-2.0.7-13-g3b7f
>> $ fio --create_only --name=3Dtest-read-4k-4G-1-jobs --directory=3D./tests
>> --rw=3Dread --size=3D10M --bs=3D4k --numjobs=3D4
>> max value out of range: 4 (1 max)
>> max value out of range: 4 (1 max)
> Please don't top post, reply beneath what you are replying to.
>
> Parser looks confused, because you forgot to add the value for the
> create_only option. If you use --create_only=3D1 instead, it should work.
>
> I wonder why that isn't caught in the command line variant, if you put
> it in a job file it does catch it:
>
> axboe@nelson:/home/axboe/git/fio $ ./fio seq-null=20
> Option create_only requires an argument
> fio: failed parsing create_only
> fio: job global dropped
>
> I'll take a look at that separately.
>
That works now:
$ fio --create_only=3D1 --name=3Dtest --directory=3D./tests --rw=3Dread
--size=3D10M --bs=3D4k --numjobs=3D4
test: (g=3D0): rw=3Dread, bs=3D4K-4K/4K-4K, ioengine=3Dsync, iodepth=3D1
...
test: (g=3D0): rw=3Dread, bs=3D4K-4K/4K-4K, ioengine=3Dsync, iodepth=3D1
fio-2.0.7-13-g3b7f
Starting 4 processes
test: Laying out IO file(s) (1 file(s) / 10MB)
test: Laying out IO file(s) (1 file(s) / 10MB)
test: Laying out IO file(s) (1 file(s) / 10MB)
test: Laying out IO file(s) (1 file(s) / 10MB)


Run status group 0 (all jobs):
$ ls tests/
test.1.0  test.2.0  test.3.0  test.4.0

Nice!
Thanks, Georg

P.S.: Sorry for top posting



