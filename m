Return-Path: <fio-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([64.244.102.30]:50839 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751113Ab0LOJd5 (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 15 Dec 2010 04:33:57 -0500
Message-ID: <4D088B7F.3030408@fusionio.com>
Date: Wed, 15 Dec 2010 10:33:51 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: [patch] FreeBSD build broken due to missing -lrt
References: <20101215011940.00001c21@unknown>
In-Reply-To: <20101215011940.00001c21@unknown>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Bruce Cran <bruce@cran.org.uk>
Cc: fio@vger.kernel.org

On 2010-12-15 02:19, Bruce Cran wrote:
> The latest fio fails to link on FreeBSD because timer_create is in
> librt but the -lrt flag is missing from Makefile.FreeBSD.
> 
> I also noticed a couple of compiler warnings when building with clang -
> a format of "%Lu" is used but 'L' doesn't have any effect with 'u' - I
> guess %llu is needed since the types are 'unsigned long long'?

We can just use %llu, it should be fine. Thanks Bruce, I have applied
your patch.

-- 
Jens Axboe

