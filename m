Return-Path: <axboe@kernel.dk>
Subject: Re: file_service_type and random_distribution
References: <CAGjEAhstKdQQQORoniayYLuvTdfXqAkOCXdargudF7oyeM0S5Q@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <5739FC0D.7070106@kernel.dk>
Date: Mon, 16 May 2016 10:57:49 -0600
MIME-Version: 1.0
In-Reply-To: <CAGjEAhstKdQQQORoniayYLuvTdfXqAkOCXdargudF7oyeM0S5Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: qingwei wei <tchengwee@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 05/12/2016 07:59 PM, qingwei wei wrote:
> Hi,
>
> I am looking at performing some small files benchmark and i would like
> to confirm few things here:
>
> 1) Random distribution, for file type test, is this only applicable to
> how it choose offset in the file?

Yes

> 2) file_service_type, is this decide which file to be opened during
> test if i choose to have openfiles less than nrfiles?

Yes

> I would like to confirm those points is because i intend to run
> workload test that simulate hot file access. At any one time, the
> files open will be less than the total files in the system and there
> will be files that are hot and get access multiple times. Can i do it
> using fio? Thanks.

That's a good question. Currently fio doesn't, but there's no reason why 
it could not use the same distribution methods for choosing what files 
to service. That would indeed allow you to mimic some files being hotter 
than others, just like we do for offsets in that file.

-- 
Jens Axboe


