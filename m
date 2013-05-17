Return-Path: <fio-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:58509
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754168Ab3EQKuh (ORCPT
	<rfc822;fio@vger.kernel.org>); Fri, 17 May 2013 06:50:37 -0400
Date: Fri, 17 May 2013 12:50:31 +0200
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: latency measurements when adding thinktime
Message-ID: <20130517105031.GY697@kernel.dk>
References: <OF959B9513.E7C6D2A9-ON80257B6D.00837463-80257B6E.0000140D@uk.ibm.com>
 <20130517074751.GS697@kernel.dk>
 <OFDD7AB964.9096D732-ON80257B6E.00324017-80257B6E.0033AE26@uk.ibm.com>
 <20130517102244.GV697@kernel.dk>
 <20130517104305.GW697@kernel.dk>
 <OF939737E8.20889948-ON80257B6E.003B42BD-80257B6E.003B6E91@uk.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OF939737E8.20889948-ON80257B6E.003B42BD-80257B6E.003B6E91@uk.ibm.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Edoardo Comar <ECOMAR@uk.ibm.com>
Cc: fio@vger.kernel.org

On Fri, May 17 2013, Edoardo Comar wrote:
> Many thanks !!!!!!!!!!!
> 
> looking at the history of changes I had spotted that there was a fix for 
> latency reports using rate
> and that is what made me move from 2.0.13 to 2.1

Right, this is essentially the very same bug. Before sleeping, ensure
currently submitted IO have been completed.

-- 
Jens Axboe

