Return-Path: <fio-owner@vger.kernel.org>
Received: from [95.166.99.235] ([95.166.99.235]:43610 "EHLO kernel.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751081AbZKLIFu (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 12 Nov 2009 03:05:50 -0500
Date: Thu, 12 Nov 2009 09:05:55 +0100
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Log bad veify header location
Message-ID: <20091112080555.GX8742@kernel.dk>
References: <66dfd3fe0911111648u17b94ff1sd95fd9e040fca947@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <66dfd3fe0911111648u17b94ff1sd95fd9e040fca947@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Radha Ramachandran <radha@google.com>
Cc: fio@vger.kernel.org

On Wed, Nov 11 2009, Radha Ramachandran wrote:
> Hi,
> Can we please add the bad verify header location when the header
> MAGIC_NUMBER does not match.

Committed, thanks.

-- 
Jens Axboe

