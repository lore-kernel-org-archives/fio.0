Return-Path: <fio-owner@vger.kernel.org>
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:49077 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753771AbaBSPMl (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 19 Feb 2014 10:12:41 -0500
Received: from /spool/local
	by e06smtp14.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <fio@vger.kernel.org> from <ehrhardt@linux.vnet.ibm.com>;
	Wed, 19 Feb 2014 15:12:40 -0000
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
	by d06dlp03.portsmouth.uk.ibm.com (Postfix) with ESMTP id 99E791B08070
	for <fio@vger.kernel.org>; Wed, 19 Feb 2014 15:12:15 +0000 (GMT)
Received: from d06av12.portsmouth.uk.ibm.com (d06av12.portsmouth.uk.ibm.com [9.149.37.247])
	by b06cxnps4075.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id s1JFCP1Y60424304
	for <fio@vger.kernel.org>; Wed, 19 Feb 2014 15:12:25 GMT
Received: from d06av12.portsmouth.uk.ibm.com (localhost [127.0.0.1])
	by d06av12.portsmouth.uk.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s1JFCafc005500
	for <fio@vger.kernel.org>; Wed, 19 Feb 2014 08:12:37 -0700
Message-ID: <5304C9E4.2020607@linux.vnet.ibm.com>
Date: Wed, 19 Feb 2014 16:12:36 +0100
From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
MIME-Version: 1.0
Subject: [patch 4/9] fio: provide an option for a startdelay range
References: <20140219143639.168501090@linux.vnet.ibm.com>
In-Reply-To: <20140219143639.168501090@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: oberpar@linux.vnet.ibm.com, Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>

From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>

This patch allows the specification of start delay as range.
With a range each thread will chose an individual startdelay out of the 
range.

That solves an issue of startdelay being the same for each numjob clone and
that way spreads all kind of activities e.g. that all clones with mixed r/w
jobs switch r/w at the same time.
Also all kind of other "thundering herd" issues can be softened by some
time spread due to this option.

Signed-off-by: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
---

[diffstat]
  fio.1     |    8 ++++++--
  fio.h     |    5 +++++
  init.c    |   25 +++++++++++++++++++++++++
  options.c |    1 +
  4 files changed, 37 insertions(+), 2 deletions(-)

[diff]

--- a/fio.1
+++ b/fio.1
@@ -846,8 +846,12 @@ needed to be specified. For \fBprefer\fR
  allowed. For \fBbind\fR and \fBinterleave\fR, \fBnodelist\fR allows
  comma delimited list of numbers, A-B ranges, or 'all'.
  .TP
-.BI startdelay \fR=\fPint
-Delay start of job for the specified number of seconds.
+.BI startdelay \fR=\fPirange
+Delay start of job for the specified number of seconds. Supports all time
+suffixes to allow specification of hours, minutes, seconds and
+milliseconds - seconds are the default if a unit is ommited.
+Can be given as a range which causes each thread to choose randomly out 
of the
+range.
  .TP
  .BI runtime \fR=\fPint
  Terminate processing after the specified number of seconds.
--- a/fio.h
+++ b/fio.h
@@ -85,6 +85,7 @@ enum {
  	FIO_RAND_SEQ_RAND_READ_OFF,
  	FIO_RAND_SEQ_RAND_WRITE_OFF,
  	FIO_RAND_SEQ_RAND_TRIM_OFF,
+	FIO_RAND_START_DELAY,
  	FIO_RAND_NR_OFFS,
  };
  @@ -164,6 +165,10 @@ struct thread_data {
  		os_random_state_t trim_state;
  		struct frand_state __trim_state;
  	};
+	union {
+		os_random_state_t delay_state;
+		struct frand_state __delay_state;
+	};
   	struct frand_state buf_state;
  --- a/init.c
+++ b/init.c
@@ -412,6 +412,26 @@ static int fixed_block_size(struct threa
  		o->min_bs[DDIR_READ] == o->min_bs[DDIR_TRIM];
  }
  +
+static unsigned long long get_rand_start_delay(struct thread_data *td)
+{
+	unsigned long long delayrange;
+	unsigned long r;
+
+	delayrange = td->o.start_delay_high - td->o.start_delay;
+
+	if (td->o.use_os_rand) {
+		r = os_random_long(&td->delay_state);
+		delayrange = (unsigned long long) ((double) delayrange * (r / 
(OS_RAND_MAX + 1.0)));
+	} else {
+		r = __rand(&td->__delay_state);
+		delayrange = (unsigned long long) ((double) delayrange * (r / 
(FRAND_MAX + 1.0)));
+	}
+
+	delayrange += td->o.start_delay;
+	return delayrange;
+}
+
  /*
   * Lazy way of fixing up options that depend on each other. We could also
   * define option callback handlers, but this is easier.
@@ -496,6 +516,9 @@ static int fixup_options(struct thread_d
  	if (!o->file_size_high)
  		o->file_size_high = o->file_size_low;
  +	if (o->start_delay_high)
+		o->start_delay = get_rand_start_delay(td);
+
  	if (o->norandommap && o->verify != VERIFY_NONE
  	    && !fixed_block_size(o))  {
  		log_err("fio: norandommap given for variable block sizes, "
@@ -711,6 +734,7 @@ static void td_fill_rand_seeds_os(struct
   	os_random_seed(td->rand_seeds[FIO_RAND_FILE_SIZE_OFF], 
&td->file_size_state);
  	os_random_seed(td->rand_seeds[FIO_RAND_TRIM_OFF], &td->trim_state);
+	os_random_seed(td->rand_seeds[FIO_RAND_START_DELAY], &td->delay_state);
   	if (!td_random(td))
  		return;
@@ -736,6 +760,7 @@ static void td_fill_rand_seeds_internal(
   	init_rand_seed(&td->__file_size_state, 
td->rand_seeds[FIO_RAND_FILE_SIZE_OFF]);
  	init_rand_seed(&td->__trim_state, td->rand_seeds[FIO_RAND_TRIM_OFF]);
+	init_rand_seed(&td->__delay_state, td->rand_seeds[FIO_RAND_START_DELAY]);
   	if (!td_random(td))
  		return;
--- a/options.c
+++ b/options.c
@@ -2018,6 +2018,7 @@ struct fio_option fio_options[FIO_MAX_OP
  		.lname	= "Start delay",
  		.type	= FIO_OPT_STR_VAL_TIME,
  		.off1	= td_var_offset(start_delay),
+		.off2	= td_var_offset(start_delay_high),
  		.help	= "Only start job when this period has passed",
  		.def	= "0",
  		.category = FIO_OPT_C_GENERAL,


