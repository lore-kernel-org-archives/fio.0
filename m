Return-Path: <axboe@kernel.dk>
Message-ID: <52FA7A32.1090307@kernel.dk>
Date: Tue, 11 Feb 2014 12:29:54 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Fio 2.1.5 release upcoming
References: <20140206192135.GB3950@kernel.dk>	<CAF+0mvnBvLVqijP+Atbh9SEjt0p6-e3hy4Q3QRMtb+swp72bTQ@mail.gmail.com>	<20140209205744.GB2750@kernel.dk>	<CAF+0mvk+h3Hb5-KyQr7fqfmrUN6V4-HvKx4M0AYHC6mTUQu0+Q@mail.gmail.com>	<20140210221420.GD4096@kernel.dk>	<CAF+0mvmhEBaYSmLh99MST9MCg3rHan339rQkQb2Nw3fvStUfTg@mail.gmail.com>	<52F95D7B.1000002@kernel.dk>	<CAF+0mvkg4sD4r75G6+warH0UtMOzYWm29-=MVQx5MDGiRk3sPA@mail.gmail.com>	<20140211152721.GA19057@kernel.dk> <CAF+0mvmRUiPo7ZQQTUnUimDzJJ-rO+rkuKmRcUwKcwtvaBQfLw@mail.gmail.com>
In-Reply-To: <CAF+0mvmRUiPo7ZQQTUnUimDzJJ-rO+rkuKmRcUwKcwtvaBQfLw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Matthew Eaton <m.eaton82@gmail.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>



On 02/11/2014 12:18 PM, Matthew Eaton wrote:
>> The below should be a bit better.
>
> I made a fresh git clone and tried to apply patch2 but got some errors.
>
> matt@matt-work:~/fiogit/fio$ patch -p1 -l --dry-run < /home/matt/patch2
> checking file backend.c
> Reversed (or previously applied) patch detected!  Assume -R? [n] y
> checking file file.h
> Reversed (or previously applied) patch detected!  Assume -R? [n] y
> checking file filesetup.c
> Hunk #2 FAILED at 734.
> Hunk #3 succeeded at 802 (offset 16 lines).
> Hunk #4 FAILED at 812.
> Hunk #5 succeeded at 1435 with fuzz 2 (offset 35 lines).
> 2 out of 5 hunks FAILED
> checking file io_u.c
> Reversed (or previously applied) patch detected!  Assume -R? [n] y
> matt@matt-work:~/fiogit/fio$

Just run current -git, I applied the patch.

-- 
Jens Axboe

