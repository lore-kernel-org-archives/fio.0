Return-Path: <fio-owner@vger.kernel.org>
Received: from server506e.appriver.com ([50.56.144.35]:51501 "EHLO
	server506.appriver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752270Ab3FZWgq convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Wed, 26 Jun 2013 18:36:46 -0400
Received: from [10.242.229.139] (HELO smtp.exg6.exghost.com)
  by server506.appriver.com (CommuniGate Pro SMTP 6.0.2)
  with ESMTPS id 94926132 for fio@vger.kernel.org; Wed, 26 Jun 2013 17:31:42 -0500
From: Carl Zwanzig <cpz@coraid.com>
Subject: Generating almost-sequential traffic
Date: Wed, 26 Jun 2013 22:31:40 +0000
Message-ID: <A7A1D348E34E024BBC74480FB93A2EAB039C63@DAGN05A-E6.exg6.exghost.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

I need to test some devices with "almost-sequential" data traffic. This would have anywhere from 10 to 50 I/Os in order then either drop one from the sequence "1 2 3 (no 4) 5 6" or transpose two adjacent ones "1 2 (4 3) 5 6". This could be done with an iolog, but that seems both wasteful (huge files, 131k lines/MB) and slow (for reading and processing the files). To properly test, I need to move something like 3-4 Tb in 8k blocks.

It's also inelegant :). 

It looks like a drop sequence can be done with something like:
	blocksize=64k
	rw=write:8k
but I'm at a loss for how to do transposition.  Could be a hack into the get-next-block code in io_u.c, but I don't see how to actually implement that.

Any ideas (or is an iolog the best way)?

Thanks,

z!
Carl Zwanzig

