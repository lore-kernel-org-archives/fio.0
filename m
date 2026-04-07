Received: from mailer241.gate86.rs.smtp.com (mailer241.gate86.rs.smtp.com [74.91.86.241])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E4153A5E7B
	for <fio@vger.kernel.org>; Tue,  7 Apr 2026 11:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.91.86.241
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775560213; cv=none; b=otCWIUV4hXkbqDeJFCE0lFkpP6JsrmHsSxlq1nOpWcv43hMhxsRM8AwphhXH96mDs1OWrjiEEbMB9zPWZ1E9IKQHghyvHlAxd6DH/flUwPkNHD8hhLyA9lUiSd/xaubNcJUiuXY7RWLDnly4C6geEqHvffDhuEQeMQEYva9W5HY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775560213; c=relaxed/simple;
	bh=mnFKTG3ghjPFghjEm0CM6iFlaGRkO2USIB9qiiPvoRA=;
	h=From:Subject:To:Content-Type:Date:Message-Id; b=PQFO0w6/KMnxhl4CqNkXVY5UZXJMQbkDRWL9K40q7/a1I0qxIhjQMXsWmkeSruFbMx1HOomKd4x8DoKGAUN5FvS3yxJFqNjUyYGjQe4waQdAYWN0fuqf+1rRci1ZaPcnwF1+XVdQibC7T0BY3kDu6VH23kuy/C0Br4SBpKWhTLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=computergamingpc.com; spf=fail smtp.mailfrom=computergamingpc.com; dkim=pass (2048-bit key) header.d=computergamingpc.com header.i=@computergamingpc.com header.b=XhbwtJ8b; dkim=pass (2048-bit key) header.d=smtpmessage.com header.i=@smtpmessage.com header.b=tnEImDo0; arc=none smtp.client-ip=74.91.86.241
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=computergamingpc.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=computergamingpc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=computergamingpc.com header.i=@computergamingpc.com header.b="XhbwtJ8b";
	dkim=pass (2048-bit key) header.d=smtpmessage.com header.i=@smtpmessage.com header.b="tnEImDo0"
X-Report-Abuse: SMTP.com is an email service provider. Our abuse team cares
 about your feedback. Please contact abuse@smtp.com for further investigation.
Received: from [10.0.16.201] (unknown [10.138.12.33])
	by mtl-mta02-out1 (Halon) with ESMTP
	id 86bca80f-2a39-456e-8a33-c2fd1dff6938;
	Tue, 07 Apr 2026 11:10:11 +0000 (UTC)
Received: Received from 10.138.12.53 by Caffeine (s0-aws-app-swarm-manager-5)
 with SMTP id 2bc9a62d-9fc0-4b40-b303-a5940d768af9  for fio@vger.kernel.org;
  Tue, 07 Apr 2026 11:09:49 +0000 (UTC)
Feedback-ID: 9194450:SMTPCOM
Received: from ObaTech (unknown [50.125.194.31])
	by s0-aws-app-mta-in-2 (Halon) with ESMTPSA
	id 2bc9a62d-9fc0-4b40-b303-a5940d768af9;
	Tue, 07 Apr 2026 11:09:48 +0000 (UTC)
From: "Computer Gaming pc" <sales@computergamingpc.com>
Subject: Q2 Stock Update: Mobile, GPU & Storage Units
To: <fio@vger.kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Reply-To: <sales@computergamingpc.com>
Date: Tue, 7 Apr 2026 12:09:50 +0100
Priority: urgent
X-Priority: 1
Importance: high
Message-Id: <20260704120949B7B5B44E9D-4908662223@computergamingpc.com>
X-SMTPCOM-Sender-ID: 9194450
X-SMTPCOM-Tracking-Number: 2bc9a62d-9fc0-4b40-b303-a5940d768af9
X-SMTPCOM-Message-ID: 79753285-c575-42d8-a000-694352c4bc30
X-SMTPCOM-Payload: 
 r-iAf_Mgr7luOKA1iMHvRjMv7lH41eCh_pwkcMnrrK-9zaFcMDhIPDP-Rh1dDI5BvhB43UT2NUmB672jX1IwFh4tkt77RjwuwC-kjIlzKUWlLyaVW1dQyb8LJs8rz4JbFnwO_ekTnvibKZJlTZW4r-VZEdvT5Ol0s2m6BlNksKgsKTkElUhe5AihDjUK3qvz
List-Unsubscribe-Post: List-Unsubscribe=One-Click
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
 d=computergamingpc.com; i=@computergamingpc.com; q=dns/txt; s=smtpkey;
 t=1775560204; h=feedback-id : from : subject : to : content-type :
 content-transfer-encoding : reply-to : date : message-id :
 list-unsubscribe : list-unsubscribe-post : from : subject : to : date;
 bh=mnFKTG3ghjPFghjEm0CM6iFlaGRkO2USIB9qiiPvoRA=;
 b=XhbwtJ8bpChdcdeC4PFGfiBy8McTUcMpvvH0zxKiyyhIq0b9eChrjtH/pOb4mDWEVMgrv
 e01WG5hWXoaBNx4dim4XSa/kKXyhAVftENyz0cUyLZlsYhYUjVEp8L4qrpLqGdc6ptpyXkq
 oiCG+WN8gnaw90SKIfpaqoLCUgEYujtn8s3+uDlp931vNHHu9bSX+SOIWynzbijrAXlcqR6
 syf2mwCJf70maClRLw9e2EclkXUlC5debVXsmNC4xgrLy9a43fdfnJiscoiwKnJlelKhq9k
 u3QpTdZPTHJ9TpZaIiXX8RQ8jYpYuiFZEnPM04yMoFol7dpeyqxgjbRgtm1g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=smtpmessage.com;
 i=@smtpmessage.com; q=dns/txt; s=smtpcustomer; t=1775560204;
 h=feedback-id : from : subject : to : content-type :
 content-transfer-encoding : reply-to : date : message-id :
 list-unsubscribe : list-unsubscribe-post : from : subject : to : date;
 bh=mnFKTG3ghjPFghjEm0CM6iFlaGRkO2USIB9qiiPvoRA=;
 b=tnEImDo0rb3o0p1TGFezYAKhyMFMEsGvRQ6M2L/09c6c/jQxFoBTLIzKZJXdt21KPreXP
 Xj1xaye+nswn/awA+VgVeMfWdXnwWj6LTAXZVtu02NBeAeFAsGuatQ2cO1kX9yq4Ayb5rcK
 FAGYRXWzHDQSx5rBckTNmo0gY3qaKoWRhEj1UYNnkb98TeU/FXLKR2g6Zx5fJdUkatg+k4F
 kL/Iy8uW/TnEcrKd8DdwMqj+Q1+bXurodKZeNFk5Vp0uLgrhOsogocXKnq5xpLcaivsVDf2
 i9AEInaPRV3y6lpYH52ES2cGMbT4euQx8bJVp1akXciXcrgs6JWC0stDUY8g==
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

Dear Partner,
We’re pleased to share a current snapshot of our available inventory for
immediate dispatch.

Memory Modules
* 32GB 2Rx4 PC4-2400T (Qty: 1,500) – $14
* 32GB 2Rx4 PC4-3200AA (Qty: 1,500) – $15
* 16GB 2Rx8 PC4-3200AA (Qty: 1,500) – $10
* 128GB 4DRx4 DDR4 PC4-2933Y REG ECC LRDIMM (Qty: 980) – $70
* 32GB Dual Rank x4 DDR4-2933 CAS-21 (Qty: 1,500) – $140
* 64GB Dual Rank x4 DDR4-2933 CAS-21 (Qty: 1,200) – $350
* 32GB Dual Rank x4 DDR4-3200 CAS-22 (Qty: 1,500) – $110
* 64GB Dual Rank x4 DDR4-3200 CAS-22 (Qty: 1,100) – $350

Solid State Drives
- SSD SATA 6G 3.84TB SFF (Qty: 450) – $350
- SSD SAS 12G 960GB SFF (Qty: 470) – $300
- SSD SAS 12G 1.92TB SFF (Qty: 560) – $150
- SSD SAS 12G 3.84TB SFF (Qty: 560) – $350
- SSD SATA 6G 1.92TB SFF (Qty: 450) – $150
DDR Modules
- DDR4 32GB 3200Mhz ECC RDimm 2Rx4 P00924-B21 (Qty: 600) – $100
- DDR4 64GB 3200Mhz ECC RDimm 2Rx4 P00930-B21 (Qty: 500) – $350
- DDR5 64GB 4800Mhz ECC RDimm 2Rx4 P43331-B21 (Qty: 500) – $550
- DDR5 64GB 5600Mhz ECC RDimm 2Rx4 P64707-B21 (Qty: 500) – $550
- DDR4 32GB 3200Mhz ECC RDimm 2Rx4 SK Hynix (Qty: 500) – $135
- DDR4 64GB 3200Mhz ECC RDimm 2Rx4 SK Hynix (Qty: 500) – $450
- DDR5 64GB 4800Mhz ECC RDimm 2Rx4 SK Hynix (Qty: 500) – $450
- DDR5 64GB 5600Mhz ECC RDimm 2Rx4 Samsung (Qty: 500) – $550

For quotes, availability, or inspection scheduling, please reach out
directly:
sales@computergamingpc.com
Call or WhatsApp: +1(774) 559-1248 | +1 (641)232-4364
Thank you for your continued partnership.
Jason Denson
Computer Gaming PC Trading
2500 US-6, Iowa City, IA 52240, USA
To unsubscribe from future updates, reply with “REMOVE” in the subject line. 
