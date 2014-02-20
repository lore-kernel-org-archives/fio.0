Return-Path: <fio-owner@vger.kernel.org>
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:44239 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754384AbaBTNU4 (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 20 Feb 2014 08:20:56 -0500
Received: from /spool/local
	by e06smtp12.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <fio@vger.kernel.org> from <ehrhardt@linux.vnet.ibm.com>;
	Thu, 20 Feb 2014 13:20:55 -0000
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
	by d06dlp03.portsmouth.uk.ibm.com (Postfix) with ESMTP id 7C3E81B0805F
	for <fio@vger.kernel.org>; Thu, 20 Feb 2014 13:20:31 +0000 (GMT)
Received: from d06av04.portsmouth.uk.ibm.com (d06av04.portsmouth.uk.ibm.com [9.149.37.216])
	by b06cxnps3074.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id s1KDKfYv1049078
	for <fio@vger.kernel.org>; Thu, 20 Feb 2014 13:20:41 GMT
Received: from d06av04.portsmouth.uk.ibm.com (localhost [127.0.0.1])
	by d06av04.portsmouth.uk.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s1KDKpaZ019117
	for <fio@vger.kernel.org>; Thu, 20 Feb 2014 06:20:52 -0700
Message-Id: <20140220132050.493701099@linux.vnet.ibm.com>
Date: Thu, 20 Feb 2014 14:20:00 +0100
From: ehrhardt@linux.vnet.ibm.com
Subject: [patch 2/9] fio: allow general repeatability
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: oberpar@linux.vnet.ibm.com, Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>

*Resend with hopefully non mangled patches*
References: <20140220131958.965092001@linux.vnet.ibm.com>
Content-Disposition: inline; filename=repeatable-global-randomness.diff

From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>

This patch adds a "allrandrepeat" option similar to the existing randrepeat.
But other than the former option it does not only affect the random I/O pattern,
but also all remaining users of randomness as well.

By that e.g. testcases using nrfiles, filesize ranges, blocksizesplit ranges
and so on will stay repeatable across (euqally parametrized) runs as well.
To maintain compatibility the default is off. 

Signed-off-by: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
---

[diffstat]
 fio.1     |    8 ++++++--
 init.c    |    6 ++++++
 options.c |    7 +++++++
 3 files changed, 19 insertions(+), 2 deletions(-)


[diff]

--- a/fio.1
+++ b/fio.1
@@ -293,8 +293,12 @@ read, write, and trim are accounted and
 set, the fio will sum the results and report them as "mixed" instead.
 .TP
 .BI randrepeat \fR=\fPbool
-Seed the random number generator in a predictable way so results are repeatable
-across runs.  Default: true.
+Seed the random number generator used for random I/O patterns in a predictable
+way so the pattern is repeatable across runs.  Default: true.
+.TP
+.BI allrandrepeat \fR=\fPbool
+Seed all random number generators in a predictable way so results are
+repeatable across runs.  Default: false.
 .TP
 .BI randseed \fR=\fPint
 Seed the random number generators based on this seed value, to be able to
--- a/init.c
+++ b/init.c
@@ -751,6 +751,12 @@ static void td_fill_rand_seeds_internal(
 
 void td_fill_rand_seeds(struct thread_data *td)
 {
+	if (td->o.allrand_repeatable) {
+		for (int i = 0; i < FIO_RAND_NR_OFFS; i++)
+			td->rand_seeds[i] = FIO_RANDSEED * td->thread_number
+			       	+ i;
+	}
+
 	if (td->o.use_os_rand)
 		td_fill_rand_seeds_os(td);
 	else
--- a/options.c
+++ b/options.c
@@ -1784,6 +1784,13 @@ struct fio_option fio_options[FIO_MAX_OP
 		.group	= FIO_OPT_G_RANDOM,
 	},
 	{
+		.name	= "allrandrepeat",
+		.type	= FIO_OPT_BOOL,
+		.off1	= td_var_offset(allrand_repeatable),
+		.help	= "Use repeatable random numbers for everything",
+		.def	= "0",
+	},
+	{
 		.name	= "nrfiles",
 		.lname	= "Number of files",
 		.alias	= "nr_files",

