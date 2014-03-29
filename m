Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:51691 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417AbaC2MAF (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 29 Mar 2014 08:00:05 -0400
Received: from kernel.dk ([54.225.238.116] helo=strynoevaenget.dk)
	by merlin.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1WTrvg-0006Yh-8w
	for fio@vger.kernel.org; Sat, 29 Mar 2014 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20140329120003.72E9740099@strynoevaenget.dk>
Date: Sat, 29 Mar 2014 06:00:03 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 43cdea1d0d62fe57c0b1017c55b4700cd95f63b0:

  server: unlink sock file if interrupted early (2014-03-25 15:06:17 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 9f973d1322fe387bc9b4442a23a912cfbc2203b9:

  Merge branch 'master' of ssh://git.kernel.dk/data/git/fio (2014-03-28 08:09:35 -0600)

----------------------------------------------------------------

Jens Axboe (2):
      Fix wrong time conversion on --status-interval= command line option
      Merge branch 'master' of ssh://git.kernel.dk/data/git/fio

 init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/init.c b/init.c
index 9b0666d..adb9066 100644
--- a/init.c
+++ b/init.c
@@ -1938,7 +1938,7 @@ int parse_cmd_line(int argc, char *argv[], int client_type)
 		case 'L': {
 			long long val;
 
-			if (check_str_time(optarg, &val, 1)) {
+			if (check_str_time(optarg, &val, 0)) {
 				log_err("fio: failed parsing time %s\n", optarg);
 				do_exit++;
 				exit_val = 1;
