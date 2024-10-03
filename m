Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11FE7146A73
	for <fio@vger.kernel.org>; Thu,  3 Oct 2024 12:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727956815; cv=none; b=Xk3pptjVZDKaJy3Xt1y+hR9wv12w666zF5h9mqHqUsPTaG3bD7GswwMlLCuxW/3uTHYcdiFhIFivO6KOnSXqylMttuvQ/I4+FFonR6d1Ds3Go15r4dr/wM/Fddflr1QroNox0H0cQyqhh5fBZGVXp29jMJ3cRkXYaJN5jtvF2TU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727956815; c=relaxed/simple;
	bh=zX+f+FEwpgVECZEwLH+71okffjgbAoc8HjX77a0sCVY=;
	h=Subject:From:To:Message-Id:Date; b=d5m1xmozm6/dzzvUJ100P7gN32WzOtcPIazaKVjn974uJKl7nqynTiacCgPlUBSBirYOFRg3iK/9om+dY6zUZOATaHEN2NglBXJNm1j+a+zGFZOsMQUt2NHfSKwzbLqtHt0orSuUJYezQ/fWnoSO4trj6t3eWlSeFv7y4Ev8GNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=RAFLJSq0; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RAFLJSq0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=oPUWcWJKciDEK/6VJj9d7cirrG+txvz5pmhv7futMKI=; b=RAFLJSq0p3l6/domk8yUunS6VT
	OokJ3w4XsxBQj27ncF3CI1E2WpG739AlbG64lSDm0eUDpKdpJDOFk4vsR6ewLzTsZPuj+/5ZTUMag
	RhsqyRKxKX8ZerX7YlwoE+9Ob624UHFNKp7PVPlD1YvXXJo9jOSJFft7SYjYxf7Z4XdADGgchUbRH
	zVWtzCfUDW4LFJNkJT7Tpij66ZpKTGaJ5r4C1j1Hgn4IvTbXAXQmwepTajjkF4CTRaMnX7aUKQL/x
	eI3XIrBKdbAhH5EGkoYpX4/cwv+bOdNM3K90yfes/qjE9g8pJB7xFU5mz9KosuaSCMmnGbdoKeGFq
	GjRjlvVw==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1swKV7-00000003gD8-2S7K
	for fio@vger.kernel.org;
	Thu, 03 Oct 2024 12:00:10 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 55DA01BC0154; Thu,  3 Oct 2024 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20241003120002.55DA01BC0154@kernel.dk>
Date: Thu,  3 Oct 2024 06:00:02 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 980fb7f2d9981bbfe4a3158d6293308c76a6d77a:

  engines/io_uring: add support for async TRIM (2024-09-30 09:47:18 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 92245726b7f608a7e6e294222e68821b4dcc38ea:

  docs: addtions to client/server section (2024-10-02 17:15:40 -0400)

----------------------------------------------------------------
Jens Axboe (1):
      Fio 3.38

Vincent Fu (2):
      ci/qemu: use a tarball to xfer source code to guest
      docs: addtions to client/server section

 .github/workflows/qemu.yml | 13 +++++++++----
 FIO-VERSION-GEN            |  2 +-
 HOWTO.rst                  |  5 +++++
 fio.1                      |  5 +++++
 4 files changed, 20 insertions(+), 5 deletions(-)

---

Diff of recent changes:

diff --git a/.github/workflows/qemu.yml b/.github/workflows/qemu.yml
index f987b33c..db71fbe8 100644
--- a/.github/workflows/qemu.yml
+++ b/.github/workflows/qemu.yml
@@ -57,6 +57,7 @@ jobs:
     env:
       DISTRO: debian-12
       SSHCMD: ssh root@localhost -p 2022
+      SCPCMD: scp -P 2022
       CI_TARGET_BUILD: linux
       CI_TARGET_OS: debian
 
@@ -64,6 +65,11 @@ jobs:
     - name: Check out repository
       uses: actions/checkout@v4
 
+    - name: Create tarball containing repository
+      run: |
+        git archive --format=tar.gz -o fio-src.tar.gz --prefix=fio/ HEAD
+        git log -1
+
     - name: Create guest VM image
       uses: ./.github/actions/create-guest-image
       with:
@@ -83,11 +89,10 @@ jobs:
         host_key: true
         options: ${{ matrix.device }}
 
-    - name: Clone fio on guest
+    - name: Transfer fio source to guest
       run: |
-          $SSHCMD "apt-get update && apt-get install -qq git"
-          $SSHCMD "git clone https://github.com/taiki-e/checkout-action --branch v1.3.0"
-          $SSHCMD "mkdir fio && cd fio && ../checkout-action/main.sh && git log -1"
+          $SCPCMD fio-src.tar.gz root@localhost:/root/
+          $SSHCMD "tar xzf fio-src.tar.gz"
 
     - name: Install dependencies on guest
       run: $SSHCMD "cd fio && ./ci/actions-install.sh"
diff --git a/FIO-VERSION-GEN b/FIO-VERSION-GEN
index be0d7620..2393f394 100755
--- a/FIO-VERSION-GEN
+++ b/FIO-VERSION-GEN
@@ -1,7 +1,7 @@
 #!/bin/sh
 
 GVF=FIO-VERSION-FILE
-DEF_VER=fio-3.37
+DEF_VER=fio-3.38
 
 LF='
 '
diff --git a/HOWTO.rst b/HOWTO.rst
index 539bce19..ac59ddcd 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -5385,5 +5385,10 @@ containing two hostnames ``h1`` and ``h2`` with IP addresses 192.168.10.120 and
 	/mnt/nfs/fio/192.168.10.120.fileio.tmp
 	/mnt/nfs/fio/192.168.10.121.fileio.tmp
 
+This behavior can be disabled by the :option:`unique_filename` option.
+
 Terse output in client/server mode will differ slightly from what is produced
 when fio is run in stand-alone mode. See the terse output section for details.
+
+Also, if one fio invocation runs workloads on multiple servers, fio will
+provide at the end an aggregate summary report for all workloads.
diff --git a/fio.1 b/fio.1
index 356980b5..cce80894 100644
--- a/fio.1
+++ b/fio.1
@@ -5142,8 +5142,13 @@ containing two hostnames `h1' and `h2' with IP addresses 192.168.10.120 and
 .PD
 .RE
 .P
+This behavior can be disabled by the \fBunique_filename\fR option.
+.P
 Terse output in client/server mode will differ slightly from what is produced
 when fio is run in stand-alone mode. See the terse output section for details.
+.P
+Also, if one fio invocation runs workloads on multiple servers, fio will
+provide at the end an aggregate summary report for all workloads.
 .SH AUTHORS
 .B fio
 was written by Jens Axboe <axboe@kernel.dk>.
