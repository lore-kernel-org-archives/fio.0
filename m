Return-Path: <fio-owner@vger.kernel.org>
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:37090 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754620AbaBTNVA (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 20 Feb 2014 08:21:00 -0500
Received: from /spool/local
	by e06smtp16.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <fio@vger.kernel.org> from <ehrhardt@linux.vnet.ibm.com>;
	Thu, 20 Feb 2014 13:20:59 -0000
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
	by d06dlp03.portsmouth.uk.ibm.com (Postfix) with ESMTP id 23F2B1B08066
	for <fio@vger.kernel.org>; Thu, 20 Feb 2014 13:20:36 +0000 (GMT)
Received: from d06av02.portsmouth.uk.ibm.com (d06av02.portsmouth.uk.ibm.com [9.149.37.228])
	by b06cxnps4075.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id s1KDKjMl66978022
	for <fio@vger.kernel.org>; Thu, 20 Feb 2014 13:20:45 GMT
Received: from d06av02.portsmouth.uk.ibm.com (localhost [127.0.0.1])
	by d06av02.portsmouth.uk.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s1KDKt1A022342
	for <fio@vger.kernel.org>; Thu, 20 Feb 2014 06:20:56 -0700
Message-Id: <20140220132050.651641496@linux.vnet.ibm.com>
Date: Thu, 20 Feb 2014 14:20:01 +0100
From: ehrhardt@linux.vnet.ibm.com
Subject: [patch 3/9] fio: allow milliseconds on all time specifiers
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: oberpar@linux.vnet.ibm.com, Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>

*Resend with hopefully non mangled patches*
References: <20140220131958.965092001@linux.vnet.ibm.com>
Content-Disposition: inline; filename=support-milliseconds.diff

From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>

This patch allows all time specifiers to be specified down to milliseconds.
Default will stay seconds for compatibility with old configs.

It also adds documentation to the existing time units day, hour and minute.

Signed-off-by: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
---

[diffstat]
 backend.c |    4 ++--
 eta.c     |   14 ++++++++------
 fio.1     |   16 ++++++++++------
 parse.c   |   48 ++++++++++++++++++++++++++++++++++--------------
 time.c    |    2 +-
 5 files changed, 55 insertions(+), 29 deletions(-)

[diff]

--- a/backend.c
+++ b/backend.c
@@ -346,7 +346,7 @@ static inline int runtime_exceeded(struc
 		return 0;
 	if (!td->o.timeout)
 		return 0;
-	if (mtime_since(&td->epoch, t) >= td->o.timeout * 1000)
+	if (mtime_since(&td->epoch, t) >= td->o.timeout )
 		return 1;
 
 	return 0;
@@ -1783,7 +1783,7 @@ static void run_threads(void)
 			if (td->o.start_delay) {
 				spent = mtime_since_genesis();
 
-				if (td->o.start_delay * 1000 > spent)
+				if (td->o.start_delay > spent)
 					continue;
 			}
 
--- a/eta.c
+++ b/eta.c
@@ -174,7 +174,8 @@ static int thread_eta(struct thread_data
 			perc = 1.0;
 
 		if (td->o.time_based) {
-			perc_t = (double) elapsed / (double) td->o.timeout;
+			perc_t = (double) elapsed /
+					(double) (td->o.timeout / 1000);
 			if (perc_t < perc)
 				perc = perc_t;
 		}
@@ -182,8 +183,9 @@ static int thread_eta(struct thread_data
 		eta_sec = (unsigned long) (elapsed * (1.0 / perc)) - elapsed;
 
 		if (td->o.timeout &&
-		    eta_sec > (td->o.timeout + done_secs - elapsed))
-			eta_sec = td->o.timeout + done_secs - elapsed;
+		    eta_sec > ( (td->o.timeout / 1000) + done_secs - elapsed))
+			eta_sec = (td->o.timeout / 1000)  + done_secs
+			       		- elapsed;
 	} else if (td->runstate == TD_NOT_CREATED || td->runstate == TD_CREATED
 			|| td->runstate == TD_INITIALIZED
 			|| td->runstate == TD_SETTING_UP
@@ -197,8 +199,8 @@ static int thread_eta(struct thread_data
 		 * if given, otherwise assume it'll run at the specified rate.
 		 */
 		if (td->o.timeout) {
-			t_eta = td->o.timeout + td->o.start_delay +
-					td->o.ramp_time;
+			t_eta = (td->o.timeout + td->o.start_delay  +
+					td->o.ramp_time ) / 1000;
 
 			if (in_ramp_time(td)) {
 				unsigned long ramp_left;
@@ -212,7 +214,7 @@ static int thread_eta(struct thread_data
 		rate_bytes = ddir_rw_sum(td->o.rate);
 		if (rate_bytes) {
 			r_eta = (bytes_total / 1024) / rate_bytes;
-			r_eta += td->o.start_delay;
+			r_eta += td->o.start_delay / 1000;
 		}
 
 		if (r_eta && t_eta)
--- a/fio.1
+++ b/fio.1
@@ -121,12 +121,16 @@ String: a sequence of alphanumeric chara
 SI integer: a whole number, possibly containing a suffix denoting the base unit
 of the value.  Accepted suffixes are `k', 'M', 'G', 'T', and 'P', denoting
 kilo (1024), mega (1024^2), giga (1024^3), tera (1024^4), and peta (1024^5)
-respectively. The suffix is not case sensitive. If prefixed with '0x', the
-value is assumed to be base 16 (hexadecimal). A suffix may include a trailing 'b',
-for instance 'kb' is identical to 'k'. You can specify a base 10 value
-by using 'KiB', 'MiB', 'GiB', etc. This is useful for disk drives where
-values are often given in base 10 values. Specifying '30GiB' will get you
-30*1000^3 bytes.
+respectively. If prefixed with '0x', the value is assumed to be base 16
+(hexadecimal). A suffix may include a trailing 'b', for instance 'kb' is
+identical to 'k'. You can specify a base 10 value by using 'KiB', 'MiB','GiB',
+etc. This is useful for disk drives where values are often given in base 10
+values. Specifying '30GiB' will get you 30*1000^3 bytes.
+When specifying times the default suffix meaning changes, still denoting the
+base unit of the value, but accepted suffixes are 'D' (days), 'H' (hours), 'M'
+(minutes), 'S' Seconds, 'ms' milli seconds. Time values without a unit specify
+seconds.
+The suffixes are not case sensitive.
 .TP
 .I bool
 Boolean: a true or false value. `0' denotes false, `1' denotes true.
--- a/parse.c
+++ b/parse.c
@@ -122,21 +122,41 @@ static void show_option_help(struct fio_
 	show_option_values(o);
 }
 
-static unsigned long get_mult_time(char c)
+static unsigned long long get_mult_time(const char *str, int len)
 {
-	switch (c) {
-	case 'm':
-	case 'M':
-		return 60;
-	case 'h':
-	case 'H':
-		return 60 * 60;
-	case 'd':
-	case 'D':
-		return 24 * 60 * 60;
-	default:
-		return 1;
+	const char *p = str;
+	char *c;
+	unsigned long long mult = 1000;
+
+	/*
+         * Go forward until we hit a non-digit, or +/- sign
+         */
+	while ((p - str) <= len) {
+		if (!isdigit((int) *p) && (*p != '+') && (*p != '-'))
+			break;
+		p++;
 	}
+
+	if (!isalpha((int) *p))
+		return 1000;
+
+	c = strdup(p);
+	for (int i = 0; i < strlen(c); i++)
+		c[i] = tolower(c[i]);
+
+	if (!strncmp("ms", c, 2))
+		mult = 1;
+	else if (!strcmp("s", c))
+		mult = 1000;
+	else if (!strcmp("m", c))
+		mult = 60 * 1000;
+	else if (!strcmp("h", c))
+		mult = 60 * 60 * 1000;
+	else if (!strcmp("d", c))
+		mult = 24 * 60 * 60 * 1000;
+
+	free(c);
+	return mult;
 }
 
 static int is_separator(char c)
@@ -275,7 +295,7 @@ int str_to_decimal(const char *str, long
 		else
 			*val *= mult;
 	} else
-		*val *= get_mult_time(str[len - 1]);
+		*val *= get_mult_time(str, len);
 
 	return 0;
 }
--- a/time.c
+++ b/time.c
@@ -71,7 +71,7 @@ int ramp_time_over(struct thread_data *t
 		return 1;
 
 	fio_gettime(&tv, NULL);
-	if (mtime_since(&td->epoch, &tv) >= td->o.ramp_time * 1000) {
+	if (mtime_since(&td->epoch, &tv) >= td->o.ramp_time ) {
 		td->ramp_time_over = 1;
 		reset_all_stats(td);
 		td_set_runstate(td, TD_RAMP);

