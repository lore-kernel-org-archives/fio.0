Return-Path: <axboe@kernel.dk>
Subject: Re: Linux OS killed fio process because fio invoked oom_killer
References: <CADvrUP8gH3S-fLnHU4QXJLO87YzUge8MxKt3WdffN+9uiVpH3w@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <56F17326.3000908@kernel.dk>
Date: Tue, 22 Mar 2016 10:30:30 -0600
MIME-Version: 1.0
In-Reply-To: <CADvrUP8gH3S-fLnHU4QXJLO87YzUge8MxKt3WdffN+9uiVpH3w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: flash yan <flashyan83@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 03/22/2016 08:06 AM, flash yan wrote:
> Hi all,
>
> I have run fio-2.7 to test iscsi device, one unusual issue happened.
> If I set the io_size to 4096, queue_depth to 16 ,rw to randwrite and
> run_time to 3000,
> the fio would invoke oom_killer and the Linux OS would kill the fio process.
> The machine have about 11 GB memory and I have tried the machine with
> 23GB, the issue also happened.
> I think fio have problem when dealing with 4KB io_size then used too
> many memory.

When did this happen - shortly after the job is started, or long after? 
How big is the iscsi device? Did you have verify= options enabled?

-- 
Jens Axboe


