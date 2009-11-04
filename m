Return-Path: <fio-owner@vger.kernel.org>
Received: from [95.166.99.235] ([95.166.99.235]:45600 "EHLO kernel.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754295AbZKDR32 (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 4 Nov 2009 12:29:28 -0500
Date: Wed, 4 Nov 2009 18:29:33 +0100
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Add extra_buff_count flag
Message-ID: <20091104172932.GD8742@kernel.dk>
References: <66dfd3fe0911031633s5bef0621g99b4164c2dd174d9@mail.gmail.com> <20091104073525.GQ8742@kernel.dk> <66dfd3fe0911040912s377b8b0eqb81fa3cad3db2d2f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <66dfd3fe0911040912s377b8b0eqb81fa3cad3db2d2f@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Radha Ramachandran <radha@google.com>
Cc: fio@vger.kernel.org

On Wed, Nov 04 2009, Radha Ramachandran wrote:
> Yes, iodepth=x works. I did not realise that I could use iodepth with
> sync engine as well.

Good, we should probably default iodepth to verify_async + 1, if a
higher number isn't given. And/or document that you probably want to do
this.

-- 
Jens Axboe

