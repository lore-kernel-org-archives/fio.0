Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:46873 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757260Ab3GYTCZ (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 25 Jul 2013 15:02:25 -0400
Message-ID: <51F1762C.4090707@kernel.dk>
Date: Thu, 25 Jul 2013 13:02:04 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Helping to model this workload
References: <CE16ED93.12D3F%Antonio.Jose.Rodrigues.Neto@netapp.com>
In-Reply-To: <CE16ED93.12D3F%Antonio.Jose.Rodrigues.Neto@netapp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Neto, Antonio Jose Rodrigues" <Antonio.Jose.Rodrigues.Neto@netapp.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 07/25/2013 12:59 PM, Neto, Antonio Jose Rodrigues wrote:
> Thank you Jens, I appreciate. I will test it.

It is now committed, fwiw.

> Question: How can I access multiple devices for example /dev/sda and
> /dev/sdb?
> 
> Something like = filename=/dev/sda,/dev/sdb?

It's in the documentation, you do:

filename=/dev/sda:/dev/sdb

-- 
Jens Axboe

