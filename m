Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BC9233FE27
	for <fio@vger.kernel.org>; Wed,  8 Apr 2026 01:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775611228; cv=none; b=k6mWoap8EZhSZ+6irw8MGgNGYeszJ//40gPNPbIaZ5IWv3sMccph4XQ08hltgBwYv+1v1Iyaq43fRR4h03shDPGuGk+qRBxAZQm5jgNPylLMCbRcoRWXig+qFbIRvnxAfPASy6fwHKhrxPjd1QlnzJc2aooduLKsVhqJ8hGHEME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775611228; c=relaxed/simple;
	bh=YfC/31VYQ7garzB/JquyoBkmikqd956X70K3Hf4ssRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UzTaEclRjWsWskV2XIljnptGgexKHHbhBpHJXb7jLorSHmmCKlXCtLOM08GbyWLyJZq8tD0oVLNo4cIhE2DlqPVB10sK3hRN+CNFj/aSbuccrBicAVqkuuUvKZZvBi+b7OSJ51S1B8rg/iMRAGwEmcpmoq3W6buBRh362aDRjqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Rt+YKEJa; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Rt+YKEJa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775611225;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1S1bOIJpUK3uvl8pG3OMWq8i3B1OyRnFKacQx8ejnfw=;
	b=Rt+YKEJaEcxR5zsDaciyrDjHJxaDuQ8auc5o0l/psvfE7fhNcRJa08clVr9wj/+D4i1uz3
	fKYXWkK3VEVF+S4Zl0VR1B3IGyVaPTtMSrKm30VvHV+hiQcUhuWuyyhqTZm1mryGasBG97
	G2dhAi2IOyWfG30QZQ2yEFuU7+YNSio=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-230-dZk6-jpwOXqQ6UkOfUvqhA-1; Tue,
 07 Apr 2026 21:20:22 -0400
X-MC-Unique: dZk6-jpwOXqQ6UkOfUvqhA-1
X-Mimecast-MFC-AGG-ID: dZk6-jpwOXqQ6UkOfUvqhA_1775611221
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 62F5A1800464;
	Wed,  8 Apr 2026 01:20:21 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.22.76.19])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C00A619560A6;
	Wed,  8 Apr 2026 01:20:16 +0000 (UTC)
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
Subject: [PATCH v3 2/2] Documentation: update the documentation to include the page_fault engine
Date: Tue,  7 Apr 2026 19:20:03 -0600
Message-ID: <20260408012004.198115-3-npache@redhat.com>
In-Reply-To: <20260408012004.198115-1-npache@redhat.com>
References: <20260408012004.198115-1-npache@redhat.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Document the new page fault engine.

Signed-off-by: Nico Pache <npache@redhat.com>
---
 HOWTO.rst | 5 +++++
 fio.1     | 5 +++++
 2 files changed, 10 insertions(+)

diff --git a/HOWTO.rst b/HOWTO.rst
index 5e3266df..bb97ee22 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -2379,6 +2379,11 @@ I/O engine
 			several instances to access the same device or file
 			simultaneously, but allow it for threads.
 
+		**page_fault**
+			I/O engine that uses an mmap region to simulate data transfer by
+			allocating anonymous memory and copying data on read/write to
+			intentionally trigger page faults.
+
 	File/directory operation engines define how the job operates file or directory. The
 	following types are defined:
 
diff --git a/fio.1 b/fio.1
index 664d7e3b..14ea6427 100644
--- a/fio.1
+++ b/fio.1
@@ -2168,6 +2168,11 @@ instance is used per process, so all jobs setting option \fBthread\fR will share
 a single instance (with one queue per thread) and must specify compatible
 options. Note that some drivers don't allow several instances to access the same
 device or file simultaneously, but allow it for threads.
+.TP
+.B page_fault
+I/O engine that uses an mmap region to simulate data transfer by allocating
+anonymous memory and copying data on read/write to intentionally trigger page
+faults.
 .RE
 .P
 File/directory operation engines define how the job operates file or directory.
-- 
2.53.0

