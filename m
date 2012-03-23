Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:52197 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864Ab2CWHEe (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 23 Mar 2012 03:04:34 -0400
Message-ID: <4F6C204B.6060301@kernel.dk>
Date: Fri, 23 Mar 2012 08:03:39 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: commandline option to print format of --minimal output
References: <CAPLs8y8Qb4yrPijEaVTukQvPmKDs08wTXVCr4MEYFmBKUrpVSA@mail.gmail.com>
In-Reply-To: <CAPLs8y8Qb4yrPijEaVTukQvPmKDs08wTXVCr4MEYFmBKUrpVSA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Cc: fio@vger.kernel.org

On 03/21/2012 12:04 AM, Lucian Adrian Grijincu wrote:
> Hi,
> 
> Do you think adding a --print-minimal-format commandline option to
> print something like:
> 
> terse-version;fio-version;jobname;groupid;error;read-total-io-kb;read-bw-kb-s;read-iops;read-runtime-msec;read-slat-min;read-slat-max
> ... etc.
> 
> would be useful?

I think it'd be very useful, I like to have as much as the help at-hand
instead of having to go elsewhere to find it. That's why fio has
--cmdhelp and those helpers.

-- 
Jens Axboe

