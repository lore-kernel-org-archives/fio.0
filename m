Return-Path: <karasing@redhat.com>
MIME-Version: 1.0
In-Reply-To: <5756D05D.2050205@kernel.dk>
References: <CAKapHkMhGrnb1g=b9Pz_D_Frx8OSP65aiXBBM_KgVy5wpSz-kw@mail.gmail.com>
	<5756D05D.2050205@kernel.dk>
Date: Wed, 8 Jun 2016 00:01:59 +0300
Message-ID: <CAKapHkMc1GpyrvyUoprPEC=iOsbtbz7gxWESrakV+WGN=9Ne+w@mail.gmail.com>
Subject: Re: System IOPS vs. fio IOPS
From: Karan Singh <karan@redhat.com>
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On Tue, Jun 7, 2016 at 4:47 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On 06/06/2016 03:41 PM, Karan Singh wrote:
>>
>> #1  : Is r/s and w/s fields in iostat output corresponds to read and
>> write IOPS ? (
>> https://serverfault.com/questions/342273/disk-iops-count-in-gnu-linux
>> mentions r/s and w/s as IOPS)
>> #2  : If yes then why does they dont match with FIO IOPS results ?
>
>
> The answer is no, and that goes for any application. You could have an app
> that does sequential ios in 4k chunks, and the kernel merges them into 512k
> IOs. From the application perspective, it's doing 128 as many iops as the
> device is. The converse can also be true, like in your case, since the
> application is submitting IO that is larger than the device can handle.
> Hence it's broken up, and the result is that the device is now doing a lot
> more IOPS than the application is issuing.

Thanks Jens for answering

You said kernel merges / divides IO into 512k chunk.

#1 How can i verify this (512k) value, any command or file to look this into ?
#2 Out of curiosity is there a way to disable this merging / division
of IO ? it might be not efficient but just want to play around this.
#3 Is it true that merging /division of IO is irrespective of pattern
( sequential or random ) i.e kernel will perform this whether the IO
is seq. or random ?


>
> --
> Jens Axboe
>

