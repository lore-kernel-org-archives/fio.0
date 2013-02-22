Return-Path: <fio-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:54561
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754406Ab3BVMJf (ORCPT
	<rfc822;fio@vger.kernel.org>); Fri, 22 Feb 2013 07:09:35 -0500
Date: Fri, 22 Feb 2013 13:07:59 +0100
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Output logs and keep command line display
Message-ID: <20130222120759.GU25617@kernel.dk>
References: <CANUChTxynLg7p5kK1vex9965qvYxyFagzk8QAtbh-2-=_Mdxhg@mail.gmail.com>
 <20130131140223.GI8800@kernel.dk>
 <20130131140854.GJ8800@kernel.dk>
 <CANUChTwu9UJt1rYSb4JZ-URXVpDmEnTmteApGRcasJM06nR0ow@mail.gmail.com>
 <20130131142425.GK8800@kernel.dk>
 <CANUChTxnudOx6B3HjWfbD36Cq31eGTA3W2+qbGDYLjr+sJP4cw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANUChTxnudOx6B3HjWfbD36Cq31eGTA3W2+qbGDYLjr+sJP4cw@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Gavin Martin <gavin_martin@xyratex.com>
Cc: fio@vger.kernel.org

On Tue, Feb 12 2013, Gavin Martin wrote:
> On 31 January 2013 14:24, Jens Axboe <axboe@kernel.dk> wrote:
> > On Thu, Jan 31 2013, Gavin Martin wrote:
> >> On 31 January 2013 14:08, Jens Axboe <axboe@kernel.dk> wrote:
> >> > On Thu, Jan 31 2013, Jens Axboe wrote:
> >> >> On Thu, Jan 31 2013, Gavin Martin wrote:
> >> >> > Hi,
> >> >> >
> >> >> > Not sure if I am missing a special argument somewhere, but I like the
> >> >> > command line display we get from Fio when it runs showing the type of
> >> >> > workload and job descriptions and percentage complete, etc.  Is it
> >> >> > possible to get the outputs that you get when using the --minimal
> >> >> > argument (in JSON, CSV formats) whilst still keeping the command line
> >> >> > display.
> >> >> >
> >> >> > Having this would make it similar to Iometer, not in a graphical
> >> >> > sense, but in a way that you can see exactly what is occurring (and if
> >> >> > it has halted or crashed) whilst still having logs that could be
> >> >> > charted or plotted into reports.  Especially useful for extended test
> >> >> > runs (over several hours!)
> >> >>
> >> >> --eta=always
> >> >>
> >> >> should do the trick for you, if I understand your request correctly. I
> >> >> suppose for that to be useful, you want to redirect the csv/json output
> >> >> to a file as well?
> >> >>
> >> >> Might be useful to have the behaviour of:
> >> >>
> >> >> --output-format=type [file]
> >> >>
> >> >> where if 'file' is given, then output goes to that file in the specified
> >> >> format, and fio still uses stdout for the ETA output.
> >> >
> >> > So we already have --output, so we don't need the extra argument to the
> >> > format option. What is missing is just the below - that will continue to
> >> > use the ETA running output to stdout, if a file was chosen for the
> >> > output of the results.
> >> >
> >> > IOW, if you do:
> >> >
> >> > $ fio --output-format=json --output=somefile
> >> >
> >> > then fio (with the below patch) would output results to 'somefile' while
> >> > still doing the running stdout output.
> >> >
> >> > That should do what you need, correct?
> >> >
> >> >
> >> > diff --git a/eta.c b/eta.c
> >> > index 39fe10f..cfb8679 100644
> >> > --- a/eta.c
> >> > +++ b/eta.c
> >> > @@ -285,7 +285,8 @@ int calc_thread_status(struct jobs_eta *je, int force)
> >> >         static struct timeval rate_prev_time, disp_prev_time;
> >> >
> >> >         if (!force) {
> >> > -               if (output_format != FIO_OUTPUT_NORMAL)
> >> > +               if (output_format != FIO_OUTPUT_NORMAL &&
> >> > +                   f_out == stdout)
> >> >                         return 0;
> >> >                 if (temp_stall_ts || eta_print == FIO_ETA_NEVER)
> >> >                         return 0;
> >> >
> >> > --
> >> > Jens Axboe
> >> >
> >> > --
> >> > To unsubscribe from this list: send the line "unsubscribe fio" in
> >> > the body of a message to majordomo@vger.kernel.org
> >> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>
> >> Hi Jens,
> >>
> >> You are quick, I was half-way through a reply when you came back with
> >> an answer :)
> >>
> >> Yes keeping the std output as per normal, and also having the CSV/JSON
> >> output to a file that we can use to create graphs and reports. As you
> >> suggest above that would work.
> >
> > Thought so, I will commit it.
> >
> >>  The only problem I can see is from increasing the memory usage due to
> >> the extra logging.  Would implementing this increase the memory usage?
> >
> > The ETA logging carries no additional memory overhead, so that is not a
> > concern.
> >
> > --
> > Jens Axboe
> >
> 
> Hi Jens,
> 
> I've only just had time to test out this feature and with the
> arguments from above "--output-format=json --output=somefile" it
> writes to the file, but does not display the normal stdout.
> 
> If I run Fio as per normal on the command line, I get this:-
> 
> {quote}
> [root@localhost ~]# fio-2.0.13-122 iometer.fio
> iometer: (g=0): rw=randrw, bs=512-64K/512-64K/512-64K,
> ioengine=libaio, iodepth=64
> fio-2.0.13-122-g6d0e
> Starting 1 process
> Jobs: 1 (f=1): [m] [-.-% done] [4112K/790K/0K /s] [976 /220 /0  iops]
> [eta 00m:00s]
> iometer: (groupid=0, jobs=1): err= 0: pid=6313: Tue Feb 12 02:37:03 2013
>   Description  : [Emulation of Intel IOmeter File Server Access Pattern]
>   read : io=8401.6KB, bw=3770.9KB/s, iops=855 , runt=  2228msec
>     slat (usec): min=3 , max=94 , avg=16.40, stdev= 5.85
>     clat (usec): min=380 , max=534304 , avg=52967.40, stdev=69114.82
>      lat (usec): min=395 , max=534324 , avg=52984.40, stdev=69114.86
>     clat percentiles (usec):
>      |  1.00th=[  572],  5.00th=[ 1432], 10.00th=[ 3344], 20.00th=[ 8512],
>      | 30.00th=[15168], 40.00th=[22656], 50.00th=[30336], 60.00th=[41216],
>      | 70.00th=[55040], 80.00th=[76288], 90.00th=[123392], 95.00th=[177152],
>      | 99.00th=[358400], 99.50th=[395264], 99.90th=[477184], 99.95th=[536576],
>      | 99.99th=[536576]
>     bw (KB/s)  : min= 3701, max= 4194, per=100.00%, avg=3968.25, stdev=221.70
>   write: io=1838.6KB, bw=844983 B/s, iops=188 , runt=  2228msec
>     slat (usec): min=4 , max=54 , avg=19.80, stdev= 5.82
>     clat (msec): min=2 , max=914 , avg=98.35, stdev=100.41
>      lat (msec): min=2 , max=914 , avg=98.38, stdev=100.41
>     clat percentiles (msec):
>      |  1.00th=[    5],  5.00th=[   11], 10.00th=[   16], 20.00th=[   26],
>      | 30.00th=[   39], 40.00th=[   56], 50.00th=[   70], 60.00th=[   92],
>      | 70.00th=[  115], 80.00th=[  149], 90.00th=[  215], 95.00th=[  273],
>      | 99.00th=[  445], 99.50th=[  553], 99.90th=[  914], 99.95th=[  914],
>      | 99.99th=[  914]
>     bw (KB/s)  : min=  665, max= 1063, per=100.00%, avg=871.25, stdev=188.88
>     lat (usec) : 500=0.39%, 750=1.50%, 1000=1.07%
>     lat (msec) : 2=2.84%, 4=3.65%, 10=10.49%, 20=12.81%, 50=28.66%
>     lat (msec) : 100=20.93%, 250=13.62%, 500=3.87%, 750=0.09%, 1000=0.09%
>   cpu          : usr=2.11%, sys=3.19%, ctx=1972, majf=0, minf=25
>   IO depths    : 1=0.1%, 2=0.1%, 4=0.2%, 8=0.3%, 16=0.7%, 32=1.4%, >=64=97.3%
>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.1%, >=64=0.0%
>      issued    : total=r=1907/w=420/d=0, short=r=0/w=0/d=0
> 
> Run status group 0 (all jobs):
>    READ: io=8401KB, aggrb=3770KB/s, minb=3770KB/s, maxb=3770KB/s,
> mint=2228msec, maxt=2228msec
>   WRITE: io=1838KB, aggrb=824KB/s, minb=824KB/s, maxb=824KB/s,
> mint=2228msec, maxt=2228msec
> 
> Disk stats (read/write):
>   sda: ios=1565/371, merge=136/5, ticks=73336/33855, in_queue=113886,
> util=94.83%
> {/quote}
> 
> I would still like this but at the same time have the json output in a
> file, if I run the command with the arguments for output, all I get
> is:-
> 
> {quote}
> [root@localhost ~]# fio-2.0.13-122 iometer.fio --output=test.log
> --output-format=json
> [root@localhost ~]# -.-% done] [4558K/798K/0K /s] [1100 /224 /0  iops]
> [eta 00m:00s]
> {/quote}
> 
> The output file is created as normal, so no issue there, just no
> stdout display, am I doing something wrong?.

There's currently no support for using multiple types of output. It
could be accomplished with something ala:

--output-format=json,normal

or something like that, but that would influence --output as well (which
one goes there? Both?).

I'd be happy to provide support for this, I can see how it would be
useful. Even better if ideas were suggested on how best to implement
this, from the users perspective.

-- 
Jens Axboe

