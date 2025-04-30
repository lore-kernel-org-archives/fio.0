Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62D091D88D0
	for <fio@vger.kernel.org>; Wed, 30 Apr 2025 07:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745999402; cv=none; b=LnFwhWN9loiULrvBxHgXIE1y16tgdMtvdmrwqjrkq4UehT3RUnVJ9W4l/yzumH25iF/1LntUGU8T2nM4kjKukyxxbPTH+xATOZ8SYCTrqP9LJGQ/TagWstn1RqgngWGImHlpvnHlffcQfHp0gx1UPrEkedmG7KPmb35EZefYGZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745999402; c=relaxed/simple;
	bh=EDck1RBbvk1gk7OzHktkxr9TVTNintS6M/lmA+tJ0tk=;
	h=From:Content-Type:Mime-Version:Subject:Message-Id:Date:To; b=Sj0pU+MinnztOyLpZnwsMOjPBNG+R4HyW1gmqWGb3ZMjjQAbV7NwHNEllPxLs+Ouue0BnQnoGYvaTyUDTtogQAoxOiGRRmuEV2N6U9MprgErg5sdStoVYD0vIBftJ18xoTn2wHOdgdXocTXtb+wKeoRlnjjhscLNXk7AQisxMgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=web_rene@gmx.de header.b=CbLBeUco; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=web_rene@gmx.de header.b="CbLBeUco"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1745999397; x=1746604197; i=web_rene@gmx.de;
	bh=EDck1RBbvk1gk7OzHktkxr9TVTNintS6M/lmA+tJ0tk=;
	h=X-UI-Sender-Class:From:Content-Type:Content-Transfer-Encoding:
	 Mime-Version:Subject:Message-Id:Date:To:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=CbLBeUcoHq47ztKDrabixBCgUIq79A0EA2FSK4uDUjSLzm7F/Sl+oOtGsfWxIvgG
	 noXWCxW9f5efn0mz/W406nK69HeoC99Whr9YrxrALkbwhMyHfcRTiH3eRJYQsNKEl
	 CY1KGetQaVt8p1bLIpZBG3e2aYs9pW1YYKK7UkFmWDzc9u58sGgBrtwM+4e7QK3OT
	 14Pddtw0TFAcpReGX3jiDdJ4qTLAntaX8mgpY6b7rdmIcRwgXKGGDv4PjTkYf1Ybi
	 h7PoWRsc8lIYuOQVc6fmsKIcT4hu2MR8991+iDL1gpYoO4TXWiNR3KQbEY2itE3RK
	 iQlr1tt38T48ig8aZA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from smtpclient.apple ([82.98.92.2]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1Mqb1c-1unVob1Lgu-00ftWk for
 <fio@vger.kernel.org>; Wed, 30 Apr 2025 09:49:57 +0200
From: =?utf-8?Q?Ren=C3=A9_Weber?= <web_rene@gmx.de>
Content-Type: text/plain;
	charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.500.181.1.5\))
Subject: Aggregated results too high when using multiple servers via "client"
 command 
Message-Id: <8C4338A1-1AA8-4D3B-B862-DC07F5DB5757@gmx.de>
Date: Wed, 30 Apr 2025 09:49:46 +0200
To: fio@vger.kernel.org
X-Mailer: Apple Mail (2.3826.500.181.1.5)
X-Provags-ID: V03:K1:lhUHEjWj1/ClzFbN/s7OKt/A2Qo+b4PA964kJ4nzRVpd74AlZ0x
 3ewlqsQK+aTtsGjWq7kF9lHeQ+dTp6qS1vlZysycHkQLERO0rUNhaX55VAdLu+O2H9jrzlv
 PwormqL0YYBBHvfI2hpr54rEIYEeHGnP1GDmzWMVFAast5/A7aWSDazYHDgxtH9/2gyPO8U
 EFasb/1e9t/LCoQhUlVig==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:mndNKbcd1z0=;PAGkllKHcH9o++zcWzFtdN5qmVp
 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

I am trying to do a benchmark from multiple clients in order to test the =
performance of a NAS device.
When running the test each of the clients reports a performance of =
~950MB/s. The summarized performance in the log shows 4x950MB/s though =
the NAS device only supports (and shows) a maximum bandwith of 950 MB/s =
in total. To my understanding, the servers I am adressing via =
=E2=80=9Eclient=3Dhost.list=E2=80=9C should generate load in parallel =
which should then reduce each stream to the maximum bandwith supported =
by the NAS divided by the number of clients=E2=80=A6 but somehow each =
client reports the maximum bandwith oft he target and the summary =
therfor is wrong. I tried group_reporting and various other command =
without success.
Any advice here for a newbie?=
