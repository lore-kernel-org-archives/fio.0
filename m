Return-Path: <fio-owner@vger.kernel.org>
Received: from mailuogwhop.emc.com ([168.159.213.141]:42294 "EHLO
	mailuogwhop.emc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608AbcA0MVS convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Wed, 27 Jan 2016 07:21:18 -0500
Received: from maildlpprd01.lss.emc.com (maildlpprd01.lss.emc.com [10.253.24.33])
	by mailuogwprd02.lss.emc.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.0) with ESMTP id u0RCLHBl009900
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <fio@vger.kernel.org>; Wed, 27 Jan 2016 07:21:18 -0500
Received: from mailusrhubprd52.lss.emc.com (mailusrhubprd52.lss.emc.com [10.106.48.25]) by maildlpprd01.lss.emc.com (RSA Interceptor) for <fio@vger.kernel.org>; Wed, 27 Jan 2016 07:20:53 -0500
Received: from MXHUB203.corp.emc.com (MXHUB203.corp.emc.com [10.253.68.29])
	by mailusrhubprd52.lss.emc.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.0) with ESMTP id u0RCL3Wv009442
	(version=TLSv1.2 cipher=AES128-SHA256 bits=128 verify=FAIL)
	for <fio@vger.kernel.org>; Wed, 27 Jan 2016 07:21:04 -0500
From: "Ruvinsky, Konstantin" <Konstantin.Ruvinsky@emc.com>
Subject: FW: default value for random_generator
Date: Wed, 27 Jan 2016 12:21:00 +0000
Message-ID: <923FC40148D42D44A828D320CE66E06A01E620@MX204CL01.corp.emc.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

In the description of random_generator=str in HowTo
( http://git.kernel.dk/?p=fio.git;a=blob;f=HOWTO;h=7c24c1b74296aa33cdff97eca9458defd291b6ca;hb=HEAD )
is not written now what is its default value.

Regards

