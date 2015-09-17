Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43701 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951AbbIQMAD (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 17 Sep 2015 08:00:03 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1ZcXr9-0002Vd-Hv
	for fio@vger.kernel.org; Thu, 17 Sep 2015 12:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150917120001.B5C502C225F@kernel.dk>
Date: Thu, 17 Sep 2015 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 93b35789c2183f3bb0e7e825815fa7622e61f21f:

  Fio 2.2.10 (2015-09-11 15:13:37 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 5193b4e5000e7a11bd86ad2661f750e4e2a11fe0:

  Merge branch 'patch-1' of git://github.com/Tfindelkind/fio (2015-09-16 15:43:28 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'patch-1' of git://github.com/Tfindelkind/fio

Stephen Bates (1):
      Reduced minimum for option log_gz

Tfindelkind (1):
      Update fio2gnuplot

 options.c              | 2 +-
 tools/plot/fio2gnuplot | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/options.c b/options.c
index 4798fbf..1868dfd 100644
--- a/options.c
+++ b/options.c
@@ -3177,7 +3177,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.type	= FIO_OPT_INT,
 		.off1	= td_var_offset(log_gz),
 		.help	= "Log in compressed chunks of this size",
-		.minval	= 32 * 1024 * 1024ULL,
+		.minval	= 1024ULL,
 		.maxval	= 512 * 1024 * 1024ULL,
 		.category = FIO_OPT_C_LOG,
 		.group	= FIO_OPT_G_INVALID,
diff --git a/tools/plot/fio2gnuplot b/tools/plot/fio2gnuplot
index 2d64a6e..1aef047 100755
--- a/tools/plot/fio2gnuplot
+++ b/tools/plot/fio2gnuplot
@@ -488,6 +488,8 @@ def main(argv):
 	    # Insure that we don't have any starting or trailing dash to the filename
 	    gnuplot_output_filename = gnuplot_output_filename[:-1] if gnuplot_output_filename.endswith('-') else gnuplot_output_filename
 	    gnuplot_output_filename = gnuplot_output_filename[1:] if gnuplot_output_filename.startswith('-') else gnuplot_output_filename
+	    if (gnuplot_output_filename == ''):
+            	gnuplot_output_filename='default'	
 
     if parse_global==True:
 	parse_global_files(fio_data_file, global_search)
