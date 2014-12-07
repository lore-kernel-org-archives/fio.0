Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:44165 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752780AbaLGNAH (ORCPT <rfc822;fio@vger.kernel.org>);
	Sun, 7 Dec 2014 08:00:07 -0500
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1XxbRV-0001rt-7D
	for fio@vger.kernel.org; Sun, 07 Dec 2014 13:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20141207130002.AC53C400D1@lyth.info>
Date: Sun,  7 Dec 2014 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 74a92cdd178ac5434d2bbbc1649fe66ff341c1d0:

  lib/rand: cleanup __fill_random_buffer() (2014-12-05 11:04:19 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to f8b8f7da1f64353ebc1dfa47de3b7ff1e8cca303:

  Update date and email in man page (2014-12-06 18:47:43 -0700)

----------------------------------------------------------------
Jens Axboe (3):
      options: show closest match for unknown job option
      options: strip off =optval when matching
      Update date and email in man page

 fio.1     |    4 ++--
 options.c |   39 +++++++++++++++++++++++++++++++++++++--
 2 files changed, 39 insertions(+), 4 deletions(-)

---

Diff of recent changes:

diff --git a/fio.1 b/fio.1
index c3193a2..0e66206 100644
--- a/fio.1
+++ b/fio.1
@@ -1,4 +1,4 @@
-.TH fio 1 "October 2013" "User Manual"
+.TH fio 1 "December 2014" "User Manual"
 .SH NAME
 fio \- flexible I/O tester
 .SH SYNOPSIS
@@ -1873,7 +1873,7 @@ of being passed one from the client.
 
 .B fio
 was written by Jens Axboe <jens.axboe@oracle.com>,
-now Jens Axboe <jaxboe@fusionio.com>.
+now Jens Axboe <axboe@fb.com>.
 .br
 This man page was written by Aaron Carroll <aaronc@cse.unsw.edu.au> based
 on documentation by Jens Axboe.
diff --git a/options.c b/options.c
index c3c6292..2c703fd 100644
--- a/options.c
+++ b/options.c
@@ -3933,6 +3933,39 @@ static char **dup_and_sub_options(char **opts, int num_opts)
 	return opts_copy;
 }
 
+static void show_closest_option(const char *opt)
+{
+	int best_option, best_distance;
+	int i, distance;
+	char *name;
+
+	if (!strlen(opt))
+		return;
+
+	name = strdup(opt);
+	i = 0;
+	while (name[i] != '\0' && name[i] != '=')
+		i++;
+	name[i] = '\0';
+
+	best_option = -1;
+	best_distance = INT_MAX;
+	i = 0;
+	while (fio_options[i].name) {
+		distance = string_distance(name, fio_options[i].name);
+		if (distance < best_distance) {
+			best_distance = distance;
+			best_option = i;
+		}
+		i++;
+	}
+
+	if (best_option != -1)
+		log_err("Did you mean %s?\n", fio_options[best_option].name);
+
+	free(name);
+}
+
 int fio_options_parse(struct thread_data *td, char **opts, int num_opts,
 			int dump_cmdline)
 {
@@ -3968,6 +4001,7 @@ int fio_options_parse(struct thread_data *td, char **opts, int num_opts,
 		for (i = 0; i < num_opts; i++) {
 			struct fio_option *o = NULL;
 			int newret = 1;
+
 			if (!opts_copy[i])
 				continue;
 
@@ -3977,9 +4011,10 @@ int fio_options_parse(struct thread_data *td, char **opts, int num_opts,
 						      td->eo, dump_cmdline);
 
 			ret |= newret;
-			if (!o)
+			if (!o) {
 				log_err("Bad option <%s>\n", opts[i]);
-
+				show_closest_option(opts[i]);
+			}
 			free(opts_copy[i]);
 			opts_copy[i] = NULL;
 		}
