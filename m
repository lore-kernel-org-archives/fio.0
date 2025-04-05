Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 130F21E1DFB
	for <fio@vger.kernel.org>; Sat,  5 Apr 2025 12:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743854411; cv=none; b=u8fhmtZxRQIOcToHD1wOkjyYK1EElAK8598v3tTowJKkc2l6jCL1XTel699jkryCJdZP8uinSu/2xdxRMybshGLLgGRNnvAXbHxPGOFYoeIneVmJ9MK5boc6xxQUC0eBEjUxPdxjiiIfqnj0pY14LjF8fuq8Xhz2hd78xJFo/tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743854411; c=relaxed/simple;
	bh=4hbBslb6xyM2O0TtONElEl5HgucHZpGX+0hEi/1XfRc=;
	h=Subject:From:To:Message-Id:Date; b=uHOhFG7NYoHxu9Ly3WKbeo0OboAU95n0Tw7d+FVhYryhm1E08WwXhvNohPxehCteAAB1guo8x6FpCBMqdKylgBvN7OvyxIW7T0aNzaX5vHFc7cexhp3HAr4p8xW6Thrk+QQo2vn+gQzEvUouED0S/JcqxX5fJFHXX1tkuvxrj0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=HPOrmfmn; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HPOrmfmn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=i9cWkON5GzDMMkUIvs1TeYO/rqOXIP2lHQUHsoNncLQ=; b=HPOrmfmn1kGyXcn7h2uUymz+HO
	RenvWIgd1T7cvaI8Hnv1111ISvTPvCV+fFO6uBnP4aqBD3I0iXT47VJUE8HlqUc8X78Zp6BsYyIUt
	BbKywUvrKjhNcEpC5UlDSrwQ7HSGdWaxixD0BU74+On04Dhu5EesXAFNCl2tIzMxCoT1y5DIgGm9/
	yRRb3rxJZ3Waa+wAWGC1RoJryKKRKuSWpkvBV79188Z8Yd0XId6NJ7a6J+aK+kngeEF59sM8LNFhg
	NXYeVDKYgzVIdBJefrUCjU/QVexqm8oMde3BZqFAOW/hiLrKnPiGCQjTbbdXsCLXeF0525v+0gg1P
	yZd//c7w==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.98.1 #2 (Red Hat Linux))
	id 1u12Bw-00000007YBk-3iz1
	for fio@vger.kernel.org;
	Sat, 05 Apr 2025 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id B08E51BC0152; Sat,  5 Apr 2025 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20250405120001.B08E51BC0152@kernel.dk>
Date: Sat,  5 Apr 2025 06:00:01 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 58818df7b0948d36ba9743160a1f570700d2347d:

  Merge branch 'iouring-spellingfix-2025-03-18' of https://github.com/proact-de/fio (2025-03-18 07:14:24 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to c283fe11bda9efde7f063e6fe693802724ddc8c0:

  ci: set kvm permissions for GHA QEMU jobs (2025-04-04 11:27:27 -0400)

----------------------------------------------------------------
Vincent Fu (1):
      ci: set kvm permissions for GHA QEMU jobs

 .github/actions/start-vm/action.yml | 6 ++++++
 1 file changed, 6 insertions(+)

---

Diff of recent changes:

diff --git a/.github/actions/start-vm/action.yml b/.github/actions/start-vm/action.yml
index 3449aac5..ab13aa09 100644
--- a/.github/actions/start-vm/action.yml
+++ b/.github/actions/start-vm/action.yml
@@ -25,6 +25,12 @@ runs:
     - name: install wait-for-it
       shell: bash
       run: sudo apt update && sudo apt-get -qq install wait-for-it
+    - name: Enable KVM group perms
+      shell: bash
+      run: |
+        echo 'KERNEL=="kvm", GROUP="kvm", MODE="0666", OPTIONS+="static_node=kvm"' | sudo tee /etc/udev/rules.d/99-kvm4all.rules
+        sudo udevadm control --reload-rules
+        sudo udevadm trigger --name-match=kvm
     - name: Start VM in background
       shell: bash
       run: |
