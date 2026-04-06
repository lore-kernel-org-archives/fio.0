Received: from mailer241.gate86.rs.smtp.com (mailer241.gate86.rs.smtp.com [74.91.86.241])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 370C52FD68B
	for <fio@vger.kernel.org>; Mon,  6 Apr 2026 12:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.91.86.241
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775479027; cv=none; b=rRlOYp0O9kk27q6m4prs/z4LgpuIyZaPGg053vLLx2s+dMP3JGsp6hyAFebCtPIfDuw9vOf1eZrlcPVBaSPctJN+Des1J9lni25WvEDGHEyXj82SC+G/GReq4Es7HxEk7hkw8QG3wnt2tl3luZD/bkEoj6eTrAmJwRmc1mdAElA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775479027; c=relaxed/simple;
	bh=YNDsaGWOkhOdrKMe0PgSvQX0kMs0IYbABFvmO/mGxxc=;
	h=From:Subject:To:Content-Type:Date:Message-Id; b=GHZZgEXovo17WljbR2Gc5GwZo/LfYpl/QKCL/8JW+2QhhxaYyOAYL5pggE80y4ksCh3PoFuZkPBvDoeBGV0VgixT+CuS/pYMjp61IYoyeOHcRc3jaTAghlosZejZiV/dQBYPDLCDc7flmCjg0GDAeFP2Do/31LFrstmNWS8APyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=computergamingpc.com; spf=fail smtp.mailfrom=computergamingpc.com; dkim=pass (2048-bit key) header.d=computergamingpc.com header.i=@computergamingpc.com header.b=BECaH98m; dkim=pass (2048-bit key) header.d=smtpmessage.com header.i=@smtpmessage.com header.b=gY0xQ3Pf; arc=none smtp.client-ip=74.91.86.241
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=computergamingpc.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=computergamingpc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=computergamingpc.com header.i=@computergamingpc.com header.b="BECaH98m";
	dkim=pass (2048-bit key) header.d=smtpmessage.com header.i=@smtpmessage.com header.b="gY0xQ3Pf"
X-Report-Abuse: SMTP.com is an email service provider. Our abuse team cares
 about your feedback. Please contact abuse@smtp.com for further investigation.
Received: from [10.0.16.215] (unknown [10.138.12.203])
	by mtl-mta02-out1 (Halon) with ESMTP
	id 0671b2d5-ae9e-4518-b37f-5fb2a5e43c65;
	Mon, 06 Apr 2026 12:16:59 +0000 (UTC)
Received: Received from 10.138.12.169 by Caffeine
 (s0-aws-app2-swarm-manager-3) with SMTP id
 4b186b83-3119-4876-88bf-6d89b76f8441  for fio@vger.kernel.org;
  Mon, 06 Apr 2026 12:16:32 +0000 (UTC)
Feedback-ID: 9194450:SMTPCOM
Received: from ObaTech (unknown [50.125.194.31])
	by s0-aws-app2-mta-in-2 (Halon) with ESMTPSA
	id 4b186b83-3119-4876-88bf-6d89b76f8441;
	Mon, 06 Apr 2026 12:16:31 +0000 (UTC)
From: "Computer Gaming pc" <sales@computergamingpc.com>
Subject: Q2 Stock Update: Mobile, GPU & Storage Units
To: <fio@vger.kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Reply-To: <sales@computergamingpc.com>
Date: Mon, 6 Apr 2026 13:16:33 +0100
Priority: urgent
X-Priority: 1
Importance: high
Message-Id: <20260604131633A33B81A4D1$7A263A4B65@computergamingpc.com>
X-SMTPCOM-Sender-ID: 9194450
X-SMTPCOM-Tracking-Number: 4b186b83-3119-4876-88bf-6d89b76f8441
X-SMTPCOM-Message-ID: c37b2b08-7ac3-407b-ae47-7307e8379506
X-SMTPCOM-Payload: 
 _MIq3brmR7ulF4AwyF6nBuJVAit_dTGGX24FQ4WNuw9Pn4ddbs4gY1KCKVl_jYYf-CDNw0pc7KVBBH3_AsW_Kr7mUldABDcLd9kaFK4-Ls41P6XzZr_s92BqEm16GdZ-pQkd34yAp5-fQ8TANgLwwHoFEimTPU3Na3vG-LW1OLie8RQ7TlUUTlg-rHtHfsSx
List-Unsubscribe-Post: List-Unsubscribe=One-Click
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
 d=computergamingpc.com; i=@computergamingpc.com; q=dns/txt; s=smtpkey;
 t=1775477803; h=feedback-id : from : subject : to : content-type :
 content-transfer-encoding : reply-to : date : message-id :
 list-unsubscribe : list-unsubscribe-post : from : subject : to : date;
 bh=YNDsaGWOkhOdrKMe0PgSvQX0kMs0IYbABFvmO/mGxxc=;
 b=BECaH98muKCthoCFSpt0AbrWfrlYvGrbQ6Rob6CxaQVRi+NQDcpOqAO1twYFIPylwwIak
 o4j3ZvhImdSTiZWQLi6JlTiMn22yqoACE/RWsLKtzDBx0zQFRs+6yQXVHBTkCnt9pApeDYd
 foGB6RF8KoaVRw/b1Q/NBNj1LzfiMvB5RNNMqGaPT6ufi0JitVRyowrgJok5XfgxhjXcYxc
 uGRPg1siLIhjQTVd38wQjtQinonW/htGscvnH4/+Nt6e7y9AfkXPTMKp+Pt3iHgBkm2QXdB
 PzdNeTQqHSBxArluxoyGJ4SCe3cqLU+C4KatJz2pum/MKyXgCMMbn4jbVI9w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=smtpmessage.com;
 i=@smtpmessage.com; q=dns/txt; s=smtpcustomer; t=1775477803;
 h=feedback-id : from : subject : to : content-type :
 content-transfer-encoding : reply-to : date : message-id :
 list-unsubscribe : list-unsubscribe-post : from : subject : to : date;
 bh=YNDsaGWOkhOdrKMe0PgSvQX0kMs0IYbABFvmO/mGxxc=;
 b=gY0xQ3PfZV9sxU3haoq/oTCjiQ4XSWTcPdd/WbDjhbw6cZTJJJhSllYyyFwatgspqxLy2
 Fmm1tRICv01B9Db4FSBkRij8HcjH22Qy5G6sw+3tXPoFzoxMMhhP9hGF2ggde4XRu57Gvqv
 iY/RMEkA4bfbudDQvPhXXj1+m0rarlUbB7bzrRXfOvgIfhYnpT1gcoPI4rFhIHgSbwlMtmZ
 y4Bg02Nyy34NPcQvRUyXdKezJEjt+dPOvsoDNCLGeM80gllpN4wd7Hjqwm+hcfBzW2baTLB
 IRomYQszEj1BDyV5o7svDLFAgHymrrBFJJC/4EIBZFix8GXKQnDNKvI3SZKg==
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

Dear Partner,
We’re pleased to share a current snapshot of our available inventory for 
immediate dispatch.
Mobile & RFID Devices
Zebra TC53/TC58 (51 units) – $600.00
Honeywell CT477 (51 units) – $600.00
MC9300 (60 units) – $600.00
Zebra TC55 (71 units) – $600.00
Zebra MC9401 (81 units) – $1,100.00
Zebra TC22 Standard Range (80 units) – $500.00
Zebra TC21 (81 units) – $220.00
Zebra RFD40 Premium RFID Reader/Writer (56 units) – $610.00
Honeywell CK65 (86 units) – $600.00

GPUs & Accelerators
RTX 5090 Founders Edition 32GB (90 units) – $2,100.00
RTX Asus/Gigabyte 4090 24GB (45 units) – $1,680.00
RTX 4090 Founders Edition 24GB (90 units) – $2,000.00
RTX A6000 48GB Ada (54 units) – $1,100.00
RTX 6000 48GB Ada (51 units) – $1,200.00
Nvidia L40s GPU (45 units) – $3,000.00
Nvidia H100 80GB PCIe (9 units) – $20,000.00
Storage & CPUs
Samsung PM9A3 2.5" SSD PCIe 4.0 7.68TB (115 units) – $250.00
7.68TB SAS SSD 2.5" 12G Server Drive (140 units) – $250.00

For quotes, availability, or inspection scheduling, please reach out 
directly:
sales@computergamingpc.com
Call or WhatsApp: +1(774) 559-1248 | +1 (641)232-4364
Thank you for your continued partnership.
Jason Denson.
Computer Gaming PC Trading
2500 US-6, Iowa City, IA 52240, USA
