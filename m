Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8880616BE2A
	for <fio@vger.kernel.org>; Thu, 17 Oct 2024 12:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729166414; cv=none; b=PJC6piGNglofnZSJLcyPX2S3/f13EEvWqHmG/xjr/98jn+ficETuS/S/fB3CFli+Y6Ir7KFz4bQLQE6cawvBLRfU6xsKhTP3V9573JO503Fpmgi6/gqRawXBseTw2GNbXM6ZpucTfpRkomrUMDhXzMHum50FsYZ+r1NUio0C2Ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729166414; c=relaxed/simple;
	bh=PXIICiAuKeDLjSY5btqf6maw1/ms0nFK90IU9qWhljw=;
	h=Subject:From:To:Message-Id:Date; b=AIUUtT1kgOsc04Okkevb5m40YCw0re1t2M9ata9QnCvX8N3Jtvj64mYy/9EOw6xWRXXbZOXxrWUN7W83bukzhnU9nrqTH+0hdC/OVOliVwcBbCHsnzRjkBDFETn5pc3vse7GAydADfVzMUUeTHQ/h48Wy4oMsMmoMiFSRkL4gJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=vwMGnqyl; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vwMGnqyl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=lwuEx0ot+E2CqbBhp6c3vTlDCFSA+7u/YcK9kHYAm1o=; b=vwMGnqyly49HBHp1svjS4egb4N
	H75iYKuZgs6SP4ZzWl2rqo82dAJ2kJl/21OKO3TPvSXC9c//WxHhnxENs1bh1IIHC1EAoOfoYUbWI
	QGag7ELbTZlELE3af1ErwpPB8xM299fJ/DlEOD/yEgSPginsos5fL4JlNEM8U6nls11P6hw96JuHz
	Acs40Zg8CXj0EpPk/AX7geyJq3QQCRanVbu9PpGZfjiuNZrk8WijbwgeCtyEkvH8cdJVPs3MnIs1y
	zRkfSql0bRWzuxmOFw0J49h20c3gwam5OXQXk9od4AwCT/+BFJDsR6oJs73qPbM/cCecDWkPFw3mk
	5lu1rzXw==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1t1PAl-0000000AyA7-2D8T
	for fio@vger.kernel.org;
	Thu, 17 Oct 2024 12:00:08 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id E8C851BC0133; Thu, 17 Oct 2024 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20241017120001.E8C851BC0133@kernel.dk>
Date: Thu, 17 Oct 2024 06:00:01 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit cd56c0af6f3e1ec3cad49ab0d0c002f2c7de3f90:

  docs: mention unsupported configuration (2024-10-03 20:39:38 +0000)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 86fc77aa2745882398619cf4d5b5b2d208f69ec4:

  ci: always update apt cache before installing pkgs (2024-10-15 11:29:18 -0400)

----------------------------------------------------------------
Vincent Fu (1):
      ci: always update apt cache before installing pkgs

 .github/actions/build-qemu/action.yml         | 2 +-
 .github/actions/create-guest-image/action.yml | 2 +-
 .github/actions/start-vm/action.yml           | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

---

Diff of recent changes:

diff --git a/.github/actions/build-qemu/action.yml b/.github/actions/build-qemu/action.yml
index 06804b8b..279a8ed7 100644
--- a/.github/actions/build-qemu/action.yml
+++ b/.github/actions/build-qemu/action.yml
@@ -12,7 +12,7 @@ runs:
   using: "composite"
   steps:
     - name: Install QEMU build dependencies
-      run: sudo apt-get -qq install libglib2.0-dev libfdt-dev libpixman-1-dev ninja-build flex bison libsdl2-dev libaio-dev python3-tomli libslirp-dev
+      run: sudo apt update && sudo apt-get -qq install libglib2.0-dev libfdt-dev libpixman-1-dev ninja-build flex bison libsdl2-dev libaio-dev python3-tomli libslirp-dev
       shell: bash
 
     - name: Build and install QEMU
diff --git a/.github/actions/create-guest-image/action.yml b/.github/actions/create-guest-image/action.yml
index ce413378..77be3a3c 100644
--- a/.github/actions/create-guest-image/action.yml
+++ b/.github/actions/create-guest-image/action.yml
@@ -15,7 +15,7 @@ runs:
   using: "composite"
   steps:
     - name: Install libguestfs
-      run: sudo apt-get -qq install libguestfs-tools
+      run: sudo apt update && sudo apt-get -qq install libguestfs-tools
       shell: bash
     - name: Setup steps for virt-builder
       run: |
diff --git a/.github/actions/start-vm/action.yml b/.github/actions/start-vm/action.yml
index d47977c4..3449aac5 100644
--- a/.github/actions/start-vm/action.yml
+++ b/.github/actions/start-vm/action.yml
@@ -24,7 +24,7 @@ runs:
   steps:
     - name: install wait-for-it
       shell: bash
-      run: sudo apt-get -qq install wait-for-it
+      run: sudo apt update && sudo apt-get -qq install wait-for-it
     - name: Start VM in background
       shell: bash
       run: |
