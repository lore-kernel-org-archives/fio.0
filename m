Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ob0-f178.google.com ([209.85.214.178]:47248 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721AbaJWREj convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Thu, 23 Oct 2014 13:04:39 -0400
Received: by mail-ob0-f178.google.com with SMTP id wn1so1060004obc.23
        for <fio@vger.kernel.org>; Thu, 23 Oct 2014 10:04:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGRFgs1Urv6c41Roz9_QKJsP-7yw-ihDKoe3VUq87anDNJWF5g@mail.gmail.com>
References: <CAGRFgs1Urv6c41Roz9_QKJsP-7yw-ihDKoe3VUq87anDNJWF5g@mail.gmail.com>
Date: Thu, 23 Oct 2014 11:04:39 -0600
Message-ID: <CAGRFgs23OL8CDXOA5ENik+B+kPk2s_U_E+kYA9PAr4opux3jYQ@mail.gmail.com>
Subject: Re: Per-thread and aggregate bandwidth reporting
From: George Smith <glsmith555@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Uh oh, silence is never good :)  Please let me know if I haven't
included key information, missed something obvious, etc.

Here's maybe a clearer example of what I'm talking about.  The output
file is from a read test using 5 threads:

# grep 'read :' output.out
 read : io=51200MB, bw=116673KB/s, iops=113 , runt=449367msec
 read : io=51200MB, bw=189201KB/s, iops=184 , runt=277106msec
 read : io=51200MB, bw=143385KB/s, iops=140 , runt=365650msec
 read : io=51200MB, bw=114654KB/s, iops=111 , runt=457279msec
 read : io=51200MB, bw=183110KB/s, iops=178 , runt=286324msec

# grep READ output.out
  READ: io=256000MB, aggrb=573269KB/s, minb=114653KB/s,
maxb=189201KB/s, mint=277106msec, maxt=457279msec


The sum of the threads is 747023, but aggrb is 573269.  The bw= value
in each thread line is the amount of I/O (from io=) divided by the
time the I/O took.

The aggrb= value is the total amount of I/O done (which is the sum of
each thread's io= value), divided by maxt, which seems to be the
maximum time seen during the run (which happens to be with my 4th
thread).

So it appears that this is the discrepancy.  I'm not sure if it's
correct to say the aggregate bandwidth is the total I/O divided by the
max time that one of the threads in the group took to complete.  Seems
like taking the average time and dividing total I/O by that would be
more correct.

Am I missing the spirit of what the READ line is supposed to be conveying to me?

Thanks,

--gs

On Tue, Oct 21, 2014 at 11:55 AM, George Smith <glsmith555@gmail.com> wrote:
> Hello,
>
> I use multiple threads for read and write tests, and use group
> reporting to see each thread's stats.  So in my output file, I have
> something like this:
>
> -----
>
> JOB: (groupid=0, jobs=1): err= 0: pid=17829: Tue Oct 21 12:36:24 2014
>  Description  : [foo]
>  write: io=12288MB, bw=30371KB/s, iops=59 , runt=414309msec
>    clat (usec): min=297 , max=30868K, avg=16722.93, stdev=321816.10
>     lat (usec): min=297 , max=30868K, avg=16723.20, stdev=321816.11
>    clat percentiles (usec):
>     |  1.00th=[  326],  5.00th=[  334], 10.00th=[  338], 20.00th=[  342],
>     | 30.00th=[  350], 40.00th=[  358], 50.00th=[  366], 60.00th=[  386],
>     | 70.00th=[  410], 80.00th=[  486], 90.00th=[  572], 95.00th=[  668],
>     | 99.00th=[45824], 99.50th=[626688], 99.90th=[4554752], 99.95th=[5865472],
>     | 99.99th=[10289152]
>    bw (KB/s)  : min=   16, max=1002496, per=32.23%, avg=78205.35,
> stdev=182341.44
>    lat (usec) : 500=82.77%, 750=13.07%, 1000=0.68%
>    lat (msec) : 2=1.42%, 4=0.44%, 10=0.15%, 20=0.23%, 50=0.26%
>    lat (msec) : 100=0.15%, 250=0.14%, 500=0.13%, 750=0.09%, 1000=0.08%
>    lat (msec) : 2000=0.15%, >=2000=0.24%
>  cpu          : usr=0.77%, sys=2.91%, ctx=24853, majf=0, minf=4
>  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
>     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>     issued    : total=r=0/w=24576/d=0, short=r=0/w=0/d=0
>
> … (another thread) …
> … (another thread) ...
>
> Run status group 0 (all jobs):
>  WRITE: io=98304MB, aggrb=242665KB/s, minb=30333KB/s, maxb=44320KB/s,
> mint=283908msec, maxt=414823msec
>
> -----
>
>
> If I go through and parse each "write" line (in this example), and add
> up all the "bw=" numbers, that does not equal the "aggrb" number
> reported at the end (it's higher by about 15%).
>
> I thought "aggrb" would just be a rollup of all the individual
> thread's bandwidth, so I'm having a hard time determining why the two
> numbers don't match.  Maybe my basic assumption is incorrect, and if
> that's true then which numbers are correct -- the per-thread numbers,
> or the aggregate number?
>
> Thanks for any help…
>
> --gs
