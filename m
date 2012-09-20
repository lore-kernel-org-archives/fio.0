Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:52988 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754004Ab2ITLtQ (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 20 Sep 2012 07:49:16 -0400
Message-ID: <505B02A5.6030108@kernel.dk>
Date: Thu, 20 Sep 2012 13:48:53 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] update documentation for falloc and e4defrag engines
References: <1348141037-16303-1-git-send-email-dmonakhov@openvz.org> <1348141037-16303-2-git-send-email-dmonakhov@openvz.org>
In-Reply-To: <1348141037-16303-2-git-send-email-dmonakhov@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: fio@vger.kernel.org

On 09/20/2012 01:37 PM, Dmitry Monakhov wrote:
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  HOWTO              |   20 ++++++++++-
>  examples/e4defrag  |   49 +++++++++++++++++------------
>  examples/e4defrag2 |   88 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  examples/falloc    |   54 ++++++++++++++++++++++++++++++++
>  fio.1              |   29 +++++++++++++++++
>  5 files changed, 218 insertions(+), 22 deletions(-)
>  create mode 100644 examples/e4defrag2
>  create mode 100644 examples/falloc

Excellent, thanks! I've applied this one, as well as the 1/2 fix for the
falloc engine.

-- 
Jens Axboe

