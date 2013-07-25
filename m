Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:43064 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755970Ab3GYQpW (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 25 Jul 2013 12:45:22 -0400
Date: Thu, 25 Jul 2013 10:45:18 -0600
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Helping to model this workload
Message-ID: <20130725164518.GG29296@kernel.dk>
References: <CE142CC7.127F5%Antonio.Jose.Rodrigues.Neto@netapp.com>
 <CE142D08.127FB%Antonio.Jose.Rodrigues.Neto@netapp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CE142D08.127FB%Antonio.Jose.Rodrigues.Neto@netapp.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Neto, Antonio Jose Rodrigues" <Antonio.Jose.Rodrigues.Neto@netapp.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On Tue, Jul 23 2013, Neto, Antonio Jose Rodrigues wrote:
> Hi All
> 
> This is neto from Brazil
> 
> How are you?
> 
> I need to model the following workload:
> 
> Sequential Read % 35.0
> Sequential Write % 5.0
> Random Read % 50.0
> Random Write % 10.0
> Random Read Working Set(GB) 1000.0
> Random Write Working Set(GB) 1000.0
> Sequential Read Size(KB) 64KB
> Sequential Write Size(KB) 64KB
> Random Read Size(KB) 8KB
> Random Write Size(KB) 8KB

So that's 85% reads and 15% writes, first part:

rw=randrw
rwmixread=85

and then you have 50/85 reads random and 35/85 reads sequential. That's
roughly 59% reads random. On the writes, you have 10/15 random and 5/15
sequential. That's roughly 67% writes random:

percentage_random=59,67

The latter I just added support for, before it only support a single
setting for reads and writes.

Fio does not support splitting block sizes on a random/sequential basis.
You will have to improvise there.

-- 
Jens Axboe

