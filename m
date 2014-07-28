Return-Path: <axboe@kernel.dk>
Message-ID: <53D61053.9030902@kernel.dk>
Date: Mon, 28 Jul 2014 10:56:51 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: fio hangs with --status-interval
References: <CAE56cDuAUkhEnjMqCSWDcWrdwJrbffMcDG+FeCw6+7GN+jrWUg@mail.gmail.com>	<53BE5286.2060203@kernel.dk>	<CAE56cDvPKq31NrawN_KZF2+eDHiMY2A7azsx8z_DQfG1=-_cnw@mail.gmail.com>	<53BEF29E.3040500@kernel.dk>	<CAE56cDv7UmeGN=1rwyhbv7v5LfUkv+ueOoi+6KhnaXZYNx_7Fg@mail.gmail.com>	<53BFCF22.8020407@kernel.dk>	<CAE56cDtO9v3h2TkiyXQQ8dakmPiE+e-+wSazAc=XESOWA954Tg@mail.gmail.com>	<53C0F4EC.9010107@kernel.dk>	<CAFTzLMPFs0E4XphF5o155GiFaae0gGqJySswXpKUPPokPWoebw@mail.gmail.com>	<53CCCA96.7010703@kernel.dk>	<CAFTzLMP5GRx6R2HCykKN4pjkPLwHGafMc2HNh4gUONRRjBgYFg@mail.gmail.com>	<53D20AA8.6020700@kernel.dk>	<53D20DB8.10100@kernel.dk> <CAFTzLMPE+h_v8ydUP+iuCwJErQLuU=ZNcuKKcuxuZztandp+mQ@mail.gmail.com>
In-Reply-To: <CAFTzLMPE+h_v8ydUP+iuCwJErQLuU=ZNcuKKcuxuZztandp+mQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Vasily Tarasov <tarasov@vasily.name>
Cc: Michael Mattsson <michael.mattsson@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 2014-07-25 18:34, Vasily Tarasov wrote:
> Hi Jens,
>
> You'll be surprised but it did not help :( I used the latest code from
> git (fio-2.1.11-10-gae7e, commit ae7e050). Still see the same picture.

That's actually good news, since it didn't make a lot of sense. So lets 
see if we can't get to the bottom of this...

> I don't know if it helps, but I see this behavior on a machine with
> 96GB of RAM. So, after buffered writes are over, fio waits for a long
> time till all dirty buffers hit the disk. But, even after there is no
> more disk activity, fio is still stuck for as long as I don't kill it.
>
> Regarding the number of threads. I do understand where the 3 threads
> can come from:
>
> 1) Backend thread (sort of a manager)
> 1) Worker thread(s)
> 2) Disk stats thread
>
> I my case I defined only one job instance, so I suppose there always
> should be only one worker thread. I don't understand how the total
> number of threads go to 10 in the end.
>
> <snip starts>
> $ ps -eLf | grep fio
> root      4427  4135  4427  0   15 07:44 pts/1    00:00:02 fio
> --minimal --status-interval 10 1.fio
> root      4427  4135  4636  0   15 07:56 pts/1    00:00:00 fio
> --minimal --status-interval 10 1.fio
> root      4427  4135  4637  0   15 07:57 pts/1    00:00:00 fio
> --minimal --status-interval 10 1.fio
> root      4427  4135  4638  0   15 07:57 pts/1    00:00:00 fio
> --minimal --status-interval 10 1.fio
> root      4427  4135  4647  0   15 07:57 pts/1    00:00:00 fio
> --minimal --status-interval 10 1.fio
> root      4427  4135  4650  0   15 07:57 pts/1    00:00:00 fio
> --minimal --status-interval 10 1.fio
> root      4427  4135  4651  0   15 07:57 pts/1    00:00:00 fio
> --minimal --status-interval 10 1.fio
> root      4427  4135  4652  0   15 07:57 pts/1    00:00:00 fio
> --minimal --status-interval 10 1.fio
> root      4427  4135  4653  0   15 07:58 pts/1    00:00:00 fio
> --minimal --status-interval 10 1.fio
> root      4427  4135  4654  0   15 07:58 pts/1    00:00:00 fio
> --minimal --status-interval 10 1.fio
> root      4427  4135  4663  0   15 07:58 pts/1    00:00:00 fio
> --minimal --status-interval 10 1.fio
> root      4427  4135  4664  0   15 07:58 pts/1    00:00:00 fio
> --minimal --status-interval 10 1.fio
> root      4427  4135  4666  0   15 07:58 pts/1    00:00:00 fio
> --minimal --status-interval 10 1.fio
> root      4427  4135  4668  0   15 07:58 pts/1    00:00:00 fio
> --minimal --status-interval 10 1.fio
> root      4427  4135  4669  0   15 07:59 pts/1    00:00:00 fio
> --minimal --status-interval 10 1.fio
> <snip ends>

Can you try and gdb attach to it when it's hung and produce a new 
backtrace? It can't be off the final status run, I wonder if it's off 
the mutex down and remove instead.

-- 
Jens Axboe


