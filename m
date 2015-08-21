Return-Path: <fio-owner@vger.kernel.org>
Received: from mx142.netapp.com ([216.240.21.19]:33342 "EHLO mx142.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752502AbbHUOTd convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Fri, 21 Aug 2015 10:19:33 -0400
From: neto from Brazil <Antonio.Jose.Rodrigues.Neto@netapp.com>
Subject: FIO Histogram - latency
Date: Fri, 21 Aug 2015 14:09:59 +0000
Message-ID: <D1FCA977.D7C4%Antonio.Jose.Rodrigues.Neto@netapp.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E45950BB624FCD4C88136613139B2767@hq.netapp.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi All,

This is neto from Brazil

How are you?

I need to simulate a random IO with jobs=64, iodepth=2, 100 LUNs, 75%
reads and 25% writes (random).

But I need to have a completely histogram for the % of the IOs that
happened in x us ...

Which option in FIO should I use to have something like that?

I checked the man pages and I saw: read_iolog and write_iolog

But I am not sure...

I really appreciate any help on this matter.

Thank you very much,

neto

