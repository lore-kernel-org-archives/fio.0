Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:49749 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861Ab2DLHc6 (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 12 Apr 2012 03:32:58 -0400
Received: from canuck.infradead.org ([2001:4978:20e::1])
	by merlin.infradead.org with esmtps (Exim 4.76 #1 (Red Hat Linux))
	id 1SIEWX-0000Pd-Sp
	for fio@vger.kernel.org; Thu, 12 Apr 2012 07:32:57 +0000
Received: from brick.kernel.dk ([87.104.106.3] helo=kernel.dk)
	by canuck.infradead.org with esmtpsa (Exim 4.76 #1 (Red Hat Linux))
	id 1SIEWW-0007kN-6S
	for fio@vger.kernel.org; Thu, 12 Apr 2012 07:32:56 +0000
Received: from [192.168.0.33] (nelson.home.kernel.dk [192.168.0.33])
	by kernel.dk (Postfix) with ESMTPA id AB27B484001
	for <fio@vger.kernel.org>; Thu, 12 Apr 2012 09:32:54 +0200 (CEST)
Message-ID: <4F8684C5.8060308@kernel.dk>
Date: Thu, 12 Apr 2012 09:31:17 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Quote of the day
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

Thought I'd share this one with you, it's from Linus:

----

[...] get Jens' FIO code. It does things right, including writing
actual pseudo-random contents, which shows if the disk does some
"de-duplication" (aka "optimize for benchmarks):

http://freecode.com/projects/fio

Anything else is suspect - forget about bonnie or other traditional
tools.

----

-- 
Jens Axboe

