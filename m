Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:33866 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754394Ab1KGNPr (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 7 Nov 2011 08:15:47 -0500
Message-ID: <4EB7DA01.6010503@kernel.dk>
Date: Mon, 07 Nov 2011 14:15:45 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] Fix big endian build
References: <20111107224436.3802ff85@kryten>
In-Reply-To: <20111107224436.3802ff85@kryten>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Anton Blanchard <anton@samba.org>
Cc: fio@vger.kernel.org

On 2011-11-07 12:44, Anton Blanchard wrote:
> 
> I get the following error when building fio on PowerPC:
> 
> client.c: In function ‘convert_agg’:
> client.c:641:22: error: invalid operands to binary & (have ‘long double’ and ‘long long unsigned int’)
> 
> It looks like we have things backwards, we should byteswap the
> integer value before we convert it to a double.

Face palm, thanks Anton, applied.

-- 
Jens Axboe

