Return-Path: <bruce@cran.org.uk>
Message-ID: <5066FBC0.5040508@cran.org.uk>
Date: Sat, 29 Sep 2012 14:46:40 +0100
From: Bruce Cran <bruce@cran.org.uk>
MIME-Version: 1.0
Subject: Re: FIO 2.0.9 for Windows Server 2008 RC1 SP2 reports extreme latencies
References: <C8CA972100601A41AE302914E9CE194655F89024@NTXBOIMBX03.micron.com> <50605FEF.5020103@cran.org.uk> <C8CA972100601A41AE302914E9CE194655F9BAB5@NTXBOIMBX03.micron.com> <50632E0D.4090003@cran.org.uk> <506693F8.3010903@kernel.dk>
In-Reply-To: <506693F8.3010903@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>
Cc: "Jeffrey McVay (jmcvay)" <jmcvay@micron.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 29/09/2012 07:23, Jens Axboe wrote:
> On 2012-09-26 18:32, Bruce Cran wrote:
>> On 26/09/2012 17:30, Jeffrey McVay (jmcvay) wrote:
>>> Any updates? Is there anything I can do to help? I have a personal
>>> goal to convert our IOMeter testing to FIO.
>> Sorry, I've not had any time to work on this yet - I'll work on it today.
> Any news on this? What is the issue?
>

I've not found the problem yet, but I'm also seeing an assertion failure 
(io_u->flags & IO_U_F_FLIGHT).

-- 
Bruce

