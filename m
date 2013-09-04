Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:37154 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761482Ab3IDUMr (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 4 Sep 2013 16:12:47 -0400
Message-ID: <5227943B.2020905@kernel.dk>
Date: Wed, 04 Sep 2013 14:12:43 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] Remove duplicate LDFLAGS on -o lines
References: <1378324827-10970-1-git-send-email-grundler@chromium.org>
In-Reply-To: <1378324827-10970-1-git-send-email-grundler@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Grant Grundler <grundler@chromium.org>
Cc: Juan Casse <jcasse@chromium.org>, fio@vger.kernel.org

On 09/04/2013 02:00 PM, Grant Grundler wrote:
> Only need to list LDFLAGS once on each line. :)

Applied!

-- 
Jens Axboe

