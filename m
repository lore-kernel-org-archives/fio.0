Return-Path: <fio-owner@vger.kernel.org>
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:39427 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555AbaBYUr0 convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Tue, 25 Feb 2014 15:47:26 -0500
Received: from g4t3426.houston.hp.com (g4t3426.houston.hp.com [15.201.208.54])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by g9t1613g.houston.hp.com (Postfix) with ESMTPS id A0BE66255F
	for <fio@vger.kernel.org>; Tue, 25 Feb 2014 20:47:25 +0000 (UTC)
Received: from G4W6310.americas.hpqcorp.net (g4w6310.houston.hp.com [16.210.26.217])
	(using TLSv1 with cipher AES128-SHA (128/128 bits))
	(No client certificate requested)
	by g4t3426.houston.hp.com (Postfix) with ESMTPS id C53653C6
	for <fio@vger.kernel.org>; Tue, 25 Feb 2014 20:47:15 +0000 (UTC)
From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: iodepth_batch default 1 or iodepth
Date: Tue, 25 Feb 2014 20:45:50 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B4029548AB248@G9W0745.americas.hpqcorp.net>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

fio.1 says the default value for iodepth_batch is iodepth, but HOWTO says it defaults to 1 and options.c defaults to 1.  Which is intended?  

The value is not displayed in the fio output anywhere, so it's unclear what you're getting unless you specify a value.

fio.1:
       iodepth_batch=int
              Number of I/Os to submit at once.  Default: iodepth.

HOWTO:
iodepth_batch_submit=int
iodepth_batch=int This defines how many pieces of IO to submit at once.
                It defaults to 1 which means that we submit each IO
                as soon as it is available, but can be raised to submit
                bigger batches of IO at the time.

options.c:
        {
                .name   = "iodepth_batch_complete",
                .lname  = "IO Depth batch complete",
                .type   = FIO_OPT_INT,
                .off1   = td_var_offset(iodepth_batch_complete),
                .help   = "Number of IO buffers to retrieve in one go",
                .parent = "iodepth",
                .hide   = 1,
                .minval = 0,
                .interval = 1,
                .def    = "1",
                .category = FIO_OPT_C_IO,
                .group  = FIO_OPT_G_IO_BASIC,
        },

---
Rob Elliott    HP Server Storage





