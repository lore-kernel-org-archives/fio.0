Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C698E2F361A
	for <fio@vger.kernel.org>; Thu, 29 Jan 2026 18:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769712195; cv=none; b=U/sIUAwoDSzswj64CqG2oTIvjhTYb5vHuhsYhh+8U27K05j3A9yt5MJn77egmWhpdoaQC7dkZwHGduXV6a9iBhLhdalWW3gg1SMmtti+7NmTfZDYf1RyN+KPAyeMg0ism0JmKfzGjKK7gvD5u/G1cziPDYv7JrksYFR1l/hZWC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769712195; c=relaxed/simple;
	bh=vOgI4+MTW1NWKnDc2uHZVtNzbAbuv46KNUb3Yx9+VZE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=N2OJYPaqh6BBjILrSKQWrvLQjf+GypxQzij+/9FAf47SZ58zvt8g9du4Tj6UNz95HtA13I5UnuQTzWYF5FyrlUB6ZA7BWLfZOZHcwiJvSbeTx9pfYg5njQKvWhdjGyX/9nEIAyXO6NSajZ3GxguYqgIhaCdWktcd87/S85Aj/SI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=g9NEf2ys; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g9NEf2ys"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769712193;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=mqBy/zCW0V21AZjLbYdtO+S1ZmMBPIPtWn1OjPVXMTg=;
	b=g9NEf2yse5RtCgvO09CnK6luuiPWYORcdOWJBcnyMtVbfnQW6WPT0qO8DBMWOKspzMkvLJ
	g12DkDpHEPeoS9zf7KY+8DZQ4iMRjUgGDBeypz1xft4cha0X2fE4Q11PD2XIxROvXlU8nE
	vZ1d1+4AzxijIsVmfwzAwvWMg2+q+7U=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-536-SvSTnbdJMKWHp_mwIGaEDg-1; Thu,
 29 Jan 2026 13:43:09 -0500
X-MC-Unique: SvSTnbdJMKWHp_mwIGaEDg-1
X-Mimecast-MFC-AGG-ID: SvSTnbdJMKWHp_mwIGaEDg_1769712187
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DA00F180034D;
	Thu, 29 Jan 2026 18:43:06 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.89.167])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 044B93000218;
	Thu, 29 Jan 2026 18:43:04 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: fio@vger.kernel.org
Cc: axboe@kernel.dk,
	vincentfu@gmail.com,
	npache@redhat.com,
	david@kernel.org,
	willy@infradead.org
Subject: [RFC 0/2] Introduce a page_fault ioengine for MM workflows
Date: Thu, 29 Jan 2026 11:42:59 -0700
Message-ID: <20260129184302.34887-1-npache@redhat.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

This series introduces a new page_fault ioengine and a follow‑up option
to make khugepaged behavior more deterministic for page fault testing.

The first patch adds an mmap‑backed ioengine that allocates anonymous
memory and copies data on read/write to intentionally trigger faults.
This enables using fio’s existing framework and job files for memory
management style workloads without relying on a filesystem. An example
job file is included to demonstrate usage.

The second patch adds a hugepage_delay option to the new engine. It
initially maps memory with MADV_NOHUGEPAGE, then (after a configurable
delay) switches to MADV_HUGEPAGE via a helper thread. This makes
khugepaged candidates reproducible, allows for easier khugepaged testing
and improves repeatability for page_fault tests.

Signed-off-by: Nico Pache <npache@redhat.com>

Nico Pache (2):
  page_fault: add mmap-backed ioengine for anonymous faults
  page_fault: add hugepage_delay option for delayed MADV_HUGEPAGE

 Makefile                |   2 +-
 cconv.c                 |   3 +
 engines/page_fault.c    | 185 ++++++++++++++++++++++++++++++++++++++++
 examples/page_fault.fio |   9 ++
 options.c               |  10 +++
 thread_options.h        |   3 +
 6 files changed, 211 insertions(+), 1 deletion(-)
 create mode 100644 engines/page_fault.c
 create mode 100644 examples/page_fault.fio

-- 
2.52.0

