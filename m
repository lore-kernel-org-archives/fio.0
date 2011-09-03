Return-Path: <fio-owner@vger.kernel.org>
Received: from 87-104-106-3-dynamic-customer.profibernet.dk ([87.104.106.3]:46570
	"EHLO kernel.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753773Ab1ICDJf (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 2 Sep 2011 23:09:35 -0400
Message-ID: <4E619A66.4040605@kernel.dk>
Date: Fri, 02 Sep 2011 21:09:26 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Bad performance when reads and writes on same LUN
References: <116197A0179A3D4A95B135E5F0341FC11041B4D8@SACMVEXC2-PRD.hq.netapp.com>
In-Reply-To: <116197A0179A3D4A95B135E5F0341FC11041B4D8@SACMVEXC2-PRD.hq.netapp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Neto, Antonio Jose Rodrigues" <Antonio.Jose.Rodrigues.Neto@netapp.com>
Cc: zhu.yanhai@gmail.com, "Rettl, Matthias" <Matthias.Rettl@netapp.com>, fio@vger.kernel.org

On 2011-09-02 21:06, Neto, Antonio Jose Rodrigues wrote:
> The question that I have is:
> 
> "Buffered aio will fall back to sync io, and it's known that mixing"
> 
> Why did buffered aio will fall back to sync io?

Please don't top post, reply beneat the original text.

Buffered aio will degenerate to normal sync IO, because the kernel does
not support async buffered io.

-- 
Jens Axboe

