Return-Path: <fio-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:33865 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752023AbZJUGgB (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 21 Oct 2009 02:36:01 -0400
Date: Wed, 21 Oct 2009 08:36:05 +0200
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: verify_pattern size restriction
Message-ID: <20091021063604.GL10727@kernel.dk>
References: <66dfd3fe0910201827y60bf72c5rcf3375e08cd36e6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <66dfd3fe0910201827y60bf72c5rcf3375e08cd36e6@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Radha Ramachandran <radha@google.com>
Cc: fio@vger.kernel.org

On Tue, Oct 20 2009, Radha Ramachandran wrote:
> Hi,
> Is there a reason why there is a 32 bit size restriction on the
> verify_pattern parameter.
> I have the fio code changes to handle verify_pattern of size <= 512
> bytes, Iam still testing it. But wanted to know if there was any
> special reason for the restriction before I sent the patch out.

Go for it, it's not a design decision :-). So I'll happily take patches
to improve and extend it. Thanks!

-- 
Jens Axboe

