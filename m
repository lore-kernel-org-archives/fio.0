Return-Path: <bruce@cran.org.uk>
Message-ID: <50605FEF.5020103@cran.org.uk>
Date: Mon, 24 Sep 2012 14:28:15 +0100
From: Bruce Cran <bruce@cran.org.uk>
MIME-Version: 1.0
Subject: Re: FIO 2.0.9 for Windows Server 2008 RC1 SP2 reports extreme latencies
References: <C8CA972100601A41AE302914E9CE194655F89024@NTXBOIMBX03.micron.com>
In-Reply-To: <C8CA972100601A41AE302914E9CE194655F89024@NTXBOIMBX03.micron.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: "Jeffrey McVay (jmcvay)" <jmcvay@micron.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

On 24/09/2012 06:41, Jeffrey McVay (jmcvay) wrote:
>
> On windows runing 4kB random Writes to a ramdisk with numjobs=4 and 
> iodepth=64 FIO reports clat and lat maximums times that match the 
> runtime of the test. Changing the numjobs=1 and iodepth=1 yields max 
> latencies that meet expectations.  As a further sanity test I ran 
> similar workloads using IOMeter with max response times that were in 
> line with expectations.
>
> To reproduce:
>
> 1.Download and install the freeware version of Dataram ramdisk from 
> http://memory.dataram.com/products-and-services/software/ramdisk
>
> 2.Run FIO 2.0.9 with PhysD1_Fio_4kRandWr_4x64
>
> 3.Notice the max entries for clat and lat
>
> 4.For comparison run FIO with PhysD1_Fio4kRandWr_1x1
>
> Attached are the FIO jobfiles, latency logs for the two FIO runs, 
> IOMeter ICF files, IOMeter csv files, and screenshots comparing 
> similar runs of FIO and IOMeter.
>

Thanks. I've replicated the problem and will work out what's going wrong.

-- 
Bruce Cran

