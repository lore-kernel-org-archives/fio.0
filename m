Return-Path: <gschoenberger@thomas-krenn.com>
Message-ID: <4FA12358.7010204@thomas-krenn.com>
Date: Wed, 02 May 2012 14:06:48 +0200
From: =?ISO-8859-15?Q?Georg_Sch=F6nberger?=
 <gschoenberger@thomas-krenn.com>
MIME-Version: 1.0
Subject: Re: Tell fio to only lay out files
References: <4FA0FB19.6010506@thomas-krenn.com> <4FA10E08.70009@fusionio.com> <4FA11FC5.4030202@thomas-krenn.com> <4FA120C2.6080205@kernel.dk>
In-Reply-To: <4FA120C2.6080205@kernel.dk>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

I get the following error after applying the patch:
$ patch -b -p1 < fio.patch
...make and install...
$ fio --create_only --name=3Dtest-read-4k-4G-1-jobs --directory=3D./tests
--rw=3Dread --size=3D10M --bs=3D4k --numjobs=3D4 --group_reporting
max value out of range: 4 (1 max)
max value out of range: 4 (1 max)

Georg

Am 2012-05-02 13:55, schrieb Jens Axboe:
> On 05/02/2012 01:51 PM, Georg Sch=EF=BF=BDnberger wrote:
>> Thanks for your fast patch, I really appreciate that :-)
>> The create_only option now helps me to start with a consistent cache
>> state for every test run.
> Did you test it? I'll add the option to the man page and HOWTO and
> commit, then.
>

