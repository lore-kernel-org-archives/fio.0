Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE2E34921A1
	for <fio@vger.kernel.org>; Wed, 21 Jan 2026 13:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769000411; cv=none; b=ftijPcUrizRmraUYx755Z/tqjueXRlvQupx4o+i8+hpjtT3HFBy1ftbQ8+BVwYx6csmmDII/F8IEKF/MjdeqLHi+y+hQOsK9Hr9FfbQsirry7eCKLsBiPxL6j+S9ud0uplrHJBP2tRY2EjO4B79SdmH312xQk90zMAC+RSnxlG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769000411; c=relaxed/simple;
	bh=a/tSBpY3AtwT0l6zkb8HM99ZGkGd0a48DRj6NY2F4Ok=;
	h=Subject:From:To:Date:Message-Id; b=iJiMF7n834e3YYJL3BEw/DfIgshu8Q1STPRgK/b4uPDtTCf0I5BVx7/vZ6kR4ZxxqwU2xiWicn8393t9fi+2LHI05jWUnvLhZIdD29W5GVn0mkJOZUiFBwzWleZ7bjLj3zM5TbBXuk8+ICI0MWYqHb5PNs0/3DEIRqlNBk/rdtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=GuREf+LC; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GuREf+LC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Message-Id:Date:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=ue6Emzz41kib9CTm3OT02eVbsW971tOqBUe101ZJ13g=; b=GuREf+LCCC5ytF3MYLC3QIePNq
	oO9/WVcNpdY/kr8G2puZwuw9+tih6YAyUinDTy2WjuY43AcrLiPzdFKPv/6ZSSt/1Y/uaPUeuXsc+
	hoqfBgFGlTfwBCbjVtW/gNDqPcwfXR/+zHB4cF5fdW38B/EG2QiAZSmzBqkVAbNJi1+S7S/kLojOS
	KmXZpG5zYcQZVXDcXW4z2D8Y2v4FzQiqaTFmajKjnuKq19V6PRE0ttyeHVZSdZLPN/uxb7epYUFz0
	r0NGeBPwRMZZlP+4u54pJgpdM8XaFJoXvn4mmiVOysxjQ4+SyHVvzEUnZT6+TD6hCaOPUMrstjsNB
	fiowkAjw==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1viXoa-0000000GNHa-2B37
	for fio@vger.kernel.org;
	Wed, 21 Jan 2026 13:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 50D881BC0159; Wed, 21 Jan 2026 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Wed, 21 Jan 2026 06:00:01 -0700
Message-Id: <20260121130001.50D881BC0159@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit e2d1cce0f1c5617467f95ac2154212179451ba85:

  test: add test for switching to tausworthe64 (2026-01-15 21:02:38 -0500)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to bfe306e16932382069d4c4de3eb0bae9de1e9b09:

  Fixups for rbd luks support (2026-01-20 12:56:59 -0700)

----------------------------------------------------------------
David Mohren (1):
      engines/rbd: add support for LUKS encryption

Jens Axboe (3):
      Merge branch 'io_uring_zbc_support' of https://github.com/mannanal/fio
      Merge branch 'rbd-encryption-support' of https://github.com/Greenpepper15/fio
      Fixups for rbd luks support

Vishal Jose Mannanal (1):
      Add ZBD (Zoned Block Device) support to io_uring engine

 HOWTO.rst          | 16 ++++++++++
 configure          | 25 ++++++++++++++++
 engines/io_uring.c | 47 +++++++++++++++++++++++++++++
 engines/rbd.c      | 86 ++++++++++++++++++++++++++++++++++++++++++++++++++++--
 fio.1              | 13 +++++++++
 5 files changed, 185 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index b1642cf0..fb607aa4 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -2891,6 +2891,22 @@ with the caveat that when used on the command line, they must come after the
         Touching all objects affects ceph caches and likely impacts test results.
         Enabled by default.
 
+.. option:: rbd_encryption_format=str : [rbd]
+
+		Specifies the encryption format of the RBD image. Supported values are
+		``luks1`` and ``luks2``. If set, :option:`rbd_encryption_passphrase`
+		must also be specified. Note that the image must have been
+		previously formatted using :command:`rbd encryption format <image>`;
+		the fio rbd engine will only attempt to load the encryption
+		context, not format the image. The RBD encryption feature is
+		disabled by default. Support for this feature requires librbd
+		version 16.2 (Ceph Pacific) or later.
+
+.. option:: rbd_encryption_passphrase=str : [rbd]
+
+		The passphrase used to unlock the encrypted RBD image. Required if
+		:option:`rbd_encryption_format` is set.
+
 .. option:: pool=str :
 
    [rbd,rados]
diff --git a/configure b/configure
index 64e58b65..dca87255 100755
--- a/configure
+++ b/configure
@@ -2011,6 +2011,28 @@ fi
 print_config "rbd_invalidate_cache" "$rbd_inval"
 fi
 
+##########################################
+# check for rbd_encryption_load()
+if test "$rbd_encryption" != "yes" ; then
+  rbd_encryption="no"
+fi
+if test "$rbd" = "yes" ; then
+cat > $TMPC << EOF
+#include <rbd/librbd.h>
+
+int main(int argc, char **argv)
+{
+  rbd_image_t image;
+
+  return rbd_encryption_load(image, RBD_ENCRYPTION_FORMAT_LUKS1, 0, 0);
+}
+EOF
+if compile_prog "" "-lrbd -lrados" "rbd_encryption"; then
+    rbd_encryption="yes"
+fi
+  print_config "rbd_encryption_load" "$rbd_encryption"
+fi
+
 ##########################################
 # Check whether we have setvbuf
 if test "$setvbuf" != "yes" ; then
@@ -3221,6 +3243,9 @@ fi
 if test "$rbd_inval" = "yes" ; then
   output_sym "CONFIG_RBD_INVAL"
 fi
+if test "$rbd_encryption" = "yes" ; then
+  output_sym "CONFIG_RBD_ENCRYPTION"
+fi
 if test "$setvbuf" = "yes" ; then
   output_sym "CONFIG_SETVBUF"
 fi
diff --git a/engines/io_uring.c b/engines/io_uring.c
index 6c3eb43c..5c416bc5 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -1883,6 +1883,47 @@ static int fio_ioring_cmd_get_file_size(struct thread_data *td,
 	return generic_get_file_size(td, f);
 }
 
+static int fio_ioring_get_zoned_model(struct thread_data *td,
+				      struct fio_file *f,
+				      enum zbd_zoned_model *model)
+{
+	return blkzoned_get_zoned_model(td, f, model);
+}
+
+static int fio_ioring_report_zones(struct thread_data *td,
+				   struct fio_file *f, uint64_t offset,
+				   struct zbd_zone *zbdz,
+				   unsigned int nr_zones)
+{
+	return blkzoned_report_zones(td, f, offset, zbdz, nr_zones);
+}
+
+static int fio_ioring_reset_wp(struct thread_data *td, struct fio_file *f,
+			       uint64_t offset, uint64_t length)
+{
+	return blkzoned_reset_wp(td, f, offset, length);
+}
+
+static int fio_ioring_get_max_open_zones(struct thread_data *td,
+					 struct fio_file *f,
+					 unsigned int *max_open_zones)
+{
+	return blkzoned_get_max_open_zones(td, f, max_open_zones);
+}
+
+static int fio_ioring_finish_zone(struct thread_data *td, struct fio_file *f,
+				  uint64_t offset, uint64_t length)
+{
+	return blkzoned_finish_zone(td, f, offset, length);
+}
+
+static int fio_ioring_move_zone_wp(struct thread_data *td, struct fio_file *f,
+				   struct zbd_zone *z, uint64_t length,
+				   const char *buf)
+{
+	return blkzoned_move_zone_wp(td, f, z, length, buf);
+}
+
 static int fio_ioring_cmd_get_zoned_model(struct thread_data *td,
 					  struct fio_file *f,
 					  enum zbd_zoned_model *model)
@@ -1954,6 +1995,12 @@ static struct ioengine_ops ioengine_uring = {
 	.open_file		= fio_ioring_open_file,
 	.close_file		= fio_ioring_close_file,
 	.get_file_size		= generic_get_file_size,
+	.get_zoned_model	= fio_ioring_get_zoned_model,
+	.report_zones		= fio_ioring_report_zones,
+	.reset_wp		= fio_ioring_reset_wp,
+	.get_max_open_zones	= fio_ioring_get_max_open_zones,
+	.finish_zone		= fio_ioring_finish_zone,
+	.move_zone_wp		= fio_ioring_move_zone_wp,
 	.options		= options,
 	.option_struct_size	= sizeof(struct ioring_options),
 };
diff --git a/engines/rbd.c b/engines/rbd.c
index 2f25889a..ab4b679b 100644
--- a/engines/rbd.c
+++ b/engines/rbd.c
@@ -40,6 +40,8 @@ struct rbd_options {
 	char *pool_name;
 	char *client_name;
 	int busy_poll;
+	char *encryption_format;
+    char *encryption_passphrase;
 };
 
 static struct fio_option options[] = {
@@ -89,6 +91,24 @@ static struct fio_option options[] = {
 		.category	= FIO_OPT_C_ENGINE,
 		.group		= FIO_OPT_G_RBD,
 	},
+	{
+        .name     = "rbd_encryption_format",
+        .lname    = "RBD Encryption Format",
+        .type     = FIO_OPT_STR_STORE,
+        .off1     = offsetof(struct rbd_options, encryption_format),
+        .help     = "RBD Encryption Format (luks1, luks2)",
+        .category = FIO_OPT_C_ENGINE,
+        .group    = FIO_OPT_G_RBD,
+    },
+    {
+        .name     = "rbd_encryption_passphrase",
+        .lname    = "RBD Encryption Passphrase",
+        .type     = FIO_OPT_STR_STORE,
+        .off1     = offsetof(struct rbd_options, encryption_passphrase),
+        .help     = "Passphrase for unlocking the RBD image",
+        .category = FIO_OPT_C_ENGINE,
+        .group    = FIO_OPT_G_RBD,
+    },
 	{
 		.name = NULL,
 	},
@@ -134,6 +154,65 @@ failed:
 
 }
 
+#ifdef CONFIG_RBD_ENCRYPTION
+static bool _fio_rbd_setup_encryption(struct rbd_data *rbd, struct rbd_options *options)
+{
+	rbd_encryption_format_t fmt;
+	void *opts_ptr = NULL;
+	size_t opts_size = 0;
+	int r;
+
+	rbd_encryption_luks1_format_options_t luks1_opts;
+	rbd_encryption_luks2_format_options_t luks2_opts;
+
+	if (!options->encryption_format)
+		return true; // No encryption requested
+
+	if (!options->encryption_passphrase) {
+		log_err("rbd_encryption_passphrase is required when a rbd_encryption_format is specified.\n");
+		return false;
+	}
+
+	if (!strcmp(options->encryption_format, "luks2")) {
+		fmt = RBD_ENCRYPTION_FORMAT_LUKS2;
+		memset(&luks2_opts, 0, sizeof(luks2_opts));
+		luks2_opts.passphrase = options->encryption_passphrase;
+		luks2_opts.passphrase_size = strlen(options->encryption_passphrase);
+		opts_ptr = &luks2_opts;
+		opts_size = sizeof(luks2_opts);
+	} else if (!strcmp(options->encryption_format, "luks1")) {
+		fmt = RBD_ENCRYPTION_FORMAT_LUKS1;
+		memset(&luks1_opts, 0, sizeof(luks1_opts));
+		luks1_opts.passphrase = options->encryption_passphrase;
+		luks1_opts.passphrase_size = strlen(options->encryption_passphrase);
+		opts_ptr = &luks1_opts;
+		opts_size = sizeof(luks1_opts);
+	} else {
+		log_err("rbd_encryption_load failed. Unknown rbd_encryption_format: %s\n", options->encryption_format);
+		return false;
+	}
+	r = rbd_encryption_load(rbd->image, fmt, opts_ptr, opts_size);
+	if (r < 0) {
+		log_err("rbd_encryption_load failed.\n");
+		return false;
+	}
+	return true;
+}
+#else
+static bool _fio_rbd_setup_encryption(struct rbd_data *rbd, struct rbd_options *options)
+{
+	if (options->encryption_format) {
+		int major, minor, extra;
+        rbd_version(&major, &minor, &extra);
+
+        log_err("rbd encryption requested but not supported by this librbd version (%d.%d.%d).\n",
+                major, minor, extra);
+        return false;
+    }
+	return true;
+}
+#endif
+
 #ifdef CONFIG_RBD_POLL
 static bool _fio_rbd_setup_poll(struct rbd_data *rbd)
 {
@@ -251,12 +330,15 @@ static int _fio_rbd_connect(struct thread_data *td)
 		}
 	}
 
+	if (!_fio_rbd_setup_encryption(rbd, o))
+		goto failed_post_open;
+
 	if (!_fio_rbd_setup_poll(rbd))
-		goto failed_poll;
+		goto failed_post_open;
 
 	return 0;
 
-failed_poll:
+failed_post_open:
 	rbd_close(rbd->image);
 	rbd->image = NULL;
 failed_open:
diff --git a/fio.1 b/fio.1
index 3ee154ed..071ad0e9 100644
--- a/fio.1
+++ b/fio.1
@@ -2637,6 +2637,19 @@ During initialization, touch (create if do not exist) all objects (files).
 Touching all objects affects ceph caches and likely impacts test results.
 Enabled by default.
 .TP
+.BI (rbd)rbd_encryption_format \fR=\fPstr
+Specifies the encryption format of the RBD image. Supported values are
+`luks1' and `luks2'. If set, \fBrbd_encryption_passphrase\fR must
+also be specified. Note that the image must have been previously formatted
+using `rbd encryption format <image>'; the fio rbd engine will only
+attempt to load the encryption context, not format the image.
+The RBD encryption feature is disabled by default.
+Support for this feature requires librbd version 16.2 (Ceph Pacific) or later.
+.TP
+.BI (rbd)rbd_encryption_passphrase \fR=\fPstr
+The passphrase used to unlock the encrypted RBD image. Required if
+\fBrbd_encryption_format\fR is set.
+.TP
 .BI (http)http_host \fR=\fPstr
 Hostname to connect to.  HTTP port 80 is used automatically when the value 
 of the \fBhttps\fP parameter is \fBoff\fP, and HTTPS port 443 if it is \fBon\fP.
