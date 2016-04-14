Return-Path: <fio-owner@vger.kernel.org>
Received: from mx2.ssi.samsung.com ([207.140.43.206]:50558 "EHLO
	mx2.ssi.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754797AbcDNSoq convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Thu, 14 Apr 2016 14:44:46 -0400
Received: from ssiexch-casht2.ssi.samsung.com ([105.128.134.61]) by mx2.ssi.samsung.com with ESMTP id cr087N5YspeBR2Kl for <fio@vger.kernel.org>; Thu, 14 Apr 2016 11:44:44 -0700 (PDT)
From: "TK (Tzung-Kwang) Wang-SSI" <tk.wang@ssi.samsung.com>
Subject: sector size other than 512 bytes
Date: Thu, 14 Apr 2016 18:44:07 +0000
Message-ID: <6970D64051BC6047987810C1EE37A0351B6956EA@SSIEXCH-MB3.ssi.samsung.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi All,

I have been using FIO on SATA drives for some times and all were fine until recently I added SAS drives to the test list. Some of the SAS drives have 520-byte sector size, with DIF, and my FIO setup was not able to run on those drives. I have not found related postings in archive for possible workaround. My had also upgrade from v2.1.14 to v2.8 with the same result.

Is there a patch available for supporting sector size other than 512-byte for either Windows 7 and/or Ubuntu 14 LTS environment?

Thanks,
TK

