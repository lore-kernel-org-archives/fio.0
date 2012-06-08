Return-Path: <fio-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:2070 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933436Ab2FHTwi convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Fri, 8 Jun 2012 15:52:38 -0400
From: "Strickland, Carl" <carl.strickland@intel.com>
Subject: FIO r/w to 2 disks
Date: Fri, 8 Jun 2012 19:52:36 +0000
Message-ID: <4E57E183169EA04186759995F13BDC621A18A7C7@FMSMSX103.amr.corp.intel.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi All,

I'm performing a series of time-based storage tests and need FIO to read and
write to separate disks, in the ratio specified (e.g. 80/20).

I've performed initial tests with two FIO instances (one read, one write), but
found that in one scenario I get a ratio of ~50/50 and in another I get
~60/40. However, in order to compare the results of these tests, their ratios
must be approximately equal.

Is it possible to achieve this with a single FIO instance? Do you have any
recommendations for achieving a specific ratio with two FIO instances?

All help is greatly appreciated!


Thanks,
Carl
