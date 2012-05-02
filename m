Return-Path: <gschoenberger@thomas-krenn.com>
Message-ID: <4FA1249D.6000104@thomas-krenn.com>
Date: Wed, 02 May 2012 14:12:13 +0200
From: =?ISO-8859-15?Q?Georg_Sch=F6nberger?=
 <gschoenberger@thomas-krenn.com>
MIME-Version: 1.0
Subject: Re: Tell fio to only lay out files
References: <4FA0FB19.6010506@thomas-krenn.com> <4FA10E08.70009@fusionio.com> <4FA11FC5.4030202@thomas-krenn.com> <4FA120C2.6080205@kernel.dk> <4FA12358.7010204@thomas-krenn.com> <4FA123A3.5030801@kernel.dk>
In-Reply-To: <4FA123A3.5030801@kernel.dk>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Same error after a clean compilation.
$ fio --version
fio-2.0.7-13-g3b7f
$ fio --create_only --name=3Dtest-read-4k-4G-1-jobs --directory=3D./tests
--rw=3Dread --size=3D10M --bs=3D4k --numjobs=3D4
max value out of range: 4 (1 max)
max value out of range: 4 (1 max)

Am 2012-05-02 14:08, schrieb Jens Axboe:
> On 05/02/2012 02:06 PM, Georg Sch=EF=BF=BDnberger wrote:
>> I get the following error after applying the patch:
>> $ patch -b -p1 < fio.patch
>> ...make and install...
>> $ fio --create_only --name=3Dtest-read-4k-4G-1-jobs --directory=3D./tests
>> --rw=3Dread --size=3D10M --bs=3D4k --numjobs=3D4 --group_reporting
>> max value out of range: 4 (1 max)
>> max value out of range: 4 (1 max)
> You probably want to make clean first.
>

