Return-Path: <fio-owner@vger.kernel.org>
Received: from 87-104-106-3-dynamic-customer.profibernet.dk ([87.104.106.3]:49784
	"EHLO kernel.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175Ab1JCHn6 (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 3 Oct 2011 03:43:58 -0400
Received: from [192.168.0.33] (nelson.home.kernel.dk [192.168.0.33])
	by kernel.dk (Postfix) with ESMTPA id D6E8556585
	for <fio@vger.kernel.org>; Mon,  3 Oct 2011 09:43:56 +0200 (CEST)
Message-ID: <4E8967BC.3050404@kernel.dk>
Date: Mon, 03 Oct 2011 09:43:56 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: new developments
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

Those of you tracking git developments may have noticed that
I created a client-server branch and did a bit of hacking
in there. It's not complete yet, but it's the start of splitting
fio into a frontend/backend setup, with the two communicating over
via simple protocol over tcp/ip. This enables you to run fio
servers on test machines, with the frontend being run on your
desktop etc.

I suspect not that many people will be interested in that particular
feature, but it does open up the door for fairly easily writing
new and simple frontends since you can know control fio by sending
commands over even just localhost.

One thing that I think would be very cool is a gtk2 frontend.
Something that allows you to simply click and select options
and then run the job, with graphical representation of the
ETA and final output.

If you have gtk development experience, or simply the desire
to start this project for fio, then please do get in touch.
Otherwise I'll start this myself, once I'm done with the
basic frontend/backend funtionality.

-- 
Jens Axboe

