Return-Path: <axboe@kernel.dk>
Message-ID: <53E3EF6E.5050307@kernel.dk>
Date: Thu, 07 Aug 2014 15:28:14 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Run FIO on a Windows Partition
References: <9E26C6259ACF1842A4815F929194EDD394C42014@phex01.corp.bitmicro.com>
In-Reply-To: <9E26C6259ACF1842A4815F929194EDD394C42014@phex01.corp.bitmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Ritchie Babaylan <Ritchie.Babaylan@bitmicro.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: Bruce Cran <bruce@cran.org.uk>
List-ID: <fio@vger.kernel.org>

On 08/03/2014 06:12 PM, Ritchie Babaylan wrote:
> Hi,
> 
> I am just curios if FIO can test a Windows partition, say F: as the assigned drive letter.
> What would be the correct syntax do I need to put on a "filename" parameter?
> Do I need to use the "directory" parameter instead?
> 
> [job1]
> ioengine=windowsaio
> iodepth=4
> rw=write
> filename=F:
> 
> Btw, I am using the latest FIO v2.1.10 (32bit) version on Windows 7 (32bit).

Bruce might know (CC'ed).

-- 
Jens Axboe


