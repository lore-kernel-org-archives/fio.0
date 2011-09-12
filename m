Return-Path: <fio-owner@vger.kernel.org>
Received: from 87-104-106-3-dynamic-customer.profibernet.dk ([87.104.106.3]:46769
	"EHLO kernel.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916Ab1ILIhW (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 12 Sep 2011 04:37:22 -0400
Message-ID: <4E6DC4C1.2050804@kernel.dk>
Date: Mon, 12 Sep 2011 10:37:21 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: runtime option not working similar for all devices
References: <CAKa9NmvPyvyrdbpYaHoo20yu5Gbsq1m_GYzUen2viOUZkJdQHQ@mail.gmail.com>
In-Reply-To: <CAKa9NmvPyvyrdbpYaHoo20yu5Gbsq1m_GYzUen2viOUZkJdQHQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Vikram Seth <seth.vik@gmail.com>
Cc: fio@vger.kernel.org

On 2011-09-12 06:33, Vikram Seth wrote:
> Hi,
> 
> I am testing random reads on raw devices (hdd and flash) in a host. I
> set same runtime value (12 hrs) in test file for each device.
> However, while the test is running the ETA for hdd test (11:53 hrs) is
> shown as more than twice of flash (4:40hrs). Later the test for flash
> completes while the hdd test is still running.
> 
> I thought that having same runtime will cause the test to run for same
> amount of time on all devices.
> Is that not true ?

The runtime option is a runtime cap, meaning that it'll stop the job
after the specified time only. If the job finishes before that (eg you
tell it to do 100g of IO and that takes a shorter time than the runtime
setting), then it'll exit normally.

-- 
Jens Axboe

