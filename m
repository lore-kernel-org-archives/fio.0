Return-Path: <fio-owner@vger.kernel.org>
Received: from mailuogwhop.emc.com ([168.159.213.141]:36090 "EHLO
	mailuogwhop.emc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752025Ab3INFx4 convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Sat, 14 Sep 2013 01:53:56 -0400
From: "Ruvinsky, Konstantin" <Konstantin.Ruvinsky@emc.com>
Date: Sat, 14 Sep 2013 01:53:35 -0400
Subject: RE: [PATCH V2] Adds verify_only option.
Message-ID: <EEF9E3C12F20174DA289A981D6CCA6C8324A3CBF95@MX44A.corp.emc.com>
References: <1379102838-10185-1-git-send-email-jcasse@chromium.org> 
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Juan Casse <jcasse@chromium.org>, "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi Juan,

I removed the second question - understood what you meant.

Regards
Konstantin

-----Original Message-----
From: Ruvinsky, Konstantin 
Sent: Saturday, September 14, 2013 8:34 AM
To: 'Juan Casse'; 'fio@vger.kernel.org'
Subject: RE: [PATCH V2] Adds verify_only option.

Hi Juan,

Two questions:
1. How fio knows where is the last block (where to stop verification run)? Please let me know if I understand it correctly: because lfsr runs without duplicated blocks then number of iterations is device_size/block_size.
2. You wrote: "The verify_only option performs only verification (reads performed in do_verify()) and no read or write workload". But for verification, even if you made dry run till the end, you need to read. I don't follow.

Regards
Konstantin

-----Original Message-----
From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On Behalf Of Juan Casse
Sent: Friday, September 13, 2013 11:07 PM
To: Jens Axboe
Cc: Grant Grundler; fio@vger.kernel.org; Juan Casse
Subject: [PATCH V2] Adds verify_only option.

The verify_only option performs only verification (reads performed in do_verify()) and no read or write workload. The goal is to verify previously written meta data quickly and be able to detect stale data.
Without this option, fio does not detect stale data from previous fio runs---only data corruption of "misplaced" data.

This option replays the specified write workload sequence in order to compute the "generation number" (using numberio field) for each block header that was written in a previous fio run. The numberio field is used to detect stale data. do_verify() checks numberio only in the last iteration, after the correct numberio for each block has been computed.
