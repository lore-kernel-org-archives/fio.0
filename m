Return-Path: <axboe@kernel.dk>
Message-ID: <53CD7E13.3050806@kernel.dk>
Date: Mon, 21 Jul 2014 22:54:43 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: fio hangs with --status-interval
References: <CAE56cDuAUkhEnjMqCSWDcWrdwJrbffMcDG+FeCw6+7GN+jrWUg@mail.gmail.com>	<53BE5286.2060203@kernel.dk>	<CAE56cDvPKq31NrawN_KZF2+eDHiMY2A7azsx8z_DQfG1=-_cnw@mail.gmail.com>	<53BEF29E.3040500@kernel.dk>	<CAE56cDv7UmeGN=1rwyhbv7v5LfUkv+ueOoi+6KhnaXZYNx_7Fg@mail.gmail.com>	<53BFCF22.8020407@kernel.dk>	<CAE56cDtO9v3h2TkiyXQQ8dakmPiE+e-+wSazAc=XESOWA954Tg@mail.gmail.com>	<53C0F4EC.9010107@kernel.dk>	<CAFTzLMPFs0E4XphF5o155GiFaae0gGqJySswXpKUPPokPWoebw@mail.gmail.com>	<53CCCA96.7010703@kernel.dk> <CAFTzLMP5GRx6R2HCykKN4pjkPLwHGafMc2HNh4gUONRRjBgYFg@mail.gmail.com>
In-Reply-To: <CAFTzLMP5GRx6R2HCykKN4pjkPLwHGafMc2HNh4gUONRRjBgYFg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Vasily Tarasov <tarasov@vasily.name>
Cc: Michael Mattsson <michael.mattsson@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 2014-07-21 22:25, Vasily Tarasov wrote:
> Hi Jens,
>
> I tried your patch, but it didn't help. Interestingly, the number of
> threads changes in the end. At first, during the run:
>
> # ps -eLf | grep fio
> root      5224  4274  5224  1    2 11:12 pts/1    00:00:00 fio
> --status-interval 10 --minimal fios/1.fio
> root      5224  4274  5225  0    2 11:12 pts/1    00:00:00 fio
> --status-interval 10 --minimal fios/1.fio
> root      5231  5224  5231 60    1 11:12 ?        00:00:07 fio
> --status-interval 10 --minimal fios/1.fio
> root      5260  5237  5260  0    1 11:12 pts/0    00:00:00 grep fio
> [root@bison01 vass]# ps -eLf | grep fio
> root      5224  4274  5224  0    2 11:12 pts/1    00:00:00 fio
> --status-interval 10 --minimal fios/1.fio
> root      5224  4274  5225  0    2 11:12 pts/1    00:00:00 fio
> --status-interval 10 --minimal fios/1.fio
> root      5231  5224  5231 16    1 11:12 ?        00:00:21 fio
> --status-interval 10 --minimal fios/1.fio
> root      5293  5237  5293  0    1 11:14 pts/0    00:00:00 grep fio
> [root@bison01 vass]# ps -eLf | grep fio
> root      5224  4274  5224  0    2 11:12 pts/1    00:00:01 fio
> --status-interval 10 --minimal fios/1.fio
> root      5224  4274  5225  0    2 11:12 pts/1    00:00:00 fio
> --status-interval 10 --minimal fios/1.fio
> root      5231  5224  5231 12    1 11:12 ?        00:01:13 fio
> --status-interval 10 --minimal fios/1.fio
> root      5411  5237  5411  0    1 11:22 pts/0    00:00:00 grep fio
>
> Later, when the threads are stuck:
>
> # ps -eLf | grep fio
> root      5224  4274  5224  0   16 11:12 pts/1    00:00:02 fio
> --status-interval 10 --minimal fios/1.fio
> root      5224  4274  5225  0   16 11:12 pts/1    00:00:01 fio
> --status-interval 10 --minimal fios/1.fio
> root      5224  4274  5458  0   16 11:25 pts/1    00:00:00 fio
> --status-interval 10 --minimal fios/1.fio
> root      5224  4274  5459  0   16 11:25 pts/1    00:00:00 fio
> --status-interval 10 --minimal fios/1.fio
> root      5224  4274  5460  0   16 11:25 pts/1    00:00:00 fio
> --status-interval 10 --minimal fios/1.fio
> root      5224  4274  5461  0   16 11:25 pts/1    00:00:00 fio
> --status-interval 10 --minimal fios/1.fio
> root      5224  4274  5462  0   16 11:25 pts/1    00:00:00 fio
> --status-interval 10 --minimal fios/1.fio
> root      5224  4274  5471  0   16 11:25 pts/1    00:00:00 fio
> --status-interval 10 --minimal fios/1.fio
> root      5224  4274  5472  0   16 11:26 pts/1    00:00:00 fio
> --status-interval 10 --minimal fios/1.fio
> root      5224  4274  5475  0   16 11:26 pts/1    00:00:00 fio
> --status-interval 10 --minimal fios/1.fio
> root      5224  4274  5476  0   16 11:26 pts/1    00:00:00 fio
> --status-interval 10 --minimal fios/1.fio
> root      5224  4274  5477  0   16 11:26 pts/1    00:00:00 fio
> --status-interval 10 --minimal fios/1.fio
> root      5224  4274  5478  0   16 11:26 pts/1    00:00:00 fio
> --status-interval 10 --minimal fios/1.fio
> root      5224  4274  5487  0   16 11:26 pts/1    00:00:00 fio
> --status-interval 10 --minimal fios/1.fio
> root      5224  4274  5488  0   16 11:27 pts/1    00:00:00 fio
> --status-interval 10 --minimal fios/1.fio
> root      5224  4274  5489  0   16 11:27 pts/1    00:00:00 fio
> --status-interval 10 --minimal fios/1.fio
> root      6665  5237  6665  0    1 13:21 pts/0    00:00:00 grep fio
>
> Is the number of threads supposed to change?..
>
> Here is the fio file I'm using:
>
> <snip starts>
> # cat fios/1.fio
> [global]
> rw=write
> bs=8m
> direct=0
>
> [sdaa]
> filename=/dev/sdaa
> <snip ends>
>
> Command line is
>
> fio --status-interval 10 --minimal fios/1.fio

Thanks, I'll try and reproduce it tomorrow.

-- 
Jens Axboe


