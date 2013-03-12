Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:48417 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285Ab3CLMKD (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 12 Mar 2013 08:10:03 -0400
Date: Tue, 12 Mar 2013 13:09:31 +0100
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] Fix verification and spin bugs
Message-ID: <20130312120931.GK25165@kernel.dk>
References: <1363076915-1140-1-git-send-email-apyrgio@grnet.gr>
 <1363076915-1140-2-git-send-email-apyrgio@grnet.gr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363076915-1140-2-git-send-email-apyrgio@grnet.gr>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Alex Pyrgiotis <apyrgio@grnet.gr>
Cc: fio@vger.kernel.org

On Tue, Mar 12 2013, Alex Pyrgiotis wrote:
> Changes:
> 
> 1. Verification now works properly and reports for which value it fails
> 2. Fix a mishandling of spin incrementation which led to multiple
> calculation of the same values

Thanks, applied.

-- 
Jens Axboe

