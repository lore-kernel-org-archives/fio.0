Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:38499 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314Ab3H0RAP (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 27 Aug 2013 13:00:15 -0400
Message-ID: <521CDB11.8080903@kernel.dk>
Date: Tue, 27 Aug 2013 11:00:01 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] LFSR: Do not ignore returning the seed
References: <1377553942-6835-1-git-send-email-apyrgio@grnet.gr> <1377553942-6835-2-git-send-email-apyrgio@grnet.gr>
In-Reply-To: <1377553942-6835-2-git-send-email-apyrgio@grnet.gr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Alex Pyrgiotis <apyrgio@grnet.gr>
Cc: fio@vger.kernel.org

On 08/26/2013 03:52 PM, Alex Pyrgiotis wrote:
> Fix a situation where we would spin prematurely and would hop over the
> seed value.
> 
> Also, add some more comments to the code.
> 
> Signed-off-by: Alex Pyrgiotis <apyrgio@grnet.gr>

Applied, thanks.

-- 
Jens Axboe

