Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9009F125A0
	for <fio@vger.kernel.org>; Wed,  1 Nov 2023 12:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RGoqelaS"
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3301BFD
	for <fio@vger.kernel.org>; Wed,  1 Nov 2023 05:00:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=q/F3rFieDIIQZ8TGzW3iygAUz2ufc7bbZDgPW0lEt60=; b=RGoqelaSrBFe+9pDWUd7CRU1j+
	k/WpArqRO64GHG6Ui8yGQf8IeR/hfnIP7SvV67z2EthjnD7K52tR0FMuLdiudGXAQrS7TwG9drsNS
	DA4NW4c6v9mC67GPYnbklqI3yDLnpGRWc7oxJ6fcsm/ZnwXMS3BXXKWXkylK2wij+x8DZky/jt7mb
	us9tCeq2NLx1hxes9cMvaRIPY6x3Cs0cQQiUCpiDGpWQmtG5C17YX4CH36qaCfouSpKzVTr8tpJdi
	r9D4yFGD4P7WoM+C68pIggb0VcNMfTJ3rNVgSWyOjOpasAv5Ay52dH5mFYXso7bKV7Yi8+opxdgAu
	tK62AJhg==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1qy9tK-00FvlX-Jk
	for fio@vger.kernel.org; Wed, 01 Nov 2023 12:00:10 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 3B1FC1BC0175; Wed,  1 Nov 2023 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20231101120002.3B1FC1BC0175@kernel.dk>
Date: Wed,  1 Nov 2023 06:00:02 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 7a725c78547f7337dddb6fd391f80914f671e583:

  Merge branch 'englist' of https://github.com/vt-alt/fio (2023-10-25 17:53:40 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 95f4d3f054464e997ae1067dc7f4f8ec3f896ccc:

  Merge branch 'pi-perf' of https://github.com/ankit-sam/fio (2023-10-31 09:27:15 -0600)

----------------------------------------------------------------
Ankit Kumar (1):
      crct10: use isa-l for crc if available

Jens Axboe (1):
      Merge branch 'pi-perf' of https://github.com/ankit-sam/fio

 HOWTO.rst              |  4 ++++
 configure              | 29 +++++++++++++++++++++++++++++
 crc/crct10dif_common.c | 13 +++++++++++++
 fio.1                  |  4 ++++
 4 files changed, 50 insertions(+)

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index 6a8fb3e3..34d6afdf 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -2507,6 +2507,10 @@ with the caveat that when used on the command line, they must come after the
 	If this is set to 0, fio generates protection information for
 	write case and verifies for read case. Default: 1.
 
+	For 16 bit CRC generation fio will use isa-l if available otherwise
+	it will use the default slower generator.
+	(see: https://github.com/intel/isa-l)
+
 .. option:: pi_chk=str[,str][,str] : [io_uring_cmd]
 
 	Controls the protection information check. This can take one or more
diff --git a/configure b/configure
index 3e3f8132..420d97db 100755
--- a/configure
+++ b/configure
@@ -189,6 +189,7 @@ libiscsi="no"
 libnbd="no"
 libnfs=""
 xnvme=""
+isal=""
 libblkio=""
 libzbc=""
 dfs=""
@@ -262,6 +263,8 @@ for opt do
   ;;
   --disable-xnvme) xnvme="no"
   ;;
+  --disable-isal) isal="no"
+  ;;
   --disable-libblkio) libblkio="no"
   ;;
   --disable-tcmalloc) disable_tcmalloc="yes"
@@ -322,6 +325,7 @@ if test "$show_help" = "yes" ; then
   echo "--enable-libiscsi       Enable iscsi support"
   echo "--enable-libnbd         Enable libnbd (NBD engine) support"
   echo "--disable-xnvme         Disable xnvme support even if found"
+  echo "--disable-isal          Disable isal support even if found"
   echo "--disable-libblkio      Disable libblkio support even if found"
   echo "--disable-libzbc        Disable libzbc even if found"
   echo "--disable-tcmalloc      Disable tcmalloc support"
@@ -2684,6 +2688,28 @@ if test "$xnvme" != "no" ; then
 fi
 print_config "xnvme engine" "$xnvme"
 
+if test "$targetos" = "Linux" ; then
+##########################################
+# Check ISA-L support
+cat > $TMPC << EOF
+#include <isa-l/crc.h>
+#include <stddef.h>
+int main(void)
+{
+  return crc16_t10dif(0, NULL, 4096);
+}
+EOF
+if test "$isal" != "no" ; then
+  if compile_prog "" "-lisal" "ISAL"; then
+    isal="yes"
+    LIBS="-lisal $LIBS"
+  else
+    isal="no"
+  fi
+fi
+print_config "isal" "$isal"
+fi
+
 ##########################################
 # Check if we have libblkio
 if test "$libblkio" != "no" ; then
@@ -3334,6 +3360,9 @@ if test "$xnvme" = "yes" ; then
   echo "LIBXNVME_CFLAGS=$xnvme_cflags" >> $config_host_mak
   echo "LIBXNVME_LIBS=$xnvme_libs" >> $config_host_mak
 fi
+if test "$isal" = "yes" ; then
+  output_sym "CONFIG_LIBISAL"
+fi
 if test "$libblkio" = "yes" ; then
   output_sym "CONFIG_LIBBLKIO"
   echo "LIBBLKIO_CFLAGS=$libblkio_cflags" >> $config_host_mak
diff --git a/crc/crct10dif_common.c b/crc/crct10dif_common.c
index cfb2a1b1..1763b1c6 100644
--- a/crc/crct10dif_common.c
+++ b/crc/crct10dif_common.c
@@ -24,6 +24,17 @@
  *
  */
 
+#ifdef CONFIG_LIBISAL
+#include <isa-l/crc.h>
+
+extern unsigned short fio_crc_t10dif(unsigned short crc,
+				     const unsigned char *buffer,
+				     unsigned int len)
+{
+	return crc16_t10dif(crc, buffer, len);
+}
+
+#else
 #include "crc-t10dif.h"
 
 /* Table generated using the following polynomium:
@@ -76,3 +87,5 @@ extern unsigned short fio_crc_t10dif(unsigned short crc,
 
 	return crc;
 }
+
+#endif
diff --git a/fio.1 b/fio.1
index a8dc8f6c..c4742aa9 100644
--- a/fio.1
+++ b/fio.1
@@ -2263,6 +2263,10 @@ size greater than protection information size, fio will not generate or verify
 the protection information portion of metadata for write or read case
 respectively. If this is set to 0, fio generates protection information for
 write case and verifies for read case. Default: 1.
+
+For 16 bit CRC generation fio will use isa-l if available otherwise it will
+use the default slower generator.
+(see: https://github.com/intel/isa-l)
 .TP
 .BI (io_uring_cmd)pi_chk \fR=\fPstr[,str][,str]
 Controls the protection information check. This can take one or more of these
