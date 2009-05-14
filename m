Return-Path: <fio-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:53260 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752870AbZENKzG (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 14 May 2009 06:55:06 -0400
Date: Thu, 14 May 2009 12:55:06 +0200
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: close() in fio measurements
Message-ID: <20090514105506.GL4140@kernel.dk>
References: <4A0BEB65.7070406@zresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A0BEB65.7070406@zresearch.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Shehjar Tikoo <shehjart@zresearch.com>
Cc: fio@vger.kernel.org

On Thu, May 14 2009, Shehjar Tikoo wrote:
> Hi Jens
>
> Does fio include  the close() syscall in its measurements?
> This is significant because close() actually does a lot of things
> when the underlying file system is a NFS mount.

Yes, close() is included in the runtime and measurements.

-- 
Jens Axboe

