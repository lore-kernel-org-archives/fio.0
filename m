Return-Path: <axboe@kernel.dk>
Subject: Re: file_service_type and random_distribution
References: <CAGjEAhstKdQQQORoniayYLuvTdfXqAkOCXdargudF7oyeM0S5Q@mail.gmail.com>
 <5739FC0D.7070106@kernel.dk> <573A0D4D.8010205@kernel.dk>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <573A71E4.3020404@kernel.dk>
Date: Mon, 16 May 2016 19:20:36 -0600
MIME-Version: 1.0
In-Reply-To: <573A0D4D.8010205@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: qingwei wei <tchengwee@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 05/16/2016 12:11 PM, Jens Axboe wrote:
> On 05/16/2016 10:57 AM, Jens Axboe wrote:
>>> I would like to confirm those points is because i intend to run
>>> workload test that simulate hot file access. At any one time, the
>>> files open will be less than the total files in the system and there
>>> will be files that are hot and get access multiple times. Can i do it
>>> using fio? Thanks.
>>
>> That's a good question. Currently fio doesn't, but there's no reason why
>> it could not use the same distribution methods for choosing what files
>> to service. That would indeed allow you to mimic some files being hotter
>> than others, just like we do for offsets in that file.
>
> Something like the below patch would allow you to do that. Basically the
> options and values are idential to random_distribution, this one is just
> for selecting what file to service. Just like with random_distribution,
> you could use fio-genzipf to give you a good idea of what the
> distribution of file uses would be.
>
> Let me know how it works for you.

Committed with some fixes, so you can just use the git version.

-- 
Jens Axboe


