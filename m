Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F27F049365A
	for <fio@vger.kernel.org>; Sat,  5 Sep 2026 12:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788609611; cv=none; b=qttT27YA1R82TKA2a3VdLgXuxOkCrTTN2CN61hrjNznbc2oS4a/mPogDI16zmKjM2zExSdXbTRMePAv3QKrJCcTt0bO59bOZRoYtCQp1KEW+chtTbwID0n0gLbgi00OGAVDa+ppVpV1NFSYMuCIBxtIqccA+GOmekcxxdKipPYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788609611; c=relaxed/simple;
	bh=ssyrT3LlUNQ2498BXXh2def0O+0WE+cC3Tn1PSb4c/E=;
	h=Subject:From:To:Date:Message-Id; b=U5XRjYW0pAGqtuO9hCQ8uoP/Psx6rNDGvKBDaDD2RWEfSyBbrP/qWxBQRnbJ5A4Orc9+3LQ5CIvxh1GPAYpb87coElDZPpLFz6NA7ALrJfnCG9yw+295b848nOJJi5umsvxerJcJab/ZO+a5RpUfNcQ9kaDWs75mNxy8lrMPV6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=kvFfWkex; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kvFfWkex"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Message-Id:Date:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=FM7RX9K5t09TnzRQ+NrF+1xyVzksOG5H4DESAIoWjPs=; b=kvFfWkex/xvY5TVHQBlp8nDT/L
	fYbWhB4X/UorNdrX9jC9ilw3xaKsZgFPdFu2boPjhpKVnF5KtHaUNNqqe3PVXg5xJygVpU1hSE30L
	9OQSjuHKRg85dP4mr5uQfnpP675atM1BmDlfDvHIfxXgs49mfQXD8cVTrDqTerd79b8Ppki5DEPae
	fFGpwsp+ooD8M6cRiDvdAOYO4elx048jcCN2yXb+Nq5TnFWGxll6gr9/TM5sFiz1AegtV/aseDdJa
	7lL+aoNzJzNg0RyC8/qXsRTjkMWt/sVc/Fd3k1dHhEmxRJ3EOpbZbvtqiarUXTmvN+oQ3y53F9R+s
	WTacJIpQ==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x2p40-0000000FHc2-3JHX
	for fio@vger.kernel.org;
	Sat, 05 Sep 2026 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 6FC271BC0178; Sat,  5 Sep 2026 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Sat,  5 Sep 2026 06:00:01 -0600
Message-Id: <20260905120001.6FC271BC0178@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 975ea1856fee9f4c0f01f6f19ba3c61ce24f9bc8:

  Merge branch 'consolidate_commit_call_path' of https://github.com/dennischerchang/fio (2026-09-01 21:48:38 +0000)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to e333e45bd1e7503388d71932af047ecfd22c25da:

  ci: resize image for QEMU tests (2026-09-04 14:04:44 -0400)

----------------------------------------------------------------
Vincent Fu (1):
      ci: resize image for QEMU tests

 .github/actions/create-guest-image/action.yml | 6 ++++++
 1 file changed, 6 insertions(+)

---

Diff of recent changes:

diff --git a/.github/actions/create-guest-image/action.yml b/.github/actions/create-guest-image/action.yml
index 427fb4dd..ca5c6fb1 100644
--- a/.github/actions/create-guest-image/action.yml
+++ b/.github/actions/create-guest-image/action.yml
@@ -26,6 +26,12 @@ runs:
     - name: Download cloud image
       run: wget -q ${{ inputs.image_link }} -O debian.qcow2
       shell: bash
+    - name: Expand partition
+      run: |
+        qemu-img create -f qcow2 debian-expanded.qcow2 8G
+        virt-resize --expand /dev/sda1 debian.qcow2 debian-expanded.qcow2
+        mv debian-expanded.qcow2 debian.qcow2
+      shell: bash
     - name: Customize Debian image
       run: |
         virt-customize -a debian.qcow2 \
