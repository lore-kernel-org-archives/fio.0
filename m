Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:40527 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759046Ab3GZOYb (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 26 Jul 2013 10:24:31 -0400
Message-ID: <51F28685.1050307@kernel.dk>
Date: Fri, 26 Jul 2013 08:24:05 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Helping to model this workload
References: <CE17FDFB.12F1B%Antonio.Jose.Rodrigues.Neto@netapp.com>
In-Reply-To: <CE17FDFB.12F1B%Antonio.Jose.Rodrigues.Neto@netapp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Neto, Antonio Jose Rodrigues" <Antonio.Jose.Rodrigues.Neto@netapp.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 07/26/2013 08:22 AM, Neto, Antonio Jose Rodrigues wrote:
> Would be nice if we could specify?
> Iodepth for sequential and random

That would be easy enough to add.

> Numjobs for sequential and random (for example: I would like to have 16
> jobs doing random and 1 job only doing sequential)

That's pretty easy to do manually by just having the two sections in the
job file.

-- 
Jens Axboe

