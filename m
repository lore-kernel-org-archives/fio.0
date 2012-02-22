Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:45949 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755531Ab2BVKuf (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 22 Feb 2012 05:50:35 -0500
Message-ID: <4F44C81C.6050300@kernel.dk>
Date: Wed, 22 Feb 2012 11:49:00 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] flow: Fixing uninitialized variable
References: <1329877886-1930-1-git-send-email-dehrenberg@google.com>
In-Reply-To: <1329877886-1930-1-git-send-email-dehrenberg@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Dan Ehrenberg <dehrenberg@google.com>
Cc: fio@vger.kernel.org, nauman@google.com, egouriou@google.com, tirea@google.com

On 02/22/2012 03:31 AM, Dan Ehrenberg wrote:
> In the flow initialization code path, there was an uninitialized
> variable that led to memory corruption in certain cases. This
> patch should initialize the variable properly.

Thanks, I wonder how I missed that. Applied.

-- 
Jens Axboe

