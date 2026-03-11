Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C026736C5AC
	for <fio@vger.kernel.org>; Wed, 11 Mar 2026 15:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773244341; cv=none; b=Nv0OGJbyl090bPCKRrQZrFjuGvircdGXSUBDsCsCemUMy/JQHK2W9IYsDScolKuk5em+yxnr73fvavala/unQc5e8F28qgVyP9k50UyRd2OuOWNf4VtAmEVQzlvGXFa/nIApEtVXxorFWn2CyyyhiT8rf+K6fSQ7TCxAmziXvnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773244341; c=relaxed/simple;
	bh=n/uHsvsAZZ/63d+GtP03+DoaMzMNjX0koJpJsH/h4Bw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=hw74HZHHuu4W0gO6C5N7vl4g8Ww1pAPLf48VVBbx9JU6UscI4lneOot83O8o3J0RU7MA/w4w5xGt5tKBtH4OYPZDo3UMkFzOQBNWqIJOUflLyd0p1ImeqlOBbbXQtW4SGiGJJNUug+kuJnvqmtmY7mppiVuv8oiHY5TIT/vKxI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RDGgEOzK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RDGgEOzK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773244338;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=PnV16aGKTiEHtdPpGgWRzY7eZw79IrN2qI/tW9Al7Zo=;
	b=RDGgEOzKzpvEcp3c4Dc5YHnPDGKFloCbyyHcUhoPdUSf+dVBmBH11951aQCxfCh0SNkCDu
	JTQc2CrP7qYraVkwJviZvBHWq+RTWXtq3EitZ+U4U5QKjannVelnq6bPI+21MZpsPk8njC
	zCEtrInyRHEPI+AcrUPN3V6Js8o+jBQ=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-398-crI48vK0M7-ecN8nnQoIfg-1; Wed,
 11 Mar 2026 11:52:15 -0400
X-MC-Unique: crI48vK0M7-ecN8nnQoIfg-1
X-Mimecast-MFC-AGG-ID: crI48vK0M7-ecN8nnQoIfg_1773244334
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0868D180044D;
	Wed, 11 Mar 2026 15:52:14 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.89.69])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8F52E180066F;
	Wed, 11 Mar 2026 15:52:11 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: vincentfu@gmail.com,
	axboe@kernel.dk,
	fio@vger.kernel.org
Cc: jvozar@redhat.com,
	jjurca@redhat.com,
	jhladky@redhat.com,
	peterx@redhat.com,
	spetrovi@redhat.com,
	david@kernel.org
Subject: [PATCH v2 0/2] Introduce a page_fault ioengine for MM workflows
Date: Wed, 11 Mar 2026 09:51:10 -0600
Message-ID: <20260311155114.198006-1-npache@redhat.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

This series introduces a new page_fault ioengine for Anonymous memory
testing. This enables using fio’s existing framework and job files for
memory management style workloads without relying on a filesystem. An
example job file is included to demonstrate usage.

The first patch adds the mmap‑backed ioengine that allocates anonymous
memory and copies data on read/write to intentionally trigger faults.

The second patch updates the documentation to guide usage of the new
feature.

V2:
- drop the khugepaged_delay, and all other additional features. This
  provides a clean initial implmentation. Further features will be added
  in future series as we keep testing and discover what will be useful
  for functional and performance testing.
- Changed the byte-by-byte r/w to leverage memcpy
- provide a number of test cases
- hardened the engine by limiting what parameters it can accept,
  preventing undefined or broken behavior
- Use clang-format to adhere to formatting conventions

Signed-off-by: Nico Pache <npache@redhat.com>

Nico Pache (2):
  page_fault: add mmap-backed ioengine for anonymous faults
  Documentation: update the HOWTO to include the page_fault engine

 HOWTO.rst               |   5 ++
 Makefile                |   2 +-
 engines/page_fault.c    | 116 ++++++++++++++++++++++++++++++++++++++++
 examples/page_fault.fio |  60 +++++++++++++++++++++
 4 files changed, 182 insertions(+), 1 deletion(-)
 create mode 100644 engines/page_fault.c
 create mode 100644 examples/page_fault.fio

-- 
2.53.0

