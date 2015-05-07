Return-Path: <axboe@kernel.dk>
Message-ID: <554B7ABF.8050309@kernel.dk>
Date: Thu, 07 May 2015 08:46:23 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: fio queue depth and windows build.
References: <CAHA74uot2-dZCi=iehNRgx0RF55QsBpLFFcxQ7KqdXmjbn1FuA@mail.gmail.com>	<8DA4332D-F151-41F4-BC00-59F68ED3ACE3@cran.org.uk>	<CAHA74uqeP9ntkHVABfdDPxSZK4tTLbm486b9FJm2YjdJPv8XKA@mail.gmail.com>	<CAHA74uqXsXBRrNHOdTnnLegnO-DzSdj_DRxnm3R6h8aZkaSSbg@mail.gmail.com> <CAHA74uq=vCkY4SVRH6DJM9r70=2ae4vcFVbnjbbVbzRRh=T_SA@mail.gmail.com>
In-Reply-To: <CAHA74uq=vCkY4SVRH6DJM9r70=2ae4vcFVbnjbbVbzRRh=T_SA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Iuliu Rus <iuliur@google.com>, Bruce Cran <bruce@cran.org.uk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 05/06/2015 12:35 PM, Iuliu Rus wrote:
> FYI i have sent a pull request https://github.com/axboe/fio/pull/64
> which makes fio on windows on par with iometer. The difference quite
> big on our local flash machines (60k iops to 100k)

Thanks for fixing this up, it's been a pain point for quite a while!

-- 
Jens Axboe


