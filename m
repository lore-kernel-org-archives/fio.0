Return-Path: <bruce@cran.org.uk>
Message-ID: <507548FE.9010106@cran.org.uk>
Date: Wed, 10 Oct 2012 11:07:58 +0100
From: Bruce Cran <bruce@cran.org.uk>
MIME-Version: 1.0
Subject: Re: FIO 2.0.9 for Windows Server 2008 RC1 SP2 reports extreme latencies
References: <C8CA972100601A41AE302914E9CE194655F89024@NTXBOIMBX03.micron.com> <50605FEF.5020103@cran.org.uk> <C8CA972100601A41AE302914E9CE194655F9BAB5@NTXBOIMBX03.micron.com> <50632E0D.4090003@cran.org.uk> <506693F8.3010903@kernel.dk> <5066FBC0.5040508@cran.org.uk> <DD67A461-16D4-496A-BA7C-4F91F07A0B5D@kernel.dk> <C8CA972100601A41AE302914E9CE194655F9DEF4@NTXBOIMBX03.micron.com>
In-Reply-To: <C8CA972100601A41AE302914E9CE194655F9DEF4@NTXBOIMBX03.micron.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: "Jeffrey McVay (jmcvay)" <jmcvay@micron.com>
Cc: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 06/10/2012 01:25, Jeffrey McVay (jmcvay) wrote:
> Anything new on this issue? There is a reviewer using FIO on Windows to measure latency values. I am concerned that they may publish inaccurate data.

I'm working on it again today.
The problem is that windowsaio iterates over the list of outstanding IOs 
(busylist), but that list has the most recent first. The sequence of 
queue/dequeue with an iodepth of 4 is:

queue 1
queue 2
queue 3
queue 4
dequeue 4
queue 5
dequeue 5
queue 6
dequeue 6
dequeue 3
dequeue 2
dequeue 1

So the first IO therefore has an apparent latency equal to the runtime 
of fio.

-- 
Bruce Cran

