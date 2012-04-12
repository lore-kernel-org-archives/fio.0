Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:52862 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861Ab2DLHa2 (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 12 Apr 2012 03:30:28 -0400
Received: from brick.kernel.dk ([87.104.106.3] helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.76 #1 (Red Hat Linux))
	id 1SIEU6-0004r0-Lj
	for fio@vger.kernel.org; Thu, 12 Apr 2012 07:30:27 +0000
Received: from [192.168.0.33] (nelson.home.kernel.dk [192.168.0.33])
	by kernel.dk (Postfix) with ESMTPA id D9E76484001
	for <fio@vger.kernel.org>; Thu, 12 Apr 2012 09:30:23 +0200 (CEST)
Message-ID: <4F86842E.4040201@kernel.dk>
Date: Thu, 12 Apr 2012 09:28:46 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Status
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

In case you didn't notice, fio-2.0.7 was tagged yesterday. After
tagging 2.0.7, I pulled in a few changes from the gfio branch
that you might like to know about.

One is the ability to dump the normal end output while fio keeps
running. This is useful for long running jobs, where you might
like to know what's going on outside of just the IOPS and throughput
numbers etc. If you send the master fio process a USR1 signal,
it'll display the normal end of job output now and continue doing
it's thing. It's done outside of the normal IO paths and by a
separate thread off the signal, so impact on the actual job should
be minimal.

Another change is the inclusion of parts of the git sha in the
fio version output. It used to just be fio-2.0.6 for any version
between 2.0.6 and 2.0.7, but now it also includes the current
git sha:

axboe@nelson:/home/axboe/git/fio $ ./fio --version
fio-2.0.7-5-g8423b

Since some people have scripts that parse the output, I thought
I'd mention it here as well.

Outside of the master branch, gfio has made some progress. It's now
good enough to run existing jobs, either locally or on a remote
machine. There's still a bunch of things missing, like a better
results manager, ability to print output, and actual working support
for editing a job either from scratch or from an existing job file.
If you are interested in this gtk2/3 frontend for fio, I'd
encourage you to give it a shot. It's mostly for developers at this
point, but any sort of input would be useful.

-- 
Jens Axboe

