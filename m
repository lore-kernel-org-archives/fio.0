Return-Path: <fio-owner@vger.kernel.org>
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:18011 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702AbZCJToa convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Tue, 10 Mar 2009 15:44:30 -0400
Received: from G6W0640.americas.hpqcorp.net (g6w0640.atlanta.hp.com [16.230.34.76])
	(using TLSv1 with cipher RC4-MD5 (128/128 bits))
	(No client certificate requested)
	by g5t0009.atlanta.hp.com (Postfix) with ESMTPS id 560B030370
	for <fio@vger.kernel.org>; Tue, 10 Mar 2009 19:44:29 +0000 (UTC)
From: "Jenkins, Lee" <Lee.Jenkins@hp.com>
Date: Tue, 10 Mar 2009 19:43:47 +0000
Subject: I/O alignment
Message-ID: <4C6CAE54C846144981BCE6F26B203FFA1CB3F68AE8@GVW1098EXB.americas.hpqcorp.net>
References: <499e38d2.fWWZqp8SkMl4HRX/%jens.axboe@oracle.com>
In-Reply-To: <499e38d2.fWWZqp8SkMl4HRX/%jens.axboe@oracle.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Is there a way to control the alignment of I/O offsets? The HOWTO shows bsrange= and bs_unaligned=, but these seem to be related to the size of the I/O, not the offset.

In our lab testing it appears from blktrace dumps that I/Os are boundary-aligned based on the size of the I/O. For example, in a test of 64KB Random Reads all the I/O addresses were multiples of 64KB (128 sectors). This alignment has a profound impact on I/O performance for certain disk array configurations. Ideally we'd like to be able to control the alignment to match our customers' run-time environment.
