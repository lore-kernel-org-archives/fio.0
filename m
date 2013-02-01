Return-Path: <gschoenberger@thomas-krenn.com>
Date: Fri, 1 Feb 2013 07:35:55 +0100 (CET)
From: Georg =?utf-8?Q?Sch=C3=B6nberger?= <gschoenberger@thomas-krenn.com>
Message-ID: <1591158599.146984.1359700554967.JavaMail.root@thomas-krenn.com>
In-Reply-To: <20130129130212.GB8800@kernel.dk>
Subject: Re: Group reporting with latency and IOPS
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Antonio Jose Rodrigues Neto <Antonio.Jose.Rodrigues.Neto@netapp.com>
List-ID: <fio@vger.kernel.org>

> On Mon, Jan 28 2013, Neto, Antonio Jose Rodrigues wrote:
> > Hi All,
> > 
> > This is neto from Brazil
> > 
> > How are you?
> > 
> > I just need a help to make sure I understood correctly the report
> > (see below --Output).
> > 
> > Trying to generate 80% Read and 20% Write - 8KB block size
> > 
> > Reads
> > IOPS: 15330
> > Latency: (clat) 628usecs - 0.628ms
> 
> Correct. Well 629 really, if rounded properly.
> 
> > Writes
> > IOPS: 3827
> > Latency: (clat) 577usecs - 0.577ms
> 
> Correct too.
> 
> > Am I doing the correct analysis?
> 
> Yep.
> 
> > One question is: Is it possible to have global IOPS and latency?
> 
> You mean for both read and write combined? Fio does not report that,
> but
> for IOPS you could just add them. For latency, the larger of the two.
> 

Hi Jens,

you say here that the total Latency for a mixed workload is the larger of the two.
Why is it not the sum of the two i.e.
Total Latency Read + Total Latency Write ?

Best Regards, Georg

> --
> Jens Axboe

