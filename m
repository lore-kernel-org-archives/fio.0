Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=90.155.50.34
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793361615;
	b=YI2abEz605SueHOHNGYPoik8icnyykyQJeWFzDK/HT88i0ll5ntbXc22kwNPh5CgicwB
	 ZqqCfguog4iQyvzJsvv6nYQItdvyfwVbTT1HyXL9RCKMy1A4LsHhGJgFKrQipVveSPHqH
	 nspV5ZSD+JQnp7ybPkhzpQeQ+1VIa0d3KyuIJmgcHpv4Wp1sHTLitaX7GsF0c8MCBg3PD
	 DwlCCMA36ws5Twfh6g3LmR79fXhQWuEjohgb2IpIkvwIUUfJ8jpH5YT6noX9rJ8iyEVbU
	 dzMAvza8Oy2YYkdvToZZsIq8ghYN6y7SWbwi10ifDr0Nvfdb5o2HkZdj29wepmg30Cg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793361615;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Subject:From:To:
	 User-Agent:Date:Message-Id;
	bh=UQRm1V24Z0CmVrkxE/Bq6YTBNthrjCugvUqnZDjuwDo=;
	b=KrtoHzXFrL+PelJyT/yc1el3/mVHQA5pZY6nSi43nQwzz1r22SREh4jMCLNlSMvHHYON
	 4M+PzGMhpFh5HaOWCAa7Oq74f03LU7T+Gg2l0tn+FvXIb17nsgvmR7Ce3PoHFWhL+tqlA
	 +Y+thozJLcdpZ9b+cHCm9ciJnhqYxlS/bLcU9Ue0zbpOn3FgBu1yRBvamgSUp6M+uyU8v
	 K/6TYgXlKzgqqpoWx6H+QGM9lZoHIprxzl6LNByai/WyrcV35xtRta8Jy29PDxeEGBeoP
	 D2qvp9YWs5EUymQV7vsUVT5KLj290mA8czgvpi8Fw+IVFEQ59Q9CYWG3T5cwwISFutg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=kernel.dk;
	spf=fail smtp.mailfrom=kernel.dk;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=kfQ5V70O;
	arc=none smtp.remote-ip=90.155.50.34
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F1B4606A31C
	for <fio@vger.kernel.org>; Fri, 30 Oct 2026 12:00:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1F1B4606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=kfQ5V70O
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Message-Id:Date:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=UQRm1V24Z0CmVrkxE/Bq6YTBNthrjCugvUqnZDjuwDo=; b=kfQ5V70Oa6IP2DfA4DMdh4VCnz
	44nb/wvWlE4RTUfNJTDd+8SEqmkPqSLVq732CXa4zXtn5Mg4OZ7bx4ToSK8TgXmZUQokCaU83tkD+
	PQjiO1x2Tv8UlfHTsywMLAdQeJmVLRDuQRBj1xHDjZOGwikQQs/DM05gFyaHSjkVWjIyu06fER7op
	XH2agrkQKEHtlv09y/K/ijFCZULHYtQDJAfQSrZVBckku2mQGMAYff3ZhMNk5aLH7WxANKYspD8bA
	u8JMJowl+yBOWKgLmM+8W+6u/p0/cUezK0+9jHpH4nyGlij9o9V+s06xbTiyWW+KM/pvxsqW88VlL
	8hi/KTUw==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xMlHA-00000005nFq-36w0
	for fio@vger.kernel.org;
	Fri, 30 Oct 2026 12:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 4C0801BC0157; Fri, 30 Oct 2026 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Fri, 30 Oct 2026 06:00:01 -0600
Message-Id: <20261030120001.4C0801BC0157@kernel.dk>
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Post: <mailto:fio@vger.kernel.org>
List-Help: <mailto:fio+help@vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
List-Owner: <mailto:fio+owner@vger.kernel.org>
Precedence: list

The following changes since commit f8127399732876749f4855fb35ac3b8693fc7463:

  Merge branch 'zbyrne/gpuaccel-null-backend-fix' of https://github.com/ROCm/fio (2026-10-28 14:14:27 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 4b1bb1e0028b452a5bda33a1e934734be15c2bf4:

  ci: wait for guest SSH readiness (2026-10-29 15:07:49 -0400)

----------------------------------------------------------------
copilot-swe-agent[bot] (1):
      ci: wait for guest SSH readiness

 .github/actions/start-vm/action.yml | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

---

Diff of recent changes:

diff --git a/.github/actions/start-vm/action.yml b/.github/actions/start-vm/action.yml
index a09465ad..486e129a 100644
--- a/.github/actions/start-vm/action.yml
+++ b/.github/actions/start-vm/action.yml
@@ -23,9 +23,6 @@ inputs:
 runs:
   using: "composite"
   steps:
-    - name: install wait-for-it
-      shell: bash
-      run: sudo apt update && sudo apt-get -qq install wait-for-it
     - name: Enable KVM group perms
       shell: bash
       run: |
@@ -47,11 +44,22 @@ runs:
           -nic user,model=virtio-net-pci,hostfwd=tcp::${{ inputs.ssh_fwd_port }}-:22 \
           ${{ inputs.options }} \
           &
-    - name: Wait for VM to boot
+    - name: Wait for SSH to become available
       shell: bash
       run: |
-        wait-for-it localhost:${{ inputs.ssh_fwd_port }} -t 15
-        sleep 3
+        for attempt in {1..60}; do
+          if ssh -q root@localhost -p ${{ inputs.ssh_fwd_port }} \
+              -o BatchMode=yes \
+              -o ConnectTimeout=2 \
+              -o StrictHostKeyChecking=no \
+              -o UserKnownHostsFile=/dev/null true
+          then
+            exit 0
+          fi
+          sleep 1
+        done
+        echo "Timed out waiting for SSH on localhost:${{ inputs.ssh_fwd_port }}" >&2
+        exit 1
     - name: Add guest host key to known_hosts
       shell: bash
       run: |
