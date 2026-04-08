Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C80C92EACF2
	for <fio@vger.kernel.org>; Wed,  8 Apr 2026 01:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775611216; cv=none; b=QqCJqDPHGlHdcMf58K9s8yLK2/knN5DYjHeQ6t9gK6OMsJzKeCCd8q86qQqyScvo96a91SjV8pC4tX2diW/s6dSmeABrvCShFU0BB3cifWH+xGltxRxcZlEV+dLxWqRwKrymq85IIqBpUWaKjtO3H/0rhYWvilhkW2ySDhv/VPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775611216; c=relaxed/simple;
	bh=1oU2I9oahfO1vIyAiEFN8NU74suIv78uy67xV9B4pfo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=RdjuwsegZGg28ELo2cSHLVoO2F3NetSHtWVQ4nP/x7gCPx2pAAxERFiM+XYFRYB8glWh64K5KBoq+JIz50UvTG5MbVFkAf/lrBZfbmtGN7J0pLkLLsnxrVgnCjoREQUecAQtgy/rcX7YOWRfYsAtoPBPXxLBp4dpkr/HVm2Og/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BA47Ht+l; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BA47Ht+l"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775611213;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Nhe2rdpeJJmTPtiTmgrveWPnh+c3PlFs9kFoRjfIOSM=;
	b=BA47Ht+lhX/72aU0Ttf4JYo1QPBEIQtc+t/vyldklL5i+mVMIPOYaLEC9RLTA3zcpDFh/5
	gDsSZ3MRG6xwyw1HIQfTPx8Doye/aesb0pNXDaStHHIRjX1RjLGSKD1YwqOtCvUM4SIStm
	2wTmXqITt3Xl4D+OeOh7/XYycXM6T2Q=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-244-00znXrolMz-0849grASSbA-1; Tue,
 07 Apr 2026 21:20:12 -0400
X-MC-Unique: 00znXrolMz-0849grASSbA-1
X-Mimecast-MFC-AGG-ID: 00znXrolMz-0849grASSbA_1775611211
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9BE141800464;
	Wed,  8 Apr 2026 01:20:10 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.22.76.19])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 99BF719560A6;
	Wed,  8 Apr 2026 01:20:03 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: vincentfu@gmail.com,
	axboe@kernel.dk,
	fio@vger.kernel.org
Cc: jvozar@redhat.com,
	jjurca@redhat.com,
	jhladky@redhat.com,
	peterx@redhat.com,
	spetrovi@redhat.com,
	npache@redhat.com,
	david@kernel.org
Subject: [PATCH v3 0/2] page_fault: add mmap-backed ioengine for anonymous faults
Date: Tue,  7 Apr 2026 19:20:01 -0600
Message-ID: <20260408012004.198115-1-npache@redhat.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

This series introduces a new page_fault ioengine for Anonymous memory
testing. This enables using fio’s existing framework and job files for
memory management style workloads without relying on a filesystem. An
example job file is included to demonstrate usage and lays the groundwork
for how we plan on utilizing fio to test a number of MM related workloads.

The first patch adds the mmap‑backed ioengine that allocates anonymous
memory and copies data on read/write to intentionally trigger faults.

The second patch updates the documentation to guide usage of the new
feature.

V3:
- Correctly use clang-format to adhere to formatting conventions
- check (and fail/warn) if user sets the start_offset
- directly utilize io_ops_data as there is no files
- updated error/print to follow proper format
- Copy docs update to fio.1

V2: https://lore.kernel.org/fio/20260311155114.198006-1-npache@redhat.com/
V1: https://lore.kernel.org/fio/20260129184302.34887-1-npache@redhat.com/

Signed-off-by: Nico Pache <npache@redhat.com>

Nico Pache (2):
  page_fault: add mmap-backed ioengine for anonymous faults
  Documentation: update the documentation to include the page_fault
    engine

 HOWTO.rst               |   5 ++
 Makefile                |   2 +-
 engines/page_fault.c    | 125 ++++++++++++++++++++++++++++++++++++++++
 examples/page_fault.fio |  60 +++++++++++++++++++
 fio.1                   |   5 ++
 5 files changed, 196 insertions(+), 1 deletion(-)
 create mode 100644 engines/page_fault.c
 create mode 100644 examples/page_fault.fio

-- 
2.53.0

