Return-Path: <axboe@kernel.dk>
Message-ID: <5429C839.7090408@kernel.dk>
Date: Mon, 29 Sep 2014 14:59:37 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Limit LBA Range
References: <BLU402-EAS71C90924EA427F167AAF17E0BA0@phx.gbl> <5429B424.7080903@kernel.dk> <BLU402-EAS1251A573D70EC1946D3C402E0BA0@phx.gbl>
In-Reply-To: <BLU402-EAS1251A573D70EC1946D3C402E0BA0@phx.gbl>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: Jon Tango <cheerios123@outlook.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 2014-09-29 14:46, Jon Tango wrote:
> Thanks for the reply. the capacity of the SSD is 850GB, but I am trying to
> run the workload continuously between 0 and 745GB of the capacity. I would
> like to workload to be time based so that it continues to run, even if more
> than 745 GB of data is written, but still within that same range. Is there a
> method of continuing to run the workload from 0 to 745GB, even if more than
> 745GB is written?

(please don't top post)

Sure, if you want it to run for 4h within that range, just do:

runtime=4h
timed_based

-- 
Jens Axboe


