Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:41005 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755474Ab3EVMZn (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 22 May 2013 08:25:43 -0400
Date: Wed, 22 May 2013 14:25:25 +0200
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: output - aggregate read bandwitdh
Message-ID: <20130522122525.GK9714@kernel.dk>
References: <OF1E75BC9A.821D96E0-ON80257B6F.003CB4BE-80257B6F.003E2AAA@uk.ibm.com>
 <20130518122211.GM19781@kernel.dk>
 <OF4E37C571.40B0273E-ON80257B6F.005B05C5-80257B6F.005DC361@uk.ibm.com>
 <OFD80C407E.DC45623D-ON80257B6F.007F5485-80257B6F.007FC70E@uk.ibm.com>
 <OFE288D6C7.BEB7BBEB-ON80257B73.002E3467-80257B73.002E896D@uk.ibm.com>
 <20130522085736.GE9714@kernel.dk>
 <OF4C0E9045.FB0B29B3-ON80257B73.0036DB50-80257B73.00373934@uk.ibm.com>
 <20130522101554.GG9714@kernel.dk>
 <20130522101858.GH9714@kernel.dk>
 <OFABB32A79.2C0C3A51-ON80257B73.00423F23-80257B73.0043C1F5@uk.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OFABB32A79.2C0C3A51-ON80257B73.00423F23-80257B73.0043C1F5@uk.ibm.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Edoardo Comar <ECOMAR@uk.ibm.com>
Cc: fio@vger.kernel.org

On Wed, May 22 2013, Edoardo Comar wrote:
> > > So 67bf982340d95ca98098ea050b54b4c7adb116c0 is the first bad commit,
> > > funky. Ah I think I see what it is, hang on.
> > 
> > http://git.kernel.dk/?
> > p=fio.git;a=commit;h=4b20c6814d4742e27a68f8a740a955283869fbcd
> > 
> > If you git pull, you'll get that. Please see if that makes it behave
> > like 2.0.13 for you.
> > 
> 
> Thanks,
> this has fixed the read aggrb reported value to be unreasonably high
> however the value is now significantly lower than 2.0.13  it's about 1/2
> while the write value is very comparable.
> Please find the outputs below.

This is due to the change in thinktime, fixing the unreasonable
latencies. Effectively it reduces your queue depth to what
thinktime_blocks is set to, which is 1 by default. Even if set to the
queue depth, you will still be completely draining the software queue
for every N thinktime_blocks. I'm guessing your device has write caching
enabled, hence the change is basically only apparent on reads. The
writes queue up nicely on the hw side still.

-- 
Jens Axboe

