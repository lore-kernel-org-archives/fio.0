Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:58682 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842Ab3IPTR1 (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 16 Sep 2013 15:17:27 -0400
Message-ID: <5237593A.8050301@kernel.dk>
Date: Mon, 16 Sep 2013 13:17:14 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: output mutating on me
References: <CAAAK+WVk9ch4PNrfUb8LHwp800T-qTXbH7tr_Tj9GvZh8a0J1A@mail.gmail.com>
In-Reply-To: <CAAAK+WVk9ch4PNrfUb8LHwp800T-qTXbH7tr_Tj9GvZh8a0J1A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Brian L." <brianclam@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 09/13/2013 07:04 PM, Brian L. wrote:
> Just want to seek some advice as this is driving me crazy and I have a
> deadline fast approaching so I am not sure if I can completely change
> course at this point.
> 
> So here's the situation - it looks like different run of fio is giving
> me different output.  The outputs are mutating (reproducible) on me so
> it broken my parser and more importantly, my data because I depend on
> "Completion latency" ('clat') for my calculation.  Ugh.  Maybe if I
> use '--minimal' during the run, it might be better but I am too commit
> to change at this point.
> 
> Note below: the 'clat (usec): min=...' line is missing from the first run.

Is this running as a client/server, or "normal" run directly on the machine?

-- 
Jens Axboe

