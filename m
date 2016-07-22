Return-Path: <axboe@kernel.dk>
Date: Fri, 22 Jul 2016 08:47:02 -0600
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: what is the sample logger doing when the buffer fills up?
Message-ID: <20160722144702.GA7328@kernel.dk>
References: <CAF+0mvnTM6Rv3Vh1oOZd=9TQ1wVtWWrHMVkbKxdisufiYvZ0Zw@mail.gmail.com>
 <BN3PR0401MB1457463C7131E975F7ED0812F7370@BN3PR0401MB1457.namprd04.prod.outlook.com>
 <CAJ9yE1CkoXrkK2PowRkSyby6zbb+ngWFAD-AariWcp64FNTZNw@mail.gmail.com>
 <BN3PR0401MB145725E84C509D7F14BC2C2FF7080@BN3PR0401MB1457.namprd04.prod.outlook.com>
 <BN3PR0401MB14573F44F190D9B11CCF836FF7080@BN3PR0401MB1457.namprd04.prod.outlook.com>
 <805ada82-a3be-5b0f-226c-258d7e6f7711@kernel.dk>
 <CAJ9yE1CXNBvGFnJ1FNnodRKanXrqMgEfJsBrCz1dXBcNq4Qwxg@mail.gmail.com>
 <BN3PR0401MB1457787C3D5632BD79FFFC5BF7090@BN3PR0401MB1457.namprd04.prod.outlook.com>
 <CAJ9yE1AYiuwX2tZbybqQw25YtGC8U40_JRz_iFQWypei_EVcMg@mail.gmail.com>
 <BN3PR0401MB1457883E34BC695500DEAF57F7090@BN3PR0401MB1457.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="5vNYLRcllDrimb99"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BN3PR0401MB1457883E34BC695500DEAF57F7090@BN3PR0401MB1457.namprd04.prod.outlook.com>
To: Jeff Furlong <jeff.furlong@hgst.com>
Cc: Karl Cronburg <kcronbur@redhat.com>, Matthew Eaton <m.eaton82@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>


--5vNYLRcllDrimb99
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

I wonder if it's just a timing thing. I can't reproduce it so far, but
try with the attached patch.


On Thu, Jul 21 2016, Jeff Furlong wrote:
> The iops log shows some issues yet (7000 and 17000 missing):
> 
> 1000, 305109, 0, 0
> 2000, 309262, 0, 0
> 2000, 0, 1, 0
> 2000, 0, 2, 0
> 3000, 318219, 0, 0
> 3000, 0, 1, 0
> 3000, 0, 2, 0
> 4000, 320126, 0, 0
> 4000, 0, 1, 0
> 4000, 0, 2, 0
> 5000, 317922, 0, 0
> 5000, 0, 1, 0
> 5000, 0, 2, 0
> 6000, 316746, 0, 0
> 6000, 0, 1, 0
> 6000, 0, 2, 0
> 8000, 320652, 0, 0
> 8000, 0, 1, 0
> 8000, 0, 2, 0
> 8000, 0, 1, 0
> 9000, 320120, 0, 0
> 9000, 0, 2, 0
> 10000, 321516, 0, 0
> 10000, 0, 1, 0
> 10000, 0, 2, 0
> 11000, 320834, 0, 0
> 11000, 0, 1, 0
> 11000, 0, 2, 0
> 12000, 318659, 0, 0
> 12000, 0, 1, 0
> 12000, 0, 2, 0
> 13000, 320548, 0, 0
> 13000, 0, 1, 0
> 13000, 0, 2, 0
> 14000, 320859, 0, 0
> 14000, 0, 1, 0
> 14000, 0, 2, 0
> 15000, 321099, 0, 0
> 15000, 0, 1, 0
> 15000, 0, 2, 0
> 16000, 320426, 0, 0
> 16000, 0, 1, 0
> 16000, 0, 2, 0
> 18000, 320956, 0, 0
> 18000, 0, 1, 0
> 18000, 0, 2, 0
> 18000, 0, 1, 0
> 19000, 314649, 0, 0
> 19000, 0, 2, 0
> 20000, 321148, 0, 0
> 20000, 0, 1, 0
> 20000, 0, 2, 0
> 
> Regards,
> Jeff
> 
> -----Original Message-----
> From: Karl Cronburg [mailto:kcronbur@redhat.com] 
> Sent: Thursday, July 21, 2016 2:27 PM
> To: Jeff Furlong <jeff.furlong@hgst.com>
> Cc: Jens Axboe <axboe@kernel.dk>; Matthew Eaton <m.eaton82@gmail.com>; fio@vger.kernel.org
> Subject: Re: what is the sample logger doing when the buffer fills up?
> 
> Try changing stat.c:2351 to be "iops = 0;" instead of "continue;":
> 
> https://github.com/axboe/fio/blob/c16556af62cd1cd1ae31b6ee8706efc43c137f77/stat.c#L2351
> 
> It'll print a few garbage data points at the beginning of the files and it forces printing of all r/w directions, but for me this 'continue' is the line of code which bypasses logging of the missing IOP samples (namely it'll print zeros, because the comment says "No entries for interval"). I'd try it myself but I haven't been able to replicate the behavior with your fio command. For me the slat, clat, and lat logs are also missing the entries but I'm not sure if there
> *should* be any entries in my test case with librbd / ceph.
> 
> On Thu, Jul 21, 2016 at 1:00 PM, Jeff Furlong <jeff.furlong@hgst.com> wrote:
> > In my sample job, I'm logging everything: iops, bw, slat, clat, lat.  The iops and bw logs have missing entries (at the same time offset).  The slat, clat, lat logs appear fine (no missing entries).
> >
> > Regards,
> > Jeff
> >
> >
> > -----Original Message-----
> > From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On 
> > Behalf Of Karl Cronburg
> > Sent: Thursday, July 21, 2016 8:49 AM
> > To: Jens Axboe <axboe@kernel.dk>
> > Cc: Jeff Furlong <jeff.furlong@hgst.com>; Matthew Eaton 
> > <m.eaton82@gmail.com>; fio@vger.kernel.org
> > Subject: Re: what is the sample logger doing when the buffer fills up?
> >
> > Looks like we're waking up but not doing anything - debug trace:
> >
> > elapsed=1133
> > elapsed=1133
> > elapsed=1200
> > next_log=100
> > msec_to_next_event=99
> > next_log=100
> > msec_to_next_event=100
> > next_log=100
> > msec_to_next_event=100
> > next_log=100
> > msec_to_next_event=50
> > next_log=51
> > msec_to_next_event=51
> > next_log=100
> > msec_to_next_event=100
> > next_log=100
> > msec_to_next_event=99
> > next_log=100
> > msec_to_next_event=100
> > elapsed=1877
> > elapsed=1877
> > elapsed=1899
> >
> > ^ elapsed is printed after each log_avg_msec sample is added, and next_log and msec_to_next_event are printed in helper_thread_main.
> > This is the command I'm using:
> >
> > # ../fio --ioengine=rbd --clientname=admin --pool=cbt-librbdfio 
> > --rbdname=cbt-librbdfio-`hostname -s`-0 --invalidate=0  --rw=write
> > --numjobs=1 --bs=4M --name=librbdfio-`hostname -s`-0
> > --log_avg_msec=100 --runtime=5 --write_iops_log=test 
> > --write_lat_log=test --disable_slat=1 --disable_bw=1
> >
> > The gap from 1200 to 1900 corresponds to the lack of IOP entries in the log:
> >
> > 899, 20, 1, 0
> > 999, 10, 1, 0
> > 1200, 10, 1, 0
> > 1899, 10, 1, 0
> > 1999, 10, 1, 0
> > 2100, 20, 1, 0
> >
> > Will debug further.
> >
> > Jeff - are you seeing the same gaps in your latency logs as with your IOP logs? I'm not completely certain what I'm seeing here is the same.
> >
> > On Wed, Jul 20, 2016 at 7:46 PM, Jens Axboe <axboe@kernel.dk> wrote:
> >> I was suspicious that the drift fix would be something else. But at 
> >> least that's another bug fixed.
> >>
> >> The question is if we're waking up in the helper_thread at the right 
> >> time, and not deciding to do anything for whatever reason (which 
> >> would be a bug), or if we're not waking at all due to the math being 
> >> wrong (which would be another bug). It has to be one of those.
> >>
> >>
> >>
> >> On 07/20/2016 03:28 PM, Jeff Furlong wrote:
> >>>
> >>> Retrying the iops log output format (missing 3000 and 13000 is drifted):
> >>>
> >>> 1000, 299636, 0, 0
> >>> 2000, 354388, 0, 0
> >>> 4000, 337972, 0, 0
> >>> 5000, 323825, 0, 0
> >>> 6000, 337457, 0, 0
> >>> 7000, 327775, 0, 0
> >>> 8000, 361275, 0, 0
> >>> 9000, 348060, 0, 0
> >>> 10000, 340273, 0, 0
> >>> 11000, 349127, 0, 0
> >>> 12000, 329088, 0, 0
> >>> 12999, 349604, 0, 0
> >>> 14000, 322321, 0, 0
> >>> 15000, 319467, 0, 0
> >>>
> >>> Regards,
> >>> Jeff
> >>>
> >>> -----Original Message-----
> >>> From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] 
> >>> On Behalf Of Jeff Furlong
> >>> Sent: Wednesday, July 20, 2016 2:23 PM
> >>> To: Karl Cronburg <kcronbur@redhat.com>
> >>> Cc: Matthew Eaton <m.eaton82@gmail.com>; Jens Axboe 
> >>> <axboe@kernel.dk>; fio@vger.kernel.org
> >>> Subject: RE: what is the sample logger doing when the buffer fills up?
> >>>
> >>> I still see some samples as dropped.
> >>>
> >>> # fio -version
> >>> fio-2.12-23-gc165
> >>>
> >>> 1000, 299636, 0, 0
> >>> 2000, 354388, 0, 0 --> missing 3000 below 4000, 337972, 0, 0 5000, 
> >>> 323825, 0, 0 6000, 337457, 0, 0 7000, 327775, 0, 0 8000, 361275, 0, 
> >>> 0 9000, 348060, 0, 0 10000, 340273, 0, 0 11000, 349127, 0, 0 12000, 
> >>> 329088, 0, 0 12999, 349604, 0, 0 --> mild clock drift 14000, 322321, 
> >>> 0, 0 15000, 319467, 0, 0
> >>>
> >>> Regards,
> >>> Jeff
> >>>
> >>> -----Original Message-----
> >>> From: Karl Cronburg [mailto:kcronbur@redhat.com]
> >>> Sent: Wednesday, July 20, 2016 1:29 PM
> >>> To: Jeff Furlong <jeff.furlong@hgst.com>
> >>> Cc: Matthew Eaton <m.eaton82@gmail.com>; Jens Axboe 
> >>> <axboe@kernel.dk>; fio@vger.kernel.org
> >>> Subject: Re: what is the sample logger doing when the buffer fills up?
> >>>
> >>> PR 211 is one possible solution:
> >>> https://github.com/axboe/fio/pull/211
> >>>
> >>> The gaps in the IOPs logs are caused by drift in the value of 
> >>> avg_last forward in time, e.g. if there's a drift of 1 millisecond 
> >>> every time we output a sample and log_avg_msec=100, then every 100th 
> >>> IOP average gets a gap.
> >>>
> >>> On Mon, Jul 18, 2016 at 8:09 PM, Jeff Furlong 
> >>> <jeff.furlong@hgst.com>
> >>> wrote:
> >>>>
> >>>> I haven't been able to debug the issue all the way, but notice that 
> >>>> the reported time logs around the missing entries are not perfect.
> >>>> After time 5001us, the 6000us entry is missing.  After time 
> >>>> 21001us, the 22000us entry is missing.
> >>>>
> >>>> On my workloads, I see time 11999us, but time 11000 is missing.  So 
> >>>> the time logs go: 10000, 11999, 13000, 14000, etc.
> >>>>
> >>>> I suspect the issue to be in or near stat.c:
> >>>>
> >>>> static void add_log_sample(struct thread_data *td, struct io_log *iolog,
> >>>>                            unsigned long val, enum fio_ddir ddir,
> >>>>                            unsigned int bs, uint64_t offset) {
> >>>>         unsigned long elapsed, this_window;
> >>>>
> >>>>         if (!ddir_rw(ddir))
> >>>>                 return;
> >>>>
> >>>>         elapsed = mtime_since_now(&td->epoch);
> >>>>
> >>>>         /*
> >>>>          * If no time averaging, just add the log sample.
> >>>>          */
> >>>>         if (!iolog->avg_msec) {
> >>>>                 __add_log_sample(iolog, val, ddir, bs, elapsed, offset);
> >>>>                 return;
> >>>>         }
> >>>>
> >>>>         /*
> >>>>          * Add the sample. If the time period has passed, then
> >>>>          * add that entry to the log and clear.
> >>>>          */
> >>>>         add_stat_sample(&iolog->avg_window[ddir], val);
> >>>>
> >>>>         /*
> >>>>          * If period hasn't passed, adding the above sample is all we
> >>>>          * need to do.
> >>>>          */
> >>>>         this_window = elapsed - iolog->avg_last;
> >>>>         if (this_window < iolog->avg_msec)
> >>>>                 return;
> >>>>
> >>>>         _add_stat_to_log(iolog, elapsed, td->o.log_max != 0);
> >>>>
> >>>>         iolog->avg_last = elapsed;
> >>>> }
> >>>>
> >>>> Regards,
> >>>> Jeff
> >>>>
> >>>> -----Original Message-----
> >>>> From: Matthew Eaton [mailto:m.eaton82@gmail.com]
> >>>> Sent: Monday, July 18, 2016 11:24 AM
> >>>> To: Jens Axboe <axboe@kernel.dk>
> >>>> Cc: Jeff Furlong <jeff.furlong@hgst.com>; Karl Cronburg 
> >>>> <kcronbur@redhat.com>; fio@vger.kernel.org
> >>>> Subject: Re: what is the sample logger doing when the buffer fills up?
> >>>>
> >>>> I am also seeing this bug but with numjobs = 1.
> >>>>
> >>>> fio --numjobs=1 --iodepth=32 --ramp_time=1800 --runtime=1810 
> >>>> --time_based --rw=randwrite --bs=4k --ioengine=libaio --direct=1 
> >>>> --refill_buffers --norandommap --randrepeat=0 --log_avg_msec=1000 
> >>>> --write_iops_log=write --name=write-iops --filename=/dev/sdb
> >>>>
> >>>> fio-2.12-12-g45213
> >>>>
> >>>> 3000, 23033, 1, 0
> >>>> 4000, 23035, 1, 0
> >>>> 5001, 25463, 1, 0 <<<
> >>>> 7000, 24649, 1, 0 <<<
> >>>> 8000, 27103, 1, 0
> >>>> 9000, 23004, 1, 0
> >>>> 10000, 23064, 1, 0
> >>>> 11000, 26199, 1, 0
> >>>> 12000, 23107, 1, 0
> >>>> 13000, 28734, 1, 0
> >>>> 14000, 23853, 1, 0
> >>>> 15000, 28739, 1, 0
> >>>> 16000, 27061, 1, 0
> >>>> 17000, 25504, 1, 0
> >>>> 18000, 29550, 1, 0
> >>>> 19000, 23842, 1, 0
> >>>> 20000, 23056, 1, 0
> >>>> 21001, 23010, 1, 0 <<<
> >>>> 23000, 24236, 1, 0 <<<
> >>>> 24000, 23867, 1, 0
> >>>> 25000, 25459, 1, 0
> >>>>
> >>>> On Thu, Jul 7, 2016 at 2:50 PM, Jens Axboe <axboe@kernel.dk> wrote:
> >>>>>
> >>>>> On 07/07/2016 03:47 PM, Jeff Furlong wrote:
> >>>>>>
> >>>>>>
> >>>>>> There are more.  In a 60s test, logging every 1s, I see 6 to 7 
> >>>>>> samples get dropped.  But I only see it when numjobs > 1.
> >>>>>
> >>>>>
> >>>>>
> >>>>> OK, I'll take a look.
> >>>>>
> >>>>>
> >>>>> --
> >>>>> Jens Axboe
> >>>>>
> >>>>> --
> >>>>> To unsubscribe from this list: send the line "unsubscribe fio" in 
> >>>>> the body of a message to majordomo@vger.kernel.org More majordomo 
> >>>>> info at http://vger.kernel.org/majordomo-info.html
> >>>>
> >>>> Western Digital Corporation (and its subsidiaries) E-mail 
> >>>> Confidentiality Notice & Disclaimer:
> >>>>
> >>>> This e-mail and any files transmitted with it may contain 
> >>>> confidential or legally privileged information of WDC and/or its 
> >>>> affiliates, and are intended solely for the use of the individual 
> >>>> or entity to which they are addressed. If you are not the intended 
> >>>> recipient, any disclosure, copying, distribution or any action 
> >>>> taken or omitted to be taken in reliance on it, is prohibited. If 
> >>>> you have received this e-mail in error, please notify the sender immediately and delete the e-mail in its entirety from your system.
> >>>
> >>> Western Digital Corporation (and its subsidiaries) E-mail 
> >>> Confidentiality Notice & Disclaimer:
> >>>
> >>> This e-mail and any files transmitted with it may contain 
> >>> confidential or legally privileged information of WDC and/or its 
> >>> affiliates, and are intended solely for the use of the individual or 
> >>> entity to which they are addressed. If you are not the intended 
> >>> recipient, any disclosure, copying, distribution or any action taken 
> >>> or omitted to be taken in reliance on it, is prohibited. If you have 
> >>> received this e-mail in error, please notify the sender immediately and delete the e-mail in its entirety from your system.
> >>>   {.n +       +%  lzwm  b 맲  r  y   {ay  ʇڙ ,j   f   h   z   w       j:+v
> >>> w j m         zZ+     ݢj"  ! i
> >>> Western Digital Corporation (and its subsidiaries) E-mail 
> >>> Confidentiality Notice & Disclaimer:
> >>>
> >>> This e-mail and any files transmitted with it may contain 
> >>> confidential or legally privileged information of WDC and/or its 
> >>> affiliates, and are intended solely for the use of the individual or 
> >>> entity to which they are addressed. If you are not the intended 
> >>> recipient, any disclosure, copying, distribution or any action taken 
> >>> or omitted to be taken in reliance on it, is prohibited. If you have 
> >>> received this e-mail in error, please notify the sender immediately and delete the e-mail in its entirety from your system.
> >>>
> >>
> >> --
> >> Jens Axboe
> >>
> > --
> > To unsubscribe from this list: send the line "unsubscribe fio" in the 
> > body of a message to majordomo@vger.kernel.org More majordomo info at  
> > http://vger.kernel.org/majordomo-info.html
> > Western Digital Corporation (and its subsidiaries) E-mail Confidentiality Notice & Disclaimer:
> >
> > This e-mail and any files transmitted with it may contain confidential or legally privileged information of WDC and/or its affiliates, and are intended solely for the use of the individual or entity to which they are addressed. If you are not the intended recipient, any disclosure, copying, distribution or any action taken or omitted to be taken in reliance on it, is prohibited. If you have received this e-mail in error, please notify the sender immediately and delete the e-mail in its entirety from your system.
> Western Digital Corporation (and its subsidiaries) E-mail Confidentiality Notice & Disclaimer:
> 
> This e-mail and any files transmitted with it may contain confidential or legally privileged information of WDC and/or its affiliates, and are intended solely for the use of the individual or entity to which they are addressed. If you are not the intended recipient, any disclosure, copying, distribution or any action taken or omitted to be taken in reliance on it, is prohibited. If you have received this e-mail in error, please notify the sender immediately and delete the e-mail in its entirety from your system.

-- 
Jens Axboe


--5vNYLRcllDrimb99
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="fio-missing-log.patch"

diff --git a/stat.c b/stat.c
index 08a402a74c6d..21ce523d6d02 100644
--- a/stat.c
+++ b/stat.c
@@ -2107,14 +2107,14 @@ static void _add_stat_to_log(struct io_log *iolog, unsigned long elapsed,
 		__add_stat_to_log(iolog, ddir, elapsed, log_max);
 }
 
-static void add_log_sample(struct thread_data *td, struct io_log *iolog,
+static long add_log_sample(struct thread_data *td, struct io_log *iolog,
 			   unsigned long val, enum fio_ddir ddir,
 			   unsigned int bs, uint64_t offset)
 {
 	unsigned long elapsed, this_window;
 
 	if (!ddir_rw(ddir))
-		return;
+		return 0;
 
 	elapsed = mtime_since_now(&td->epoch);
 
@@ -2123,7 +2123,7 @@ static void add_log_sample(struct thread_data *td, struct io_log *iolog,
 	 */
 	if (!iolog->avg_msec) {
 		__add_log_sample(iolog, val, ddir, bs, elapsed, offset);
-		return;
+		return 0;
 	}
 
 	/*
@@ -2138,11 +2138,12 @@ static void add_log_sample(struct thread_data *td, struct io_log *iolog,
 	 */
 	this_window = elapsed - iolog->avg_last;
 	if (this_window < iolog->avg_msec)
-		return;
+		return iolog->avg_msec - this_window;
 
 	_add_stat_to_log(iolog, elapsed, td->o.log_max != 0);
 
 	iolog->avg_last = elapsed - (this_window - iolog->avg_msec);
+	return iolog->avg_msec;
 }
 
 void finalize_logs(struct thread_data *td, bool unit_logs)
@@ -2264,6 +2265,9 @@ static int add_bw_samples(struct thread_data *td, struct timeval *t)
 	struct thread_stat *ts = &td->ts;
 	unsigned long spent, rate;
 	enum fio_ddir ddir;
+	unsigned int next, next_log;
+
+	next_log = td->o.bw_avg_time;
 
 	spent = mtime_since(&td->bw_sample_time, t);
 	if (spent < td->o.bw_avg_time &&
@@ -2295,7 +2299,8 @@ static int add_bw_samples(struct thread_data *td, struct timeval *t)
 			if (td->o.min_bs[ddir] == td->o.max_bs[ddir])
 				bs = td->o.min_bs[ddir];
 
-			add_log_sample(td, td->bw_log, rate, ddir, bs, 0);
+			next = add_log_sample(td, td->bw_log, rate, ddir, bs, 0);
+			next_log = min(next_log, next);
 		}
 
 		td->stat_io_bytes[ddir] = td->this_io_bytes[ddir];
@@ -2306,9 +2311,10 @@ static int add_bw_samples(struct thread_data *td, struct timeval *t)
 	td_io_u_unlock(td);
 
 	if (spent <= td->o.bw_avg_time)
-		return td->o.bw_avg_time;
+		return min(next_log, td->o.bw_avg_time);
 
-	return td->o.bw_avg_time - (1 + spent - td->o.bw_avg_time);
+	next = td->o.bw_avg_time - (1 + spent - td->o.bw_avg_time);
+	return min(next, next_log);
 }
 
 void add_iops_sample(struct thread_data *td, struct io_u *io_u,
@@ -2332,6 +2338,9 @@ static int add_iops_samples(struct thread_data *td, struct timeval *t)
 	struct thread_stat *ts = &td->ts;
 	unsigned long spent, iops;
 	enum fio_ddir ddir;
+	unsigned int next, next_log;
+
+	next_log = td->o.iops_avg_time;
 
 	spent = mtime_since(&td->iops_sample_time, t);
 	if (spent < td->o.iops_avg_time &&
@@ -2363,7 +2372,8 @@ static int add_iops_samples(struct thread_data *td, struct timeval *t)
 			if (td->o.min_bs[ddir] == td->o.max_bs[ddir])
 				bs = td->o.min_bs[ddir];
 
-			add_log_sample(td, td->iops_log, iops, ddir, bs, 0);
+			next = add_log_sample(td, td->iops_log, iops, ddir, bs, 0);
+			next_log = min(next_log, next);
 		}
 
 		td->stat_io_blocks[ddir] = td->this_io_blocks[ddir];
@@ -2374,9 +2384,10 @@ static int add_iops_samples(struct thread_data *td, struct timeval *t)
 	td_io_u_unlock(td);
 
 	if (spent <= td->o.iops_avg_time)
-		return td->o.iops_avg_time;
+		return min(next_log, td->o.iops_avg_time);
 
-	return td->o.iops_avg_time - (1 + spent - td->o.iops_avg_time);
+	next = td->o.iops_avg_time - (1 + spent - td->o.iops_avg_time);
+	return min(next, next_log);
 }
 
 /*

--5vNYLRcllDrimb99--

