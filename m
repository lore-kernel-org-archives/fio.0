Return-Path: <haghdoost@gmail.com>
MIME-Version: 1.0
In-Reply-To: <1921541814.317725.1419063992558.JavaMail.zimbra@thomas-krenn.com>
References: <2028599731.63796.1418644100540.JavaMail.zimbra@thomas-krenn.com>
 <548EFB15.8080704@kernel.dk> <54915786.3010009@enovance.com>
 <54919A81.8010007@kernel.dk> <1921541814.317725.1419063992558.JavaMail.zimbra@thomas-krenn.com>
From: Alireza Haghdoost <haghdoost@gmail.com>
Date: Sat, 20 Dec 2014 10:38:39 -0600
Message-ID: <CAB-428mX2x+PQ64n7v49aWRhv1koEVLp-fSV9jnJ0Cdqj6TZJw@mail.gmail.com>
Subject: Re: SSD write latency lower than read latency
Content-Type: text/plain; charset=ISO-8859-1
To: =?ISO-8859-1?Q?Georg_Sch=F6nberger?= <gschoenberger@thomas-krenn.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Erwan Velu <erwan@enovance.com>, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

> Regarding iodepth, I am using 1 job with 1 outstanding IO - as stated in the specification -
> to circumvent IO scheduler influences. I thought higher queue depths will always lead to
> higher latencies, correct? (https://www.kernel.org/doc/Documentation/block/stat.txt)
> Therefore testing with 1 nj/1 iod will generate comparable latency results, or not?

In the report you have mentioned IO Depth of 16. Do you mean you set
16 for Throughput and IOPS test and then reduce the Depth to 1 for
latency test ? While your statement about the impact of queue depth on
the latency is make sense to me, it is hard to make a connection
between IOPS numbers generated with IO Depth of 16 to Latency numbers
generated with IO Depth 1.


> Another question, is there a chance to turn off this cache?
> It seems it is not the regular device write cache, as I turned it off with "hdparm -W"
> and latencies seem to produce the same results (just on a quick test).

I believe it is vendor specific, mostly drives don't honor such a
requests or even cache flush requests.

