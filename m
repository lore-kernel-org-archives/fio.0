Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:38787 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466Ab2FOGt4 (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 15 Jun 2012 02:49:56 -0400
Message-ID: <4FDADB0C.5040308@kernel.dk>
Date: Fri, 15 Jun 2012 08:49:48 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: FIO r/w to 2 disks
References: <4E57E183169EA04186759995F13BDC621A18A7C7@FMSMSX103.amr.corp.intel.com> <4FD998CE.3030705@kernel.dk> <4E57E183169EA04186759995F13BDC6234F46FA9@FMSMSX103.amr.corp.intel.com>
In-Reply-To: <4E57E183169EA04186759995F13BDC6234F46FA9@FMSMSX103.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Strickland, Carl" <carl.strickland@intel.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 06/15/2012 01:41 AM, Strickland, Carl wrote:
> Hi Jens,
> 
> The test I'm interested in performing would require (I believe) FIO to
> read from one device and write to another in a specified ratio. This
> is different from the rwmix feature in FIO, as I can specify only a
> single device where the reads and writes will take place.
> 
> Assuming that I could achieve the same read/write ratio with two FIO
> instances (one reading from one device and the other writing to a
> different device) as I get using a single FIO instance and rwmix, is
> there a reason--in terms of how reads and writes would be
> performed--that would prevent a valid comparison between the two?

Maybe the flow options would help you? Set up two jobs in a single file,
one reader and one writer. Set up the flow parameters to get your
desired split. See HOWTO, and/or examples/flow to get an idea for how to
use that.

-- 
Jens Axboe

