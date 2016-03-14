Return-Path: <fio-owner@vger.kernel.org>
Received: from g4t3425.houston.hp.com ([15.201.208.53]:30979 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbcCNUkZ convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Mon, 14 Mar 2016 16:40:25 -0400
From: "Wolford, Jeff (HPE Servers - Web Scale performance)" 
	<jeff.wolford@hpe.com>
Subject: RE: Monitor IO while fio is running
Date: Mon, 14 Mar 2016 20:40:10 +0000
Message-ID: <DC12A894E6E89949B50B1F35C3903C1B3B57A76D@G4W3291.americas.hpqcorp.net>
References: <e0428ae214c0407bb565172a563e79ad@AUSX13MPC103.AMER.DELL.COM>
 <BN3PR0401MB1457AF32B8D51A1BC9512D4AF7880@BN3PR0401MB1457.namprd04.prod.outlook.com>
 <c0aff70ec5314c33a41556b828fb7bd1@AUSX13MPC107.AMER.DELL.COM>
 <CAB-428nKSCiuYQphBf7Ti0saWM8WkjL7kdr6wYw7ePxgKjHWXw@mail.gmail.com>
 <946c934a239d4c6abda0dbbfc0124e58@AUSX13MPC107.AMER.DELL.COM>
In-Reply-To: <946c934a239d4c6abda0dbbfc0124e58@AUSX13MPC107.AMER.DELL.COM>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Kurt_Dorsey@Dell.com" <Kurt_Dorsey@Dell.com>, "alireza@cs.umn.edu" <alireza@cs.umn.edu>
Cc: "jeff.furlong@hgst.com" <jeff.furlong@hgst.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

Stupid question time:

Have you used the "--output filename.log" option ?
(that is the option I always use)

Or if you want to stay with std redirection, have you tried to redirect "stderr" ?

Jeff



| -----Original Message-----
| From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On Behalf Of
| Kurt_Dorsey@Dell.com
| Sent: Monday, March 14, 2016 2:27 PM
| To: alireza@cs.umn.edu
| Cc: jeff.furlong@hgst.com; fio@vger.kernel.org
| Subject: RE: Monitor IO while fio is running
| 
| Hi Alireza, Thank you for the response
| 
| 
| If I run the command on the bash command line I get this (full output with 1 second
| intervals for the status /usr/local/bin/fio --group_reporting=1 --name=test_workload
| --time_based --runtime=10 --rw=randread --bs=16K --filename=/dev/sdb  --eta-
| newline=1
| test_workload: (g=0): rw=randread, bs=16K-16K/16K-16K/16K-16K,
| ioengine=sync, iodepth=1 fio-2.7-5-g5f2f Starting 1 process
| Jobs: 1 (f=1): [r(1)] [36.4% done] [78176KB/0KB/0KB /s] [4886/0/0 iops] [eta
| 00m:07s]
| Jobs: 1 (f=1): [r(1)] [54.5% done] [79072KB/0KB/0KB /s] [4942/0/0 iops] [eta
| 00m:05s]
| Jobs: 1 (f=1): [r(1)] [72.7% done] [79088KB/0KB/0KB /s] [4943/0/0 iops] [eta
| 00m:03s]
| Jobs: 1 (f=1): [r(1)] [90.9% done] [81056KB/0KB/0KB /s] [5066/0/0 iops] [eta
| 00m:01s]
| Jobs: 1 (f=1): [r(1)] [100.0% done] [80304KB/0KB/0KB /s] [5019/0/0 iops] [eta
| 00m:00s]
| test_workload: (groupid=0, jobs=1): err= 0: pid=75170: Mon Mar 14 14:21:47 2016
|   read : io=795824KB, bw=79574KB/s, iops=4973, runt= 10001msec
|     clat (usec): min=136, max=7872, avg=198.30, stdev=59.80
|      lat (usec): min=136, max=7872, avg=198.49, stdev=59.81
|     clat percentiles (usec):
| 
| But if I redirect to a file the file is missing the Jobs:1 intervals /usr/local/bin/fio --
| group_reporting=1 --name=test_workload  --time_based --runtime=10 --
| rw=randread --bs=16K --filename=/dev/sdb  --eta-newline=1  > test.out cat test.out
| test_workload: (g=0): rw=randread, bs=16K-16K/16K-16K/16K-16K,
| ioengine=sync, iodepth=1 fio-2.7-5-g5f2f Starting 1 process
| 
| test_workload: (groupid=0, jobs=1): err= 0: pid=75251: Mon Mar 14 14:23:30 2016
|   read : io=796416KB, bw=79634KB/s, iops=4977, runt= 10001msec
|     clat (usec): min=136, max=519, avg=198.15, stdev=30.34
|      lat (usec): min=136, max=519, avg=198.34, stdev=30.35
|     clat percentiles (usec):
|      |  1.00th=[  145],  5.00th=[  161], 10.00th=[  163], 20.00th=[  169],
|      | 30.00th=[  179], 40.00th=[  183], 50.00th=[  193], 60.00th=[  207],
|      | 70.00th=[  211], 80.00th=[  235], 90.00th=[  243], 95.00th=[  247],
|      | 99.00th=[  262], 99.50th=[  270], 99.90th=[  282], 99.95th=[  290],
|      | 99.99th=[  314]
|     bw (KB  /s): min=78304, max=80960, per=100.00%, avg=79654.74,
| stdev=673.82
|     lat (usec) : 250=96.25%, 500=3.75%, 750=0.01%
|   cpu          : usr=2.49%, sys=11.79%, ctx=49808, majf=0, minf=37
|   IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%,
| >=64=0.0%
|      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%,
| >=64=0.0%
|      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%,
| >=64=0.0%
|      issued    : total=r=49776/w=0/d=0, short=r=0/w=0/d=0, drop=r=0/w=0/d=0
|      latency   : target=0, window=0, percentile=100.00%, depth=1
| 
| Run status group 0 (all jobs):
|    READ: io=796416KB, aggrb=79633KB/s, minb=79633KB/s, maxb=79633KB/s,
| mint=10001msec, maxt=10001msec
| 
| Disk stats (read/write):
|   sdb: ios=49309/0, merge=147930/0, ticks=8643/0, in_queue=8627, util=86.28%
| 
| 
| I have also tried
| | tee test.out
| 
| With the same resules.
| Looking at the FIO source I see that when Jen's uses log_buf (  it will output to a
| file and I can also watch the output inside python but when uses printf( it will only
| output to the screen.
| 
| Thank you,
| Kurt
| 
| -----Original Message-----
| From: Alireza Haghdoost [mailto:alireza@cs.umn.edu]
| Sent: Monday, March 14, 2016 1:37 PM
| To: Dorsey, Kurt
| Cc: jeff.furlong@hgst.com; fio@vger.kernel.org
| Subject: Re: Monitor IO while fio is running
| 
| You should be able to redirect it to a file. Would you mind share with us how you
| set the redirection?
| 
| On Mon, Mar 14, 2016 at 1:03 PM, wrote:
| > Thank you Jeff for the reply.
| >
| > I have been playing around with this but unfortunately I cannot get
| > the output to be outputted anywhere other than the screen / terminal.
| > I have tried redirecting it to a txt file and parsing with with a
| > python script but nothing ever gets output. (It only outputs to the
| > screen)
| >
| > I haven't done C programming in years but I am trying to figure out
| > from the code why this is. I see in the eta.c file
| >
| > void display_thread_status(struct jobs_eta *je) { ...
| > printf("%s", output);
| >
| > if (!eta_new_line_init) {
| > fio_gettime(&disp_eta_new_line, NULL); eta_new_line_init = 1; } else
| > if (eta_new_line && mtime_since_now(&disp_eta_new_line) >
| > eta_new_line) { fio_gettime(&disp_eta_new_line, NULL);
| > eta_new_line_pending = 1; }
| >
| > fflush(stdout);
| >
| >
| > It prints everything to the screen but I cannot redirect it at all
| >
| > Thoughts?
| > Thank you,
| > Kurt
| >
| >
| > -----Original Message-----
| > From: Jeff Furlong [mailto:jeff.furlong@hgst.com]
| > Sent: Monday, March 14, 2016 12:56 PM
| > To: Dorsey, Kurt ; fio@vger.kernel.org
| > Subject: RE: Monitor IO while fio is running
| >
| > You might add --eta=always and --eta-newline=1 to get the current IOPs rate
| every 1s, printed to stdout. You can parse that current IOPs rate via a script and
| do something. I believe the IOPs rate is recalculated every 1s, not the average
| from beginning of test.
| >
| > Not sure why --eta and --eta-newline is not in the latest HOWTO notes.
| >
| > Regards,
| > Jeff
| >
| > -----Original Message-----
| > From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On
| > Behalf Of Kurt_Dorsey@Dell.com
| > Sent: Saturday, March 12, 2016 2:20 PM
| > To: fio@vger.kernel.org
| > Subject: Monitor IO while fio is running
| >
| > I may just not know how to do this
| > I know about the ability to touch /tmp/fio-dump-status which will dump the output
| of fio to a file or stdout while the test is running. What I am looking for is to be able
| to dump the write_iops_log while fio is running so that I can see the point in time
| average IOps for a given interval For example if I have log_avg_msec=60000 it will
| write an iops.log file with 60second intervals, unfortunately this file doesn't get
| created until fio exits. Is there a way to get this to dump on a regular basis (or by
| touching a file in /tmp) so that I can tail the output?
| >
| > I am looking for a way to get point in time status via a script and
| > the output from tmp-dump-status only gives me averages from the start
| > of time rather than the last interval
| >
| > Thank you,
| > Kurt
| > --
| > To unsubscribe from this list: send the line "unsubscribe fio" in the
| > body of a message to majordomo@vger.kernel.org More majordomo info at
| > http://vger.kernel.org/majordomo-info.html
| > Western Digital Corporation (and its subsidiaries) E-mail Confidentiality Notice &
| Disclaimer:
| >
| > This e-mail and any files transmitted with it may contain confidential or legally
| privileged information of WDC and/or its affiliates, and are intended solely for the
| use of the individual or entity to which they are addressed. If you are not the
| intended recipient, any disclosure, copying, distribution or any action taken or
| omitted to be taken in reliance on it, is prohibited. If you have received this e-mail
| in error, please notify the sender immediately and delete the e-mail in its entirety
| from your system.
| > --
| > To unsubscribe from this list: send the line "unsubscribe fio" in the
| > body of a message to majordomo@vger.kernel.org More majordomo info at
| > http://vger.kernel.org/majordomo-info.html
| --
| To unsubscribe from this list: send the line "unsubscribe fio" in the body of a
| message to majordomo@vger.kernel.org More majordomo info at
| http://vger.kernel.org/majordomo-info.html
