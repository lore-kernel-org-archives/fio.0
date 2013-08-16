Return-Path: <fio-owner@vger.kernel.org>
Received: from na3sys010aog110.obsmtp.com ([74.125.245.88]:48582 "EHLO
	na3sys010aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751178Ab3HPFok convert rfc822-to-8bit
	(ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 16 Aug 2013 01:44:40 -0400
From: Ritchie Babaylan <Ritchie.Babaylan@bitmicro.com>
Subject: Encountered Mix Access R/W Problem
Date: Fri, 16 Aug 2013 05:44:37 +0000
Message-ID: <9E26C6259ACF1842A4815F929194EDD36FEDD89F@phex01.corp.bitmicro.com>
References: <CA+8ZFnhapBuTo0U9Loyg=zrGHxf2GGJN2=LTu2Sw0oJWKHNicA@mail.gmail.com>
	<20130813144311.GI25668@kernel.dk>
 <CA+8ZFnhH9Dg7-nsH52KALp1RaREVy51AKkd0_d_m2WPiv4AesA@mail.gmail.com>
In-Reply-To: <CA+8ZFnhH9Dg7-nsH52KALp1RaREVy51AKkd0_d_m2WPiv4AesA@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

I use FIO-2.1.1 in one of my system running a simple workload with the foll=
owing details.
	64KB; 60% Sequential 60% Read; 1-Depth / 1-Job
	64KB; 30% Sequential 60% Read; 1-Depth / 1-Job

The result of the metrics for Read/Write access are zero as reflected on th=
e command line in Windows 7 32-bit. I'd like to seek help why I am getting =
a zero metrics on Read/Write access.

=EF=BF=BD
Thanks,
=EF=BF=BD
Ritchie Babaylan
Advance CORE Engineering
BiTMICRO Networks, Inc.

