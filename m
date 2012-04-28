Return-Path: <sureshdrajan@gmail.com>
MIME-Version: 1.0
In-Reply-To: <4F9101C0.100@kernel.dk>
References: <CAN8qX8bPefV2J1xtNVBZ36sEKE-Vg-te+_Kj__hDoJGEzLzW=A@mail.gmail.com>
	<4F899663.8050406@kernel.dk>
	<4F8997E9.6090206@kernel.dk>
	<CAN8qX8bNZ4VPFP1a09DdJSaVa2D0MZ0vqLqHF-S4hbdHwuJZcw@mail.gmail.com>
	<4F8D0E1A.2020004@kernel.dk>
	<CAN8qX8ZJXpKibjFfyG9ZBG=eXNwWtdm5X9FyRduKvCcyQx7RwA@mail.gmail.com>
	<4F8FA704.30006@kernel.dk>
	<CAN8qX8baRKJrLRQ3p--NBMH9hA+G5om6R9hRQEr2ZXwbDc3Hwg@mail.gmail.com>
	<4F9101C0.100@kernel.dk>
Date: Sat, 28 Apr 2012 12:09:14 -0700
Message-ID: <CAN8qX8a4=a4hBkuB54MGV3_+=+wrPVae6oN6Hh=H-ZQt+0ewyA@mail.gmail.com>
Subject: Re: Running fio with offset Increment option
From: Suresh Dhanarajan <sureshdrajan@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Hi Jens,

I verified the offsets by using the write_io_log switch.
when i use offset increment without patch the offset are incremented
and not reset to zero after stone wall.
when i use with patch the offset resets to zero after stone wall.
I hope you are testing with the patch.
If it is so this what the behavior iam  also seeing.

Thanks,
Suresh


On Thu, Apr 19, 2012 at 11:27 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On 04/19/2012 09:32 PM, Suresh Dhanarajan wrote:
>> Hi Jens,
>>
>> I tested with and without stonewall.
>> with stonewall the offset is reset to zero for a newjob.
>> But without stonewall the offset is not reseting zero.
>
> How are you verifying that this is the case? I added a debug printf
> here, and ran the below job:
>
> ---
>
> [global]
> numjobs=3D4
> offset_increment=3D100m
> filename=3Dfoo
> ioengine=3Dnull
> size=3D100g
> rw=3Drandread
> rate=3D500m
>
> [null]
>
> [null-a]
>
> [null-b]
> stonewall
>
> [null-c]
>
> [null-d]
> stonewall
>
> [null-e]
>
> ---
>
> Which should give us 4 jobs, then 4 more jobs at continuing offsets,
> then null-b at 0 again, null-c at 4*100MB and up, null-d at zero and
> null-e identical to null-c.
>
> job1: file foo offset 0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 <- null
> job2: file foo offset 104857600
> job3: file foo offset 209715200
> job4: file foo offset 314572800
> job5: file foo offset 419430400 =A0 =A0 =A0 =A0 <- null-a
> job6: file foo offset 524288000
> job7: file foo offset 629145600
> job8: file foo offset 734003200
> job9: file foo offset 0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 <- null-b
> job10: file foo offset 104857600
> job11: file foo offset 209715200
> job12: file foo offset 314572800
> job13: file foo offset 419430400 =A0 =A0 =A0 =A0<- null-c
> job14: file foo offset 524288000
> job15: file foo offset 629145600
> job16: file foo offset 734003200
> job17: file foo offset 0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0<- null-d
> job18: file foo offset 104857600
> job19: file foo offset 209715200
> job20: file foo offset 314572800
> job21: file foo offset 419430400 =A0 =A0 =A0 =A0<- null-e
> job22: file foo offset 524288000
> job23: file foo offset 629145600
> job24: file foo offset 734003200
>
> So it looks like it's working here, at least offset is being calculated
> and set correctly. Hence my question on why it isn't working for you. If
> you are looking at the actual IO offsets generated, then it's possible
> there is a bug somewhere. That bug should, however, also affect the
> original patch since this is just changing how we generate them upfront.
>
> --
> Jens Axboe
>

