Return-Path: <fio-owner@vger.kernel.org>
Received: from mxi1.enovance.com ([94.143.114.217]:40782 "EHLO
	mxi1.enovance.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932388Ab3GVV46 (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 22 Jul 2013 17:56:58 -0400
Received: from zimbra.enovance.com (94-143-114-250.enovance.net [94.143.114.250])
	by mxi1.enovance.com (Postfix) with ESMTP id F15E33817B
	for <fio@vger.kernel.org>; Mon, 22 Jul 2013 23:56:56 +0200 (CEST)
Received: from localhost (mail-1 [127.0.0.1])
	by zimbra.enovance.com (Postfix) with ESMTP id EC3AC3C81421
	for <fio@vger.kernel.org>; Mon, 22 Jul 2013 23:56:56 +0200 (CEST)
Received: from zimbra.enovance.com ([127.0.0.1])
	by localhost (zimbra.enovance.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EpKHVN2oJyQ1 for <fio@vger.kernel.org>;
	Mon, 22 Jul 2013 23:56:56 +0200 (CEST)
Received: from localhost (mail-1 [127.0.0.1])
	by zimbra.enovance.com (Postfix) with ESMTP id 870336E44A3
	for <fio@vger.kernel.org>; Mon, 22 Jul 2013 23:56:56 +0200 (CEST)
Received: from zimbra.enovance.com ([127.0.0.1])
	by localhost (zimbra.enovance.com [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id eJyy6wGs1ZsG for <fio@vger.kernel.org>;
	Mon, 22 Jul 2013 23:56:56 +0200 (CEST)
Received: from localhost.localdomain (lns-bzn-48f-62-147-157-222.adsl.proxad.net [62.147.157.222])
	by zimbra.enovance.com (Postfix) with ESMTPSA id F0D4D126CC0E
	for <fio@vger.kernel.org>; Mon, 22 Jul 2013 23:56:55 +0200 (CEST)
Message-ID: <51EDAAA7.4070103@enovance.com>
Date: Mon, 22 Jul 2013 23:56:55 +0200
From: Erwan Velu <erwan@enovance.com>
MIME-Version: 1.0
Subject: [Pull Request] Various fixes reported by Clang
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hey,

I had the curiosity to check how fio was considered by clang.
The "--analyze" option of clang is something levering interesting bugs.

In fact, there is many false positive but some were real.
I've been pushing a branch featuring the associated fixes. That's almost 
nothing but I cannot close my eyes on it ;o)

Cheers,
Erwan

The following changes since commit d7e30e61f2c1d9c6101cc6896009750aae2e2bcf:

   fio2gnuplot: Don't plot fake data (2013-07-22 19:39:24 +0200)

are available in the git repository at:

   git@github.com:enovance/fio.git clang

for you to fetch changes up to 2fdbefdd43968f3bf354a488288b9794b5f5c6bb:

   core: Insure "il" is initialized in all cases (2013-07-22 23:48:48 +0200)

----------------------------------------------------------------
Erwan Velu (3):
       core: Removing duplicated code
       core: Don't leak memory if error is unknown
       core: Insure "il" is initialized in all cases

  init.c    | 2 --
  options.c | 1 +
  parse.c   | 2 +-
  stat.c    | 6 ++----
  4 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/init.c b/init.c
index 70b56e3..d808eb6 100644
--- a/init.c
+++ b/init.c
@@ -1755,8 +1755,6 @@ int parse_cmd_line(int argc, char *argv[], int 
client_type)
          case FIO_GETOPT_IOENGINE: {
              const char *opt = l_opts[lidx].name;
              char *val = optarg;
-            opt = l_opts[lidx].name;
-            val = optarg;
              ret = fio_cmd_ioengine_option_parse(td, opt, val);
              break;
          }
diff --git a/options.c b/options.c
index 6462c67..1c44f42 100644
--- a/options.c
+++ b/options.c
@@ -271,6 +271,7 @@ static int ignore_error_type(struct thread_data *td, 
int etype, char *str)
          if (!error[i]) {
              log_err("Unknown error %s, please use number value \n",
                    fname);
+            free(error);
              return 1;
          }
          i++;
diff --git a/parse.c b/parse.c
index f54dae6..d3eb2c4 100644
--- a/parse.c
+++ b/parse.c
@@ -380,7 +380,7 @@ static int str_match_len(const struct value_pair 
*vp, const char *str)
  static int __handle_option(struct fio_option *o, const char *ptr, void 
*data,
                 int first, int more, int curr)
  {
-    int il, *ilp;
+    int il=0, *ilp;
      fio_fp64_t *flp;
      long long ull, *ullp;
      long ul1, ul2;
diff --git a/stat.c b/stat.c
index 332ccd0..442caa0 100644
--- a/stat.c
+++ b/stat.c
@@ -243,15 +243,13 @@ out:
  int calc_lat(struct io_stat *is, unsigned long *min, unsigned long *max,
           double *mean, double *dev)
  {
-    double n = is->samples;
+    double n = (double) is->samples;

-    if (is->samples == 0)
+    if (n == 0)
          return 0;

      *min = is->min_val;
      *max = is->max_val;
-
-    n = (double) is->samples;
      *mean = is->mean.u.f;

      if (n > 1.0)

