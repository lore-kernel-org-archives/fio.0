Return-Path: <axboe@kernel.dk>
Message-ID: <54494059.8030207@kernel.dk>
Date: Thu, 23 Oct 2014 11:52:25 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Per-thread and aggregate bandwidth reporting
References: <CAGRFgs1Urv6c41Roz9_QKJsP-7yw-ihDKoe3VUq87anDNJWF5g@mail.gmail.com> <CAGRFgs23OL8CDXOA5ENik+B+kPk2s_U_E+kYA9PAr4opux3jYQ@mail.gmail.com>
In-Reply-To: <CAGRFgs23OL8CDXOA5ENik+B+kPk2s_U_E+kYA9PAr4opux3jYQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: George Smith <glsmith555@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 10/23/2014 11:04 AM, George Smith wrote:
> Uh oh, silence is never good :)  Please let me know if I haven't
> included key information, missed something obvious, etc.
> 
> Here's maybe a clearer example of what I'm talking about.  The output
> file is from a read test using 5 threads:
> 
> # grep 'read :' output.out
>  read : io=51200MB, bw=116673KB/s, iops=113 , runt=449367msec
>  read : io=51200MB, bw=189201KB/s, iops=184 , runt=277106msec
>  read : io=51200MB, bw=143385KB/s, iops=140 , runt=365650msec
>  read : io=51200MB, bw=114654KB/s, iops=111 , runt=457279msec
>  read : io=51200MB, bw=183110KB/s, iops=178 , runt=286324msec
> 
> # grep READ output.out
>   READ: io=256000MB, aggrb=573269KB/s, minb=114653KB/s,
> maxb=189201KB/s, mint=277106msec, maxt=457279msec
> 
> 
> The sum of the threads is 747023, but aggrb is 573269.  The bw= value
> in each thread line is the amount of I/O (from io=) divided by the
> time the I/O took.
> 
> The aggrb= value is the total amount of I/O done (which is the sum of
> each thread's io= value), divided by maxt, which seems to be the
> maximum time seen during the run (which happens to be with my 4th
> thread).
> 
> So it appears that this is the discrepancy.  I'm not sure if it's
> correct to say the aggregate bandwidth is the total I/O divided by the
> max time that one of the threads in the group took to complete.  Seems
> like taking the average time and dividing total I/O by that would be
> more correct.
> 
> Am I missing the spirit of what the READ line is supposed to be conveying to me?

I think you deduced it correctly. And yes, it is a bit misleading, in
that it differs from the sum of the reported bandwidths. Neither number
really makes sense, however.

-- 
Jens Axboe


