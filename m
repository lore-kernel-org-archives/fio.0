Return-Path: <tchengwee@gmail.com>
MIME-Version: 1.0
In-Reply-To: <573A71E4.3020404@kernel.dk>
References: <CAGjEAhstKdQQQORoniayYLuvTdfXqAkOCXdargudF7oyeM0S5Q@mail.gmail.com>
	<5739FC0D.7070106@kernel.dk>
	<573A0D4D.8010205@kernel.dk>
	<573A71E4.3020404@kernel.dk>
Date: Tue, 17 May 2016 09:25:16 +0800
Message-ID: <CAGjEAhv5D5f4WCf77f1c1=de93xqSR9hZ0ZqBBj15S8Hhogmyw@mail.gmail.com>
Subject: Re: file_service_type and random_distribution
From: qingwei wei <tchengwee@gmail.com>
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Hi Jens,

Thanks. I will try to do some test later this week.

Cw

On Tue, May 17, 2016 at 9:20 AM, Jens Axboe <axboe@kernel.dk> wrote:
> On 05/16/2016 12:11 PM, Jens Axboe wrote:
>>
>> On 05/16/2016 10:57 AM, Jens Axboe wrote:
>>>>
>>>> I would like to confirm those points is because i intend to run
>>>> workload test that simulate hot file access. At any one time, the
>>>> files open will be less than the total files in the system and there
>>>> will be files that are hot and get access multiple times. Can i do it
>>>> using fio? Thanks.
>>>
>>>
>>> That's a good question. Currently fio doesn't, but there's no reason why
>>> it could not use the same distribution methods for choosing what files
>>> to service. That would indeed allow you to mimic some files being hotter
>>> than others, just like we do for offsets in that file.
>>
>>
>> Something like the below patch would allow you to do that. Basically the
>> options and values are idential to random_distribution, this one is just
>> for selecting what file to service. Just like with random_distribution,
>> you could use fio-genzipf to give you a good idea of what the
>> distribution of file uses would be.
>>
>> Let me know how it works for you.
>
>
> Committed with some fixes, so you can just use the git version.
>
> --
> Jens Axboe
>

