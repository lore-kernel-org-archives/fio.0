Return-Path: <seth.vik@gmail.com>
MIME-Version: 1.0
In-Reply-To: <4FAAD964.2020504@kernel.dk>
References: <4FA0FB19.6010506@thomas-krenn.com>
	<4FA10E08.70009@fusionio.com>
	<4FA11FC5.4030202@thomas-krenn.com>
	<4FA120C2.6080205@kernel.dk>
	<4FA12358.7010204@thomas-krenn.com>
	<4FA123A3.5030801@kernel.dk>
	<4FA1249D.6000104@thomas-krenn.com>
	<4FA1255F.9020301@kernel.dk>
	<4FA127C7.9040401@thomas-krenn.com>
	<CAKa9NmuiOhT1+9ze2242w3pYVGLAH4Gbry2sq5vz9hW135TL3g@mail.gmail.com>
	<4FAAD964.2020504@kernel.dk>
Date: Wed, 9 May 2012 15:10:29 -0700
Message-ID: <CAKa9NmuazZ8L4GWg=F5yuayLLx2vbSNco6WApg+MjNORaD6eBg@mail.gmail.com>
Subject: Re: Tell fio to only lay out files
From: Vikram Seth <seth.vik@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
To: Jens Axboe <axboe@kernel.dk>
Cc: =?ISO-8859-1?Q?Georg_Sch=F6nberger?= <gschoenberger@thomas-krenn.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On Wed, May 9, 2012 at 1:53 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On 2012-05-09 22:52, Vikram Seth wrote:
>> On Wed, May 2, 2012 at 5:25 AM, Georg Sch=F6nberger
>> <gschoenberger@thomas-krenn.com> wrote:
>>> Am 2012-05-02 14:15, schrieb Jens Axboe:
>>>> On 05/02/2012 02:12 PM, Georg Sch=F6nberger wrote:
>>>>> Same error after a clean compilation.
>>>>> $ fio --version
>>>>> fio-2.0.7-13-g3b7f
>>>>> $ fio --create_only --name=3Dtest-read-4k-4G-1-jobs --directory=3D./t=
ests
>>>>> --rw=3Dread --size=3D10M --bs=3D4k --numjobs=3D4
>>>>> max value out of range: 4 (1 max)
>>>>> max value out of range: 4 (1 max)
>>>> Please don't top post, reply beneath what you are replying to.
>>>>
>>>> Parser looks confused, because you forgot to add the value for the
>>>> create_only option. If you use --create_only=3D1 instead, it should wo=
rk.
>>>>
>>>> I wonder why that isn't caught in the command line variant, if you put
>>>> it in a job file it does catch it:
>>>>
>>>> axboe@nelson:/home/axboe/git/fio $ ./fio seq-null
>>>> Option create_only requires an argument
>>>> fio: failed parsing create_only
>>>> fio: job global dropped
>>>>
>>>> I'll take a look at that separately.
>>>>
>>> That works now:
>>> $ fio --create_only=3D1 --name=3Dtest --directory=3D./tests --rw=3Dread
>>> --size=3D10M --bs=3D4k --numjobs=3D4
>>> test: (g=3D0): rw=3Dread, bs=3D4K-4K/4K-4K, ioengine=3Dsync, iodepth=3D=
1
>>> ...
>>> test: (g=3D0): rw=3Dread, bs=3D4K-4K/4K-4K, ioengine=3Dsync, iodepth=3D=
1
>>> fio-2.0.7-13-g3b7f
>>> Starting 4 processes
>>> test: Laying out IO file(s) (1 file(s) / 10MB)
>>> test: Laying out IO file(s) (1 file(s) / 10MB)
>>> test: Laying out IO file(s) (1 file(s) / 10MB)
>>> test: Laying out IO file(s) (1 file(s) / 10MB)
>>>
>>>
>>> Run status group 0 (all jobs):
>>> $ ls tests/
>>> test.1.0 =A0test.2.0 =A0test.3.0 =A0test.4.0
>>>
>>> Nice!
>>> Thanks, Georg
>>>
>>> P.S.: Sorry for top posting
>>>
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe fio" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>
>> Hi Jens,
>>
>> Does this mean that if we create the files with appropriate names and
>> size before starting fio, then fio will not lay them out explicitly?
>> Just confirming .. this will be very useful (reduce runtime) when
>> performing tests on large filesystems.
>
> It does, yes, or you can just use this create_only option for the same
> effect.
>
> Fio uses repeatable file names, it always has.
>
> --
> Jens Axboe
>

I guess my question was is that if I created the files using some
other method other than create_only option, will this still work ?
Will fio look for needed files and skip layout step if they already
exist?

Vikram

