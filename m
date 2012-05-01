Return-Path: <fio-owner@vger.kernel.org>
Received: from xyratex198.xyratex.com ([194.131.166.198]:30591 "EHLO
	XY01EX22.xy01.xyratex.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752291Ab2EAOm3 convert rfc822-to-8bit
	(ORCPT <rfc822;fio@vger.kernel.org>); Tue, 1 May 2012 10:42:29 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: rwmixcycle - deprecated?
Date: Tue, 1 May 2012 07:42:25 -0700
Message-ID: <0FEAAA2D70C89D49A62173478A6C4A5D02DED1C8@XYUS-EX22.xyus.xyratex.com>
From: "Roger Sibert" <Roger_Sibert@xyratex.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello Everyone,

Just a sanity check with a twist of question, snippet from log file.

Option rwmixcycle is deprecated
test-1: (g=0): rw=randrw, bs=1M-1M/1M-1M, ioengine=libaio, iodepth=32
2.0.7
Starting 1 process

Just how deprecated is rwmixcycle and if it's truly gone do we need to
update the man page to reflect that fact?

The question with if its deprecated what is the value it's using, I'm
guessing the default that's listed.

Thanks,
Roger

