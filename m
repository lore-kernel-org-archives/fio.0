Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E28A40DB29
	for <fio@vger.kernel.org>; Fri, 24 Jul 2026 12:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784894419; cv=none; b=WpUvqDMUJCkwA3tAEgDTf80uOGS+gMXQZlFx4qJR+GaCB/AV9ZmsK53Dv9E2PaT48NhH1SZxmPSDvatxMhNxxDnwEMfeW5v/Cadfa5Qgy+CFDP8fsXNoGp/lR7Je8c3gF1Bro6lQDYdIW4/YiDL5AmKmQ+GqlSgn0XiiZ0PUf6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784894419; c=relaxed/simple;
	bh=Rt9fl99Pvv4SHMu/vKlDbv+tddlH62LZ5ckX+pMGDcs=;
	h=Subject:From:To:Date:Message-Id; b=cn6T613QZcTWKBb93lKk+a00q+ZYmpmsfvOh9cLRNnoQnSxmxjQBU0/VYMTUiNXttri+xFVR1QJzHrmNlnRGkk2UC6IydTSYXbqKne2B2DfWvePM9vRtuBI6zKDRTW902ansashaxvWaC2m6RIUeaJsNTr/Gukq/b4pMie/s+Y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=BJ2pDmbN; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BJ2pDmbN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Message-Id:Date:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=9VKa6QRvTZAfn6LV00l+i+KNxble0V4iA/IeN/ogunY=; b=BJ2pDmbNThPjnr8LDRLwzAzvrA
	knEhE0joL6lxYdBLYuQaEQnwe5hTdk5eJ1WYubXkyzn4lmrA+wrexRW3OqRuSWOr6w1akFz0/Fo/8
	ELlRdvbwBLInG0+A/Vh9XqtB/wVbRjrLOQrVNraKQpkwPngyvGbd1D3hXFzgSO7QfjVNamMWlrBUr
	zsnTnH6nGlZrrZIntiyiTxZbxTn42pe7a+uEaPRw1ywle3xytagWT3VCaS0hLA6AjVUaznkz5+V3x
	2akhLjH21rN7EwXvyPbK8y6hmJtt4bCZ3d1LqI/QcQn7DP1nWiMeX1FQsBNRS+y6Sp8gVJIU7jtAw
	DD4EQ4GQ==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.99.2 #2 (Red Hat Linux))
	id 1wnEZT-00000002Wec-3vuf
	for fio@vger.kernel.org;
	Fri, 24 Jul 2026 12:00:08 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id E75651BC0161; Fri, 24 Jul 2026 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Fri, 24 Jul 2026 06:00:01 -0600
Message-Id: <20260724120001.E75651BC0161@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit aa079a649f6df4fbda67fe612e74b0c34cea6dea:

  ci: consolidate QEMU FDP and verify-trim tests (2026-07-22 12:34:16 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to b384f4d3472e9dae62122c631899bac86368df63:

  ci: add Alpine Linux container test platform (2026-07-23 14:28:28 -0400)

----------------------------------------------------------------
Vincent Fu (1):
      ci: add Alpine Linux container test platform

 .github/workflows/ci.yml | 4 ++++
 ci/actions-install.sh    | 4 ++++
 2 files changed, 8 insertions(+)

---

Diff of recent changes:

diff --git a/.github/workflows/ci.yml b/.github/workflows/ci.yml
index 27ea58fb..314a00a9 100644
--- a/.github/workflows/ci.yml
+++ b/.github/workflows/ci.yml
@@ -18,6 +18,7 @@ jobs:
         - {os: 'alma', dh: 'almalinux', ver: '10', target_arch: 'x86_64'}
         - {os: 'oracle', dh: 'oraclelinux', ver: '10', target_arch: 'x86_64'}
         - {os: 'rocky', dh: 'rockylinux/rockylinux', ver: '10', target_arch: 'x86_64'}
+        - {os: 'alpine', dh: 'alpine', ver: 'latest', target_arch: 'x86_64'}
 
     container:
       image: ${{ matrix.container.dh }}:${{ matrix.container.ver }}
@@ -30,6 +31,9 @@ jobs:
     steps:
     - name: Checkout repo
       uses: actions/checkout@v6
+    - name: Install bash on Alpine
+      if: ${{ contains( matrix.container.os, 'alpine' ) }}
+      run: apk add bash
     - name: Install dependencies
       run:  ./ci/actions-install.sh
     - name: Build
diff --git a/ci/actions-install.sh b/ci/actions-install.sh
index 41ab8439..bf2acbe9 100755
--- a/ci/actions-install.sh
+++ b/ci/actions-install.sh
@@ -191,6 +191,10 @@ install_linux() {
     install_ubuntu
 }
 
+install_alpine() {
+	apk add git build-base pkgconf zlib-dev numactl-dev cunit-dev libaio-dev linux-headers python3 py3-statsmodels py3-six bash coreutils py3-sphinx
+}
+
 install_macos() {
     # Assumes homebrew and python3 are already installed
     #echo "Updating homebrew..."
