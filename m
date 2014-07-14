Return-Path: <fio-owner@vger.kernel.org>
Received: from na3sys010aog109.obsmtp.com ([74.125.245.86]:47246 "EHLO
	na3sys010aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754648AbaGNMWz convert rfc822-to-8bit
	(ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 14 Jul 2014 08:22:55 -0400
From: Ritchie Babaylan <Ritchie.Babaylan@bitmicro.com>
Subject: Generate Terse Output at specific time interval
Date: Mon, 14 Jul 2014 12:22:49 +0000
Message-ID: <9E26C6259ACF1842A4815F929194EDD394B5AC14@phex01.corp.bitmicro.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "'fio@vger.kernel.org'" <fio@vger.kernel.org>

Hi,

Does FIO has a feature that can generate terse output (i.e. IOPS, throughpu=
t, latency) at specific interval (say, every 1-sec or every 10-sec or every=
 T-sec)?

If none, will this be added in the future?

The reason I ask is because I bumped to one of a software called vdbench wh=
ich can be able to generate the results based from user defined interval. T=
he only catch that I see in vdbench is in relation to accesses below 32KB--=
-it seems vdbench is capping it.

Appreciate feedback on this matter.

=EF=BF=BD
Thanks,
=EF=BF=BD
Ritchie Babaylan
Advance CORE Engineering
BiTMICRO Networks, Inc.

