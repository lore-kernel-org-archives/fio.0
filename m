Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:46910 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756160Ab3GYTD3 (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 25 Jul 2013 15:03:29 -0400
Message-ID: <51F1766C.2080908@kernel.dk>
Date: Thu, 25 Jul 2013 13:03:08 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Helping to model this workload
References: <CE16EE4A.12D47%Antonio.Jose.Rodrigues.Neto@netapp.com>
In-Reply-To: <CE16EE4A.12D47%Antonio.Jose.Rodrigues.Neto@netapp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Neto, Antonio Jose Rodrigues" <Antonio.Jose.Rodrigues.Neto@netapp.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 07/25/2013 01:02 PM, Neto, Antonio Jose Rodrigues wrote:
> Just to confirm..
> 
> bs_is_seq_rand=1
> 
> bs=64k,4k 
> 
> It's 64K for sequential and 4K for random
> 
> Right?

Correct. If bs_is_seq_rand is set, any READ block size setting is
applied to sequential IO, and any WRITE block size setting is applied to
random IO.

-- 
Jens Axboe

