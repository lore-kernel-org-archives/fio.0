Return-Path: <fio-owner@vger.kernel.org>
Received: from mxi1.enovance.com ([94.143.114.217]:35283 "EHLO
	mxi1.enovance.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756032Ab3JJVBD (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 10 Oct 2013 17:01:03 -0400
Message-ID: <5257158A.2050707@enovance.com>
Date: Thu, 10 Oct 2013 23:00:58 +0200
From: Erwan Velu <erwan@enovance.com>
MIME-Version: 1.0
Subject: Re: IO scheduler
References: <CAAAK+WXw_-gAJL9u9Bibvz=4aHVH2YYvgQRi2sMvekY6xDRR4A@mail.gmail.com> <52571453.4050101@nellans.org>
In-Reply-To: <52571453.4050101@nellans.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: David Nellans <david@nellans.org>
Cc: "Brian L." <brianclam@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

On 10/10/2013 22:55, David Nellans wrote:
> [...]
> init 1 is overkill.  In a previous life doing a lot of measuring of 
> flash - I found that simply making sure the machine was "idle" you 
> could get easily get repeatability within 1% for devices doing several 
> hundred thousand IOPS, even those with on-load architectures that were 
> sensitive to CPU usage.
On my side, I've been creating a specific ramfs that does the fio 
testing I want. This way I'm sure that nothing else is running on my 
system (like daemons or gui stuff).

That's a little bit extreme but it insures the same OS & environment to 
be used over & over making all my tests much more comparable over time.

My 2 cents,

Erwan,
