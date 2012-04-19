Return-Path: <sureshdrajan@gmail.com>
MIME-Version: 1.0
In-Reply-To: <4F8FA704.30006@kernel.dk>
References: <CAN8qX8bPefV2J1xtNVBZ36sEKE-Vg-te+_Kj__hDoJGEzLzW=A@mail.gmail.com>
	<4F899663.8050406@kernel.dk>
	<4F8997E9.6090206@kernel.dk>
	<CAN8qX8bNZ4VPFP1a09DdJSaVa2D0MZ0vqLqHF-S4hbdHwuJZcw@mail.gmail.com>
	<4F8D0E1A.2020004@kernel.dk>
	<CAN8qX8ZJXpKibjFfyG9ZBG=eXNwWtdm5X9FyRduKvCcyQx7RwA@mail.gmail.com>
	<4F8FA704.30006@kernel.dk>
Date: Thu, 19 Apr 2012 12:32:54 -0700
Message-ID: <CAN8qX8baRKJrLRQ3p--NBMH9hA+G5om6R9hRQEr2ZXwbDc3Hwg@mail.gmail.com>
Subject: Re: Running fio with offset Increment option
From: Suresh Dhanarajan <sureshdrajan@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Hi Jens,

I tested with and without stonewall.
with stonewall the offset is reset to zero for a newjob.
But without stonewall the offset is not reseting zero.

thanks,
Suresh.D

On Wed, Apr 18, 2012 at 10:47 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On 04/18/2012 11:37 PM, Suresh Dhanarajan wrote:
>> Hi Jens,
>>
>> Thanks for the patch.
>> I checked with the patch given you and found that the offset is
>> getting set to zero for every new job.
>
> Are you sure? I hadn't tested the patch myself, until now. It seems to
> work just fine here, group_thread_id is contiguous until a stonewall is
> seen. Works for new job entries and numjobs.
>
> --
> Jens Axboe
>

