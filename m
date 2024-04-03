Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55F141420A3
	for <fio@vger.kernel.org>; Wed,  3 Apr 2024 12:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712145611; cv=none; b=J7IKHm+hRkYSEf862RpzDrdpdQR/5EiU/PgjRehgEsHcG4gpAGcJybZkZf3kxzvq4v7Ay2rftRTyWdcpQHidtuxjg7YdLf+9NZB2uzhaHgXmQO3/h/GBxQi9P5+iL+OQYozHvjQ87aUc0agJMKJKwmk1SykhO48wHUXsF2pmUqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712145611; c=relaxed/simple;
	bh=plA+Q7UG9Wg4HwdN66ySEH2TXR08G2z5WhFSFyxq1HM=;
	h=Subject:From:To:Message-Id:Date; b=oLpdUQQ0xh9K63vUbOCWH2LFk29y4dtJgxzf+doIyte4sVSCgPXqtRVdeqQ2GnItC36f7zicrD26fu5odkj1Ev2+GfDvF12snoNNUKxY+V5EyVH+/iBUzIPHzMhUy7QlOhbv9NbzHaW3I8IGGXVlaq3X964hlTVYPw29Z1v+i0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=AYZCxs6G; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="AYZCxs6G"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=r6n6vXVYEg+1oivTdOJS/9wjRVnmnhoSPH1JFWoUeks=; b=AYZCxs6GnyI3IqS5EvTetSG5Xm
	TJrtdqbMdKp+WvjLzxW41u5A1/uZSsjzkyUNMAUkFf0M4LzKbwLl5GIqEjb3gKQq50WMYBRm56Gi9
	OG02XTgjHFFKovu3PDLLAIbV4filHzhXhhzf5aW7P2dzmOgjwY13Fj+r6FXV7GUmn+fh46HwFiblc
	G/+N8O1GUI4VRpFATV5FRAZuNfRyeIOrCUIJFdVNN2G1xbjLxyjiHzLfXbam2ezvIa8PeK5itoEsL
	Bj1zvFhIQYYvH5c2Z7RPBsLfL80FKAAZfr3wZxnWlK9yb2kQ4JWHE/gzT0cveuDx7oCWO2JZ0y4/7
	EKlTbnwg==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rrzHg-00000005W2P-2XOx
	for fio@vger.kernel.org;
	Wed, 03 Apr 2024 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id C90D11BC0174; Wed,  3 Apr 2024 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20240403120001.C90D11BC0174@kernel.dk>
Date: Wed,  3 Apr 2024 06:00:01 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 9213e16d98b0e9d2f8d4f7e760ed0fd45c8960f6:

  Fio 3.37 (2024-03-26 15:13:51 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 4eef23f627d103d7092b4141bd6b0c8f95309ee9:

  howto: fix zonemode formatting (2024-04-02 11:10:58 -0400)

----------------------------------------------------------------
Vincent Fu (1):
      howto: fix zonemode formatting

 HOWTO.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index 6a204072..25fdfbc4 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -985,14 +985,14 @@ Target file/device
 
 		**none**
 				The :option:`zonerange`, :option:`zonesize`,
-				:option `zonecapacity` and option:`zoneskip`
+				:option:`zonecapacity` and :option:`zoneskip`
 				parameters are ignored.
 		**strided**
 				I/O happens in a single zone until
 				:option:`zonesize` bytes have been transferred.
 				After that number of bytes has been
 				transferred processing of the next zone
-				starts. :option `zonecapacity` is ignored.
+				starts. :option:`zonecapacity` is ignored.
 		**zbd**
 				Zoned block device mode. I/O happens
 				sequentially in each zone, even if random I/O
