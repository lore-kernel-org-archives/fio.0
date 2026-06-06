Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 335D33859C3
	for <fio@vger.kernel.org>; Sat,  6 Jun 2026 12:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780747216; cv=none; b=j2bv8DSlatuY2AiXN+kA04EXXJnw/tUOxxfBelbcXGCucAwnewyUZEjNnnuR6r++jbCHdKx+m41OhfSknL8vV0sjZsytGcyB94CT4OQ65CWj86d7+rcL8WqodQuSAf6eStztkZB3NG3XW/WXPNwg8hWVp9xbhPi0OeMazvGnZn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780747216; c=relaxed/simple;
	bh=qqLzbTgoMvx8dSXH5j2sLczXOfcGQLf/9f5QlyypNPg=;
	h=Subject:From:To:Date:Message-Id; b=Mphk09pLxHu719KaoyNanZJvd9ygzMgHCP57lDvHuVBdcTJU+Mv5qAA0u6Ut5FjNSr5p85leijh4alDYpP8B8QuGE9+hCw5u3nbUIc8I92k3rdH7tBxczrHktrh7VuWBMbE9ziMEKp3p2DAhiWBItLK+Q1c62rHvrZxjGKoomrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=G7q3kQrp; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="G7q3kQrp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Message-Id:Date:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=lFfYSuubk72BzKlhUQPB9xuhJdfdtXb9W2ByVBn648Y=; b=G7q3kQrpaOsg1ps+VZKrSaWu5w
	076l7LoAFTe2ULYf/JJ9QjLgWnK6AfFcnJMNN0ZV8mWH9LylZfnIgkBIuYRuX8jph1hBN5xGsvYjP
	NTkrgjSSQg8hvedI0+bGNSyntSLP8jelNJyo8B0IuBHRnruTfUFCpT+frU3eO9fo4rhPMv2t0PbxC
	EhDF9fot0zT8uA3eON+hAOPm8OjujjovSI58M+b0F3X9QF2Ja5FfyZx/qkYtz9UW2DqWuwD26KYn8
	foYDl1tvYxVvHfYiApb8xp+7L7cPgDQAaiUWtJxgIp+mKD9k3g/OaqL9kweYfWA8+K0sPbYupCUIl
	HdiqwOZw==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.99.2 #2 (Red Hat Linux))
	id 1wVph7-0000000Gc9q-1km9
	for fio@vger.kernel.org;
	Sat, 06 Jun 2026 12:00:07 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 78CCD1BC0161; Sat,  6 Jun 2026 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Sat,  6 Jun 2026 06:00:01 -0600
Message-Id: <20260606120001.78CCD1BC0161@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 5b476c918091ff15705f3cd26a6a30a2084cd880:

  Merge branch 'master' of https://github.com/wangxp006/fio (2026-06-02 12:27:16 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 5e65f4f03c67016e09111c5cd7b2f5137c126106:

  Merge branch 'fix/metadata-io_uring-doc' of https://github.com/calebsander/fio (2026-06-05 15:34:26 -0600)

----------------------------------------------------------------
Caleb Sander Mateos (1):
      doc: indicate that metadata options are supported with io_uring

Jens Axboe (1):
      Merge branch 'fix/metadata-io_uring-doc' of https://github.com/calebsander/fio

 HOWTO.rst | 8 ++++----
 fio.1     | 8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index bb97ee22..6bf7b29d 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -2737,13 +2737,13 @@ with the caveat that when used on the command line, they must come after the
 	this option is specified, the option :option:`plids` or :option:`fdp_pli` will be
 	ignored.)
 
-.. option:: md_per_io_size=int : [io_uring_cmd] [xnvme]
+.. option:: md_per_io_size=int : [io_uring] [io_uring_cmd] [xnvme]
 
         Size in bytes for separate metadata buffer per IO. For io_uring_cmd
         these buffers are allocated using malloc regardless of what is set for
         :option:`iomem`. Default: 0.
 
-.. option:: pi_act=int : [io_uring_cmd] [xnvme]
+.. option:: pi_act=int : [io_uring] [io_uring_cmd] [xnvme]
 
 	Action to take when nvme namespace is formatted with protection
 	information. If this is set to 1 and namespace is formatted with
@@ -2759,7 +2759,7 @@ with the caveat that when used on the command line, they must come after the
 	it will use the default slower generator.
 	(see: https://github.com/intel/isa-l)
 
-.. option:: pi_chk=str[,str][,str] : [io_uring_cmd] [xnvme]
+.. option:: pi_chk=str[,str][,str] : [io_uring] [io_uring_cmd] [xnvme]
 
 	Controls the protection information check. This can take one or more
 	of these values. Default: none.
@@ -2772,7 +2772,7 @@ with the caveat that when used on the command line, they must come after the
 	**APPTAG**
 		Enables protection information checking of application tag field.
 
-.. option:: apptag=int : [io_uring_cmd] [xnvme]
+.. option:: apptag=int : [io_uring] [io_uring_cmd] [xnvme]
 
 	Specifies logical block application tag value, if namespace is
 	formatted to use end to end protection information. Default: 0x1234.
diff --git a/fio.1 b/fio.1
index 14ea6427..1c572c3c 100644
--- a/fio.1
+++ b/fio.1
@@ -2485,12 +2485,12 @@ multiple devices in a job, all devices of the job will be affected by the scheme
 this option is specified, the option \fBplids\fP or \fBfdp_pli\fP will be ignored.)
 .RE
 .TP
-.BI (io_uring_cmd,xnvme)md_per_io_size \fR=\fPint
+.BI (io_uring,io_uring_cmd,xnvme)md_per_io_size \fR=\fPint
 Size in bytes for separate metadata buffer per IO. For io_uring_cmd these
 buffers are allocated using malloc regardless of what is set for \fBiomem\fR.
 Default: 0.
 .TP
-.BI (io_uring_cmd,xnvme)pi_act \fR=\fPint
+.BI (io_uring,io_uring_cmd,xnvme)pi_act \fR=\fPint
 Action to take when nvme namespace is formatted with protection information.
 If this is set to 1 and namespace is formatted with metadata size equal to
 protection information size, fio won't use separate metadata buffer or extended
@@ -2504,7 +2504,7 @@ For 16 bit CRC generation fio will use isa-l if available otherwise it will
 use the default slower generator.
 (see: https://github.com/intel/isa-l)
 .TP
-.BI (io_uring_cmd,xnvme)pi_chk \fR=\fPstr[,str][,str]
+.BI (io_uring,io_uring_cmd,xnvme)pi_chk \fR=\fPstr[,str][,str]
 Controls the protection information check. This can take one or more of these
 values. Default: none.
 .RS
@@ -2521,7 +2521,7 @@ Enables protection information checking of application tag field.
 .RE
 .RE
 .TP
-.BI (io_uring_cmd,xnvme)apptag \fR=\fPint
+.BI (io_uring,io_uring_cmd,xnvme)apptag \fR=\fPint
 Specifies logical block application tag value, if namespace is formatted to use
 end to end protection information. Default: 0x1234.
 .TP
