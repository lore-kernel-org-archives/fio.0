Return-Path: <sectorsize512@gmail.com>
MIME-Version: 1.0
Sender: sectorsize512@gmail.com
In-Reply-To: <53D20DB8.10100@kernel.dk>
References: <CAE56cDuAUkhEnjMqCSWDcWrdwJrbffMcDG+FeCw6+7GN+jrWUg@mail.gmail.com>
	<53BE5286.2060203@kernel.dk>
	<CAE56cDvPKq31NrawN_KZF2+eDHiMY2A7azsx8z_DQfG1=-_cnw@mail.gmail.com>
	<53BEF29E.3040500@kernel.dk>
	<CAE56cDv7UmeGN=1rwyhbv7v5LfUkv+ueOoi+6KhnaXZYNx_7Fg@mail.gmail.com>
	<53BFCF22.8020407@kernel.dk>
	<CAE56cDtO9v3h2TkiyXQQ8dakmPiE+e-+wSazAc=XESOWA954Tg@mail.gmail.com>
	<53C0F4EC.9010107@kernel.dk>
	<CAFTzLMPFs0E4XphF5o155GiFaae0gGqJySswXpKUPPokPWoebw@mail.gmail.com>
	<53CCCA96.7010703@kernel.dk>
	<CAFTzLMP5GRx6R2HCykKN4pjkPLwHGafMc2HNh4gUONRRjBgYFg@mail.gmail.com>
	<53D20AA8.6020700@kernel.dk>
	<53D20DB8.10100@kernel.dk>
Date: Fri, 25 Jul 2014 12:34:13 -0400
Message-ID: <CAFTzLMPE+h_v8ydUP+iuCwJErQLuU=ZNcuKKcuxuZztandp+mQ@mail.gmail.com>
Subject: Re: fio hangs with --status-interval
From: Vasily Tarasov <tarasov@vasily.name>
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: Michael Mattsson <michael.mattsson@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Hi Jens,

You'll be surprised but it did not help :( I used the latest code from
git (fio-2.1.11-10-gae7e, commit ae7e050). Still see the same picture.

I don't know if it helps, but I see this behavior on a machine with
96GB of RAM. So, after buffered writes are over, fio waits for a long
time till all dirty buffers hit the disk. But, even after there is no
more disk activity, fio is still stuck for as long as I don't kill it.

Regarding the number of threads. I do understand where the 3 threads
can come from:

1) Backend thread (sort of a manager)
1) Worker thread(s)
2) Disk stats thread

I my case I defined only one job instance, so I suppose there always
should be only one worker thread. I don't understand how the total
number of threads go to 10 in the end.

<snip starts>
$ ps -eLf | grep fio
root      4427  4135  4427  0   15 07:44 pts/1    00:00:02 fio
--minimal --status-interval 10 1.fio
root      4427  4135  4636  0   15 07:56 pts/1    00:00:00 fio
--minimal --status-interval 10 1.fio
root      4427  4135  4637  0   15 07:57 pts/1    00:00:00 fio
--minimal --status-interval 10 1.fio
root      4427  4135  4638  0   15 07:57 pts/1    00:00:00 fio
--minimal --status-interval 10 1.fio
root      4427  4135  4647  0   15 07:57 pts/1    00:00:00 fio
--minimal --status-interval 10 1.fio
root      4427  4135  4650  0   15 07:57 pts/1    00:00:00 fio
--minimal --status-interval 10 1.fio
root      4427  4135  4651  0   15 07:57 pts/1    00:00:00 fio
--minimal --status-interval 10 1.fio
root      4427  4135  4652  0   15 07:57 pts/1    00:00:00 fio
--minimal --status-interval 10 1.fio
root      4427  4135  4653  0   15 07:58 pts/1    00:00:00 fio
--minimal --status-interval 10 1.fio
root      4427  4135  4654  0   15 07:58 pts/1    00:00:00 fio
--minimal --status-interval 10 1.fio
root      4427  4135  4663  0   15 07:58 pts/1    00:00:00 fio
--minimal --status-interval 10 1.fio
root      4427  4135  4664  0   15 07:58 pts/1    00:00:00 fio
--minimal --status-interval 10 1.fio
root      4427  4135  4666  0   15 07:58 pts/1    00:00:00 fio
--minimal --status-interval 10 1.fio
root      4427  4135  4668  0   15 07:58 pts/1    00:00:00 fio
--minimal --status-interval 10 1.fio
root      4427  4135  4669  0   15 07:59 pts/1    00:00:00 fio
--minimal --status-interval 10 1.fio
<snip ends>

Thanks,
Vasily

On Fri, Jul 25, 2014 at 3:56 AM, Jens Axboe <axboe@kernel.dk> wrote:
> On 2014-07-25 09:43, Jens Axboe wrote:
>>
>> On 2014-07-21 22:25, Vasily Tarasov wrote:
>>>
>>> Hi Jens,
>>>
>>> I tried your patch, but it didn't help. Interestingly, the number of
>>> threads changes in the end. At first, during the run:
>>>
>>> # ps -eLf | grep fio
>>> root      5224  4274  5224  1    2 11:12 pts/1    00:00:00 fio
>>> --status-interval 10 --minimal fios/1.fio
>>> root      5224  4274  5225  0    2 11:12 pts/1    00:00:00 fio
>>> --status-interval 10 --minimal fios/1.fio
>>> root      5231  5224  5231 60    1 11:12 ?        00:00:07 fio
>>> --status-interval 10 --minimal fios/1.fio
>>> root      5260  5237  5260  0    1 11:12 pts/0    00:00:00 grep fio
>>> [root@bison01 vass]# ps -eLf | grep fio
>>> root      5224  4274  5224  0    2 11:12 pts/1    00:00:00 fio
>>> --status-interval 10 --minimal fios/1.fio
>>> root      5224  4274  5225  0    2 11:12 pts/1    00:00:00 fio
>>> --status-interval 10 --minimal fios/1.fio
>>> root      5231  5224  5231 16    1 11:12 ?        00:00:21 fio
>>> --status-interval 10 --minimal fios/1.fio
>>> root      5293  5237  5293  0    1 11:14 pts/0    00:00:00 grep fio
>>> [root@bison01 vass]# ps -eLf | grep fio
>>> root      5224  4274  5224  0    2 11:12 pts/1    00:00:01 fio
>>> --status-interval 10 --minimal fios/1.fio
>>> root      5224  4274  5225  0    2 11:12 pts/1    00:00:00 fio
>>> --status-interval 10 --minimal fios/1.fio
>>> root      5231  5224  5231 12    1 11:12 ?        00:01:13 fio
>>> --status-interval 10 --minimal fios/1.fio
>>> root      5411  5237  5411  0    1 11:22 pts/0    00:00:00 grep fio
>>>
>>> Later, when the threads are stuck:
>>>
>>> # ps -eLf | grep fio
>>> root      5224  4274  5224  0   16 11:12 pts/1    00:00:02 fio
>>> --status-interval 10 --minimal fios/1.fio
>>> root      5224  4274  5225  0   16 11:12 pts/1    00:00:01 fio
>>> --status-interval 10 --minimal fios/1.fio
>>> root      5224  4274  5458  0   16 11:25 pts/1    00:00:00 fio
>>> --status-interval 10 --minimal fios/1.fio
>>> root      5224  4274  5459  0   16 11:25 pts/1    00:00:00 fio
>>> --status-interval 10 --minimal fios/1.fio
>>> root      5224  4274  5460  0   16 11:25 pts/1    00:00:00 fio
>>> --status-interval 10 --minimal fios/1.fio
>>> root      5224  4274  5461  0   16 11:25 pts/1    00:00:00 fio
>>> --status-interval 10 --minimal fios/1.fio
>>> root      5224  4274  5462  0   16 11:25 pts/1    00:00:00 fio
>>> --status-interval 10 --minimal fios/1.fio
>>> root      5224  4274  5471  0   16 11:25 pts/1    00:00:00 fio
>>> --status-interval 10 --minimal fios/1.fio
>>> root      5224  4274  5472  0   16 11:26 pts/1    00:00:00 fio
>>> --status-interval 10 --minimal fios/1.fio
>>> root      5224  4274  5475  0   16 11:26 pts/1    00:00:00 fio
>>> --status-interval 10 --minimal fios/1.fio
>>> root      5224  4274  5476  0   16 11:26 pts/1    00:00:00 fio
>>> --status-interval 10 --minimal fios/1.fio
>>> root      5224  4274  5477  0   16 11:26 pts/1    00:00:00 fio
>>> --status-interval 10 --minimal fios/1.fio
>>> root      5224  4274  5478  0   16 11:26 pts/1    00:00:00 fio
>>> --status-interval 10 --minimal fios/1.fio
>>> root      5224  4274  5487  0   16 11:26 pts/1    00:00:00 fio
>>> --status-interval 10 --minimal fios/1.fio
>>> root      5224  4274  5488  0   16 11:27 pts/1    00:00:00 fio
>>> --status-interval 10 --minimal fios/1.fio
>>> root      5224  4274  5489  0   16 11:27 pts/1    00:00:00 fio
>>> --status-interval 10 --minimal fios/1.fio
>>> root      6665  5237  6665  0    1 13:21 pts/0    00:00:00 grep fio
>>>
>>> Is the number of threads supposed to change?..
>>
>>
>> Never answered this one... Yes, it'll change, since when you run the
>> job, you'll have one backend process, a number of IO workers, and one
>> disk util thread typically. When you get stuck, it's the backend that is
>> left waiting for that mutex.
>>
>> In any case, I haven't been able to figure this one out yet. But it
>> should be safe enough to just ignore the stat mutex for the final
>> output, since the threads otherwise accessing it are gone. Can you see
>> if this one makes the issue go away?
>
>
> Patch was not compiled, was missing the non-static __show_run_stats(). But
> just pull current -git, I have committed a variant that does compile :-)
>
> --
> Jens Axboe
>

