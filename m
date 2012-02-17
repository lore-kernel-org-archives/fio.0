Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:53761 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755377Ab2BQB2C (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 16 Feb 2012 20:28:02 -0500
Received: by eaaf13 with SMTP id f13so91253eaa.1
        for <fio@vger.kernel.org>; Thu, 16 Feb 2012 17:28:00 -0800 (PST)
MIME-Version: 1.0
From: Dan Ehrenberg <dehrenberg@google.com>
Subject: [RFC] fio: Token-based flow control
Date: Thu, 16 Feb 2012 17:27:33 -0800
Message-Id: <1329442053-28519-1-git-send-email-dehrenberg@google.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: nauman@google.com, egouriou@google.com, tirea@google.com, Dan Ehrenberg <dehrenberg@google.com>

This patch allows two fio jobs to be kept to a certain
proportion of each other using token-based flow control.
There are three new parameters: flow, flow_watermark, and
flow_sleep, documented in the fio options. An example of an fio
job using these parameters is below:

[global]
norandommap
thread
time_based
runtime=30
direct=1
ioengine=libaio
iodepth=256
size=100g
bs=8k
filename=/tmp/testfile
flow_watermark=100
flow_sleep=1000

[job2]
numjobs=1
rw=write
flow=-8

[job1]
numjobs=1
rw=randread
flow=1

The motivating application of this patch was to allow random reads
and sequential writes at a particular given proportion.

This initial version is only correct when run with 'thread', as shared
state is represented with a global variable. It also only allows two
jobs to be synchronized properly. A future version might do more, but
no more functionality was needed for my application.

Tested: Ran a few fio jobs with this flow control, observing
the proportion of IOPS to match what was intended by the job file.
Varied the flow_watermark and flow_sleep parameters and observed
the effect on throughput.

Signed-off-by: Dan Ehrenberg <dehrenberg@google.com>
---
 HOWTO     |   16 ++++++++++++++++
 backend.c |   27 +++++++++++++++++++++++++++
 fio.h     |    4 ++++
 options.c |   24 ++++++++++++++++++++++++
 4 files changed, 71 insertions(+), 0 deletions(-)

diff --git a/HOWTO b/HOWTO
index c6304a7..d246968 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1231,6 +1231,22 @@ uid=int		Instead of running as the invoking user, set the user ID to
 
 gid=int		Set group ID, see uid.
 
+flow=int	Weight in token-based flow control. If this value is used, then
+		there is a global 'flow counter' which is used to regulate the
+		proportion of activity between two jobs. fio attempts to keep
+		this flow counter near zero. The 'flow' parameter stands for
+		how much should be added or subtracted to the flow counter on
+		each iteration of the main I/O loop. That is, if one job has
+		flow=8 and another job has flow=-1, then there will be a roughly
+		1:8 ratio in how much one runs vs the other.
+
+flow_watermark=int	The maximum value that the absolute value of the flow
+		counter is allowed to reach before the job must wait for a
+		lower value of the counter.
+
+flow_sleep=int	The period of time, in microseconds, to wait after the flow
+		watermark has been exceeded before retrying operations
+
 In addition, there are some parameters which are only valid when a specific
 ioengine is in use. These are used identically to normal parameters, with the
 caveat that when used on the command line, they must come after the ioengine
diff --git a/backend.c b/backend.c
index e567ad5..485f835 100644
--- a/backend.c
+++ b/backend.c
@@ -65,6 +65,7 @@ unsigned int nr_thread = 0;
 int shm_id = 0;
 int temp_stall_ts;
 unsigned long done_secs = 0;
+long long int flow_counter = 0;
 
 #define PAGE_ALIGN(buf)	\
 	(char *) (((unsigned long) (buf) + page_mask) & ~page_mask)
@@ -363,6 +364,26 @@ static int break_on_this_error(struct thread_data *td, enum fio_ddir ddir,
 	return 0;
 }
 
+static int is_flow_threshold_exceeded(struct thread_data *td)
+{
+	int sign;
+
+	if (!td->o.flow)
+		return 0;
+
+	sign = td->o.flow > 0 ? 1 : -1;
+	if (sign * flow_counter > td->o.flow_watermark) {
+		if (td->o.flow_sleep)
+			usleep(td->o.flow_sleep);
+		return 1;
+	}
+
+	/* No synchronization needed because it doesn't
+	 * matter if the flow count is slightly inaccurate */
+	flow_counter += td->o.flow;
+	return 0;
+}
+
 /*
  * The main verify engine. Runs over the writes we previously submitted,
  * reads the blocks back in, and checks the crc/md5 of the data.
@@ -408,6 +429,9 @@ static void do_verify(struct thread_data *td)
 			}
 		}
 
+		if (is_flow_threshold_exceeded(td))
+			continue;
+
 		io_u = __get_io_u(td);
 		if (!io_u)
 			break;
@@ -559,6 +583,9 @@ static void do_io(struct thread_data *td)
 			}
 		}
 
+		if (is_flow_threshold_exceeded(td))
+			continue;
+
 		io_u = get_io_u(td);
 		if (!io_u)
 			break;
diff --git a/fio.h b/fio.h
index c462980..f2150af 100644
--- a/fio.h
+++ b/fio.h
@@ -258,6 +258,10 @@ struct thread_options {
 	unsigned int uid;
 	unsigned int gid;
 
+	int flow;
+	int flow_watermark;
+	unsigned int flow_sleep;
+
 	unsigned int sync_file_range;
 };
 
diff --git a/options.c b/options.c
index c3fdb56..4aa3d4c 100644
--- a/options.c
+++ b/options.c
@@ -2170,6 +2170,30 @@ static struct fio_option options[FIO_MAX_OPTS] = {
 		.help	= "Run job with this group ID",
 	},
 	{
+		.name	= "flow",
+		.type	= FIO_OPT_INT,
+		.off1	= td_var_offset(flow),
+		.help	= "Weight for flow control of this job",
+		.def	= "0",
+	},
+	{
+		.name	= "flow_watermark",
+		.type	= FIO_OPT_INT,
+		.off1	= td_var_offset(flow_watermark),
+		.help	= "High watermark for flow control. This option"
+			" should be set to the same value for all threads"
+			" with non-zero flow.",
+		.def	= "1024",
+	},
+	{
+		.name	= "flow_sleep",
+		.type	= FIO_OPT_INT,
+		.off1	= td_var_offset(flow_sleep),
+		.help	= "How many microseconds to sleep after being held"
+			" back by the flow control mechanism",
+		.def	= "0",
+	},
+	{
 		.name = NULL,
 	},
 };
-- 
1.7.7.3

