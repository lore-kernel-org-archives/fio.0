Return-Path: <fio-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([64.244.102.31]:51753 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758139Ab1COUUI (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 15 Mar 2011 16:20:08 -0400
Message-ID: <4D7FC9F2.9060300@fusionio.com>
Date: Tue, 15 Mar 2011 21:20:02 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: memory caching
References: <C9A4E18A.10660%hussein@cscs.ch>
In-Reply-To: <C9A4E18A.10660%hussein@cscs.ch>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "N. Harake" <hussein@cscs.ch>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 2011-03-15 09:27, N. Harake wrote:
> 
> I would like to disable completely the caching in memory, trying to
> measure real throughput read/write and iops on filesystem (not raw
> access).  Other than direct=1 is there any flag I could use to obtain
> such complete bypass caching?

direct=1 is the one to use, this controls whether you go through the
page cache or not.

-- 
Jens Axboe

