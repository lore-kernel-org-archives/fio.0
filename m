Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D16413AA1B2
	for <fio@vger.kernel.org>; Wed, 21 Jan 2026 16:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769011977; cv=none; b=bVYTbKslA6Ci27CKi6QEyzyc5EcYLaAPgaqh19La94ti+QispqiZKQOtDkDIoY1ogNgF93IeO8cJy85cvlbnZjYHebesKktpi6r2XSskXBAHPpIfcG7DCZjs8mR3SvxqM+zBEID7F8zxj7u3u7lXvgS39tPvfy63T/8fJMveVBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769011977; c=relaxed/simple;
	bh=wjunn4+x2QEs4HRrQcozT7INn2DM0lGSHIZkmkDz3T0=;
	h=From:Content-Type:Mime-Version:Subject:Message-Id:Date:To; b=fY7m58FO6dli3+dXdpwW7NOOaq4FmJT6zo4jMSWYqgTJrmqIcTjTiL0IIwW4CNntq5oMKQWkez6k+RLeZfbQM044PmPPgrxVVJlbfXGIRIFgLj/Ddb7AOVruXhQnjTPa7suLkOBMf3/77ijah/MCp/T5F23h6a3HS/HPG9ry4cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=web_rene@gmx.de header.b=B7DprpPj; arc=none smtp.client-ip=212.227.15.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=web_rene@gmx.de header.b="B7DprpPj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1769011972; x=1769616772; i=web_rene@gmx.de;
	bh=wjunn4+x2QEs4HRrQcozT7INn2DM0lGSHIZkmkDz3T0=;
	h=X-UI-Sender-Class:From:Content-Type:Content-Transfer-Encoding:
	 Mime-Version:Subject:Message-Id:Date:To:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=B7DprpPj61VMTlrfjkQSpSm3V+gwEtN4JbYodiTseQyt/wLsykroDtIZuDLxaPin
	 UbF3QRQLP/jPoKcsCPdkyfqoI7f9lrX3r1f4RQU1bzTdtObQVlZzQXjmaLbyiRv4P
	 m2KVrYvQY2jOdny5SsUoDmkXurmq5GuQlkDIs4J6FEHpPmL/7IFoPdZDHX+/Ty4GZ
	 u9RXV/C5F70SAq8Ymo0x02dI4MyCKNTzPTPf0Ujts/JHcuGUVFnQeNDajfeIelsum
	 g64AGz2QMf4eRGFr/Q0siDQOvvFelcip+KsPACdzFpDjrbOP1B3d02E2KfK1Kohad
	 l26wKOvW8mCzQLnrjg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from smtpclient.apple ([82.98.92.2]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MkHQh-1wBHkT3ZsX-00jWdF for
 <fio@vger.kernel.org>; Wed, 21 Jan 2026 17:12:52 +0100
From: =?utf-8?Q?Ren=C3=A9_Weber?= <web_rene@gmx.de>
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.300.41.1.7\))
Subject: unsubscribe
Message-Id: <06147D4A-0A9E-4DD1-8A2E-8925CDDF1EB7@gmx.de>
Date: Wed, 21 Jan 2026 17:12:42 +0100
To: fio@vger.kernel.org
X-Mailer: Apple Mail (2.3864.300.41.1.7)
X-Provags-ID: V03:K1:ZERa9FlHooR9e2d4TQ7b1fFyd4rLsiRtrfouAayLek2mwuLvAot
 fWrUpze+uKvv8xH00z1dE+YJ8BQeW9O/iRdtyCJ6uGc25x6hGHyI4vr3i99xzQfDLzKgfmn
 4rnUJ+IOt7YYO3ZSR+OQPcOEKcmxa5g9VLMM5z56aFZHETMNrsy3TZ9DwD1GYNfu5uNYgy3
 6yy8Qj8eVFRlY3u6HejDA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:qvPyhouHGs8=;r5Og4XVUfxuc04Z5K9VzDjYWsS0
 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
 eYq0CUIBwnYbjA==

unsubscribe
