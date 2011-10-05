Return-Path: <fio-owner@vger.kernel.org>
Received: from 87-104-106-3-dynamic-customer.profibernet.dk ([87.104.106.3]:60503
	"EHLO kernel.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934417Ab1JEMJs (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 5 Oct 2011 08:09:48 -0400
Message-ID: <4E8C490A.8070403@kernel.dk>
Date: Wed, 05 Oct 2011 14:09:46 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] Escape minus signs in manpage to fix lintian warning
References: <201110051146.47562.ms@teamix.de>
In-Reply-To: <201110051146.47562.ms@teamix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Martin Steigerwald <ms@teamix.de>
Cc: fio@vger.kernel.org

On 2011-10-05 11:46, Martin Steigerwald wrote:
> Hi Jens!
> 
> I have patch to fix a recently introduced lintian warning. It is my first
> try with "git format-patch origin" and KMail without line wrappings.
> 
> Please tell me, whether its okay.
> 
> I will include the patch in my debian package until I package a version
> where you merged it.

Thanks, looks fine and it has now been applied.

-- 
Jens Axboe

