Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:48167 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050Ab3HARaR (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 1 Aug 2013 13:30:17 -0400
Message-ID: <51FA9B05.5040009@kernel.dk>
Date: Thu, 01 Aug 2013 11:29:41 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Empty block size in iops log files
References: <51FA33DA.70402@enovance.com>
In-Reply-To: <51FA33DA.70402@enovance.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Erwan Velu <erwan@enovance.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 08/01/2013 04:09 AM, Erwan Velu wrote:
> Hi,
> 
> When running fio and ask it to log bandwidth and iops into log file, I
> discovered that the last column of the bandwidth log file is populated
> with the block size while the iops remains to 0.
> 
> Is it an expected behavior ? If not, I can have a look for a patch

You should investigate :-)

-- 
Jens Axboe

